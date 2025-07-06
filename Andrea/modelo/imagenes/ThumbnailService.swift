import UIKit
import ZIPFoundation

class ThumbnailService {
    static let shared = ThumbnailService()
    private init() {}

    private let fileManager = FileManager.default

    // 🧠 Caché con límite de memoria: 50MB
    let cache: NSCache<NSString, UIImage> = {
        let c = NSCache<NSString, UIImage>()
        return c
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


//    func thumbnail(coleccion: Coleccion, for archivo: Archivo, allowGeneration: Bool = true, completion: @escaping (UIImage?) -> Void) {
//        
//        // Usamos solo lastPathComponent para clave simple y clara
//        let keyString = archivo.url.lastPathComponent as NSString
//        print("🔑 Clave usada para caché:", keyString)
//        
//        if let img = cache.object(forKey: keyString) {
//            print("✅ Imagen obtenida de caché para archivo:", archivo.name)
//            completion(img)
//            return
//        } else {
//            print("❌ No había imagen en caché para archivo:", archivo.name)
//        }
//        
//        thumbnailQueue.addOperation {
//            print("⏳ Generando miniatura para archivo:", archivo.name)
//            if let firstPage = archivo.pages.first {
//                print("📄 Primera página:", firstPage)
//                
//                guard let uiImage = archivo.cargarImagen(nombreImagen: firstPage) else {
//                    print("⚠️ No se pudo cargar la imagen para archivo:", archivo.name)
//                    
//                    if let dImage = ImagenArchivoModelo().crearMiniaturaPorDefecto(
//                        defaultFileThumbnail: EnumMiniaturasArchivos.uiImage(for: archivo.fileType),
//                        color: UIColor(coleccion.directoryColor))?.uiImage {
//                        DispatchQueue.main.async {
//                            completion(dImage)
//                        }
//                    }
//                    return
//                }
//                
//                print("🧠 Guardando imagen en caché para archivo:", archivo.name)
//                self.cache.setObject(uiImage, forKey: keyString)
//                
//                // Inmediatamente intentamos obtener para verificar
//                if self.cache.object(forKey: keyString) != nil {
//                    print("✅ Imagen confirmada en caché para archivo:", archivo.name)
//                } else {
//                    print("❌ No se pudo confirmar imagen en caché para archivo:", archivo.name)
//                }
//                
//                DispatchQueue.main.async {
//                    completion(uiImage)
//                }
//                return
//            } else {
//                print("⚠️ No hay páginas para archivo:", archivo.name)
//            }
//        }
//    }

    
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



