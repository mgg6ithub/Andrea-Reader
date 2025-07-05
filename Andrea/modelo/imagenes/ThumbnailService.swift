import UIKit
import ZIPFoundation

class ThumbnailService {
    static let shared = ThumbnailService()
    private init() {}

    private let fileManager = FileManager.default

    // 🧠 Caché con límite de memoria: 50MB
    let cache: NSCache<NSString, UIImage> = {
        let c = NSCache<NSString, UIImage>()
        c.totalCostLimit = 50 * 1024 * 1024 // 50 MB
        return c
    }()

    // 📁 Directorio de caché en disco
    lazy var cacheDir: URL = {
        let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("thumbnails", isDirectory: true)
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()

    private let thumbnailQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        queue.qualityOfService = .utility
        return queue
    }()

    /// 📏 Calcula el coste real de una imagen en memoria
    private func memoryCost(for image: UIImage) -> Int {
        let scale = image.scale
        let size = image.size
        return Int(size.width * scale * size.height * scale * 4)
    }

    /// 🖼️ Redimensiona una imagen a tamaño de thumbnail
    private func resizedThumbnail(from image: UIImage, targetSize: CGSize = CGSize(width: 1000, height: 1000)) -> UIImage {
        let aspectWidth = targetSize.width / image.size.width
        let aspectHeight = targetSize.height / image.size.height
        let scaleFactor = min(aspectWidth, aspectHeight)
        
        let scaledSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1.0  // para controlar uso de memoria
        let renderer = UIGraphicsImageRenderer(size: scaledSize, format: format)
        
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }


    func thumbnail(for archivo: Archivo, allowGeneration: Bool = true, completion: @escaping (UIImage?) -> Void) {
        
        let key = archivo.url.path as NSString
        let thumbURL = cacheDir.appendingPathComponent("\(archivo.url.lastPathComponent).jpg")

        // 1. Buscar en memoria
        if let img = cache.object(forKey: key) {
            completion(img)
            return
        }

        // 2. Buscar en disco
        if let data = try? Data(contentsOf: thumbURL),
           let image = UIImage(data: data) {
            let cost = memoryCost(for: image)
            cache.setObject(image, forKey: key, cost: cost)
            completion(image)
            return
        }

        // 3. Solo generar si se permite
        guard allowGeneration else {
            completion(nil)
            return
        }

        // 4. Generar miniatura
        thumbnailQueue.addOperation {
            guard let firstPage = archivo.pages.first,
                  let data = archivo.extractPageData(named: firstPage),
                  let original = UIImage(data: data) else {
                
                print("Falla para el archivo: ", archivo.name)
                
                // ❗ Si falla, usar miniatura por tipo de archivo
                let fallback = EnumMiniaturasArchivos.uiImage(for: archivo.fileType.rawValue)
                print(fallback)
                DispatchQueue.main.async {
                    completion(fallback)
                }
                return
            }

            let thumbnail = self.resizedThumbnail(from: original)
            guard let jpegData = thumbnail.jpegData(compressionQuality: 1.0) else {
                // ❗ También puede fallar aquí
                let fallback = EnumMiniaturasArchivos.uiImage(for: archivo.fileType.rawValue)
                DispatchQueue.main.async {
                    completion(fallback)
                }
                return
            }

            try? jpegData.write(to: thumbURL)

            let image = UIImage(data: jpegData)
            if let image = image {
                let cost = self.memoryCost(for: image)
                self.cache.setObject(image, forKey: key, cost: cost)
            }

            DispatchQueue.main.async {
                completion(image ?? EnumMiniaturasArchivos.uiImage(for: archivo.fileType.rawValue))
            }
        }

    }

    /// ⚙️ Precarga (puedes llamarla al crear el archivo)
    func generateThumbnail(for archivo: (any ProtocoloArchivo)) {
        let key = archivo.url.path as NSString
        let thumbURL = cacheDir.appendingPathComponent("\(archivo.url.lastPathComponent).jpg")

        guard !fileManager.fileExists(atPath: thumbURL.path) else {
            return
        }

        thumbnailQueue.addOperation {
            guard let firstPage = archivo.pages.first,
                  let data = archivo.extractPageData(named: firstPage),
                  let original = UIImage(data: data) else {
                return
            }

            let thumbnail = self.resizedThumbnail(from: original)
            guard let jpeg = thumbnail.jpegData(compressionQuality: 1.0) else {
                return
            }

            try? jpeg.write(to: thumbURL)

            if let image = UIImage(data: jpeg) {
                let cost = self.memoryCost(for: image)
                self.cache.setObject(image, forKey: key, cost: cost)
            }
        }
    }
    
    func removeCache(for archivo: Archivo) {
        let key = archivo.url.path as NSString
        cache.removeObject(forKey: key)
//        print("🗑️ ThumbnailService: cache removed for \(archivo.name)")
    }
    
    func clearCache() {
        cache.removeAllObjects()
//        print("🗑️ Cache cleared")
    }


}



