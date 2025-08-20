
import SwiftUI

class ComicCache: ObservableObject {
//    @EnvironmentObject var viewSettings: ViewSettings
    private let comicFile: any ProtocoloComic
    private var pageCache = NSCache<NSNumber, UIImage>()
    @Published var currentPage: Int = 0
    
    // Cola serial para acceso thread-safe
    private let cacheAccessQueue = DispatchQueue(label: "com.cache.keys.access")
    private var _cachekeys = Set<NSNumber>()
    private var prefetchTasks = [Int: DispatchWorkItem]() // Mantener tareas activas
    var cachekeys: Set<NSNumber> {
        get { cacheAccessQueue.sync { _cachekeys } }
        set { cacheAccessQueue.sync { _cachekeys = newValue } }
    }
    
    init(comicFile: any ProtocoloComic) {
        self.comicFile = comicFile
    }
    
    public func printCacheInfo() {
        cacheAccessQueue.sync {
            let cachedPages = _cachekeys.map { $0.intValue }.sorted()
//            print("📄 Páginas en caché (\(_cachekeys.count) en total): \(cachedPages)")
        }
    }
    
    func getImage(for key: Int) -> UIImage? {
        return pageCache.object(forKey: NSNumber(value: key))
    }
    
    func setImage(_ image: UIImage, for key: Int) {
        let keyNumber = NSNumber(value: key)
        self.pageCache.setObject(image, forKey: keyNumber)
        cacheAccessQueue.sync { self._cachekeys.insert(keyNumber) }
//        print("✅ Imagen cacheada - Página \(key)")
        DispatchQueue.main.async { [weak self] in
            self?.objectWillChange.send()
        }
    }
    
    // Ahora se permite especificar el rango de prefetching
    func prefetchNearbyPages(currentPage: Int, range: Int = 5) {
        let lowerBound = max(currentPage - range, 0)
        let upperBound = min(currentPage + range, comicFile.comicPages.count - 1)
        if lowerBound > upperBound { return }
        
        let allIndices = Array(lowerBound...upperBound).filter { $0 != currentPage }
        let existingKeys = cacheAccessQueue.sync { _cachekeys }
        
        // Cancelar tareas fuera del rango visible
        let visibleRange = Set(lowerBound...upperBound)
        prefetchTasks.keys.forEach { index in
            if !visibleRange.contains(index) {
                prefetchTasks[index]?.cancel()
                prefetchTasks.removeValue(forKey: index)
            }
        }
        
        allIndices.forEach { index in
            if !existingKeys.contains(NSNumber(value: index)) {
                let priority: DispatchQoS.QoSClass = abs(currentPage - index) <= 2 ? .userInitiated : .utility
                prefetchPage(index, priority: priority)
            }
        }
    }
    
    func prefetchPage(_ index: Int, priority: DispatchQoS.QoSClass, completion: (() -> Void)? = nil) {
        guard isValidIndex(index), getImage(for: index) == nil else {
            completion?()
            return
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let imageName = self.comicFile.comicPages[index]
            if let image = self.comicFile.loadImage(named: imageName) {
                self.setImage(image, for: index)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didCacheImage, object: index)
                }
            }
        }
        prefetchTasks[index] = workItem
        DispatchQueue.global(qos: priority).async(execute: workItem)
        workItem.notify(queue: .main) { completion?() }
    }
    
    func cleanupCache(keepingRange range: Int, imageViewCache: inout [Int: UIImageView]) {
        cacheAccessQueue.sync {
            let lowerBound = max(self.currentPage - range, 0)
            let upperBound = min(self.currentPage + range, comicFile.comicPages.count - 1)
            if lowerBound > upperBound { return }
            
            let keysToKeep = Set((lowerBound...upperBound).map { NSNumber(value: $0) })
            let keysToRemove = _cachekeys.subtracting(keysToKeep)
            
            keysToRemove.forEach { key in
                pageCache.removeObject(forKey: key)
                _cachekeys.remove(key)
                
                if let imageView = imageViewCache[key.intValue] {
                    imageView.image = nil
                }
                
//                print("🗑 Eliminando imagen \(key) de la caché")
            }
        }
    }
    
    func endCache() {
        self.pageCache.removeAllObjects()
    }
    
    private func isValidIndex(_ index: Int) -> Bool {
        return (0..<comicFile.comicPages.count).contains(index)
    }
}


