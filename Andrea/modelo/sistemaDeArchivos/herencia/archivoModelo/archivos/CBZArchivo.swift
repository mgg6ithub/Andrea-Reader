import SwiftUI
import ZIPFoundation

class CBZArchivo: Archivo {
    
    var pages: [String] = []
    var imagenMiniatura: UIImage? = nil
    
    override init(fileName: String, fileURL: URL, creationDate: Date, modificationDate: Date, fileType: String, fileExtension: String, fileSize: Int) {
        
        //SE HACEN COSAS
        
        super.init(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileExtension, fileSize: fileSize)
        
        self.pages = cargarPaginas()
        self.imagenMiniatura = crearMiniatura()
        
    }
    
    func cargarPaginas() -> [String] {
        guard let archive = Archive(url: self.url, accessMode: .read) else {
            print("Error al abrir el archivo CBZ")
            return []
        }
        
        var comicPages: [String] = []

        // Filtra solo las imágenes dentro del archivo CBZ
        let comicImages = archive.compactMap { entry in

            if entry.path.lowercased().hasSuffix(".jpg") || entry.path.lowercased().hasSuffix(".png") {
                return entry.path
            }
            return nil
        }
        
        comicPages = Utilidades().simpleSorting(contentFiles: comicImages)
        return ManipulacionCadenas().filterImagesWithIndex(files: comicPages) //FILTRAR CONTENIDO DEL ARCHIVO COMPRIMIDO
    }
    
    func crearMiniatura() -> UIImage? {
        guard let primeraImagen = self.pages.first else { return nil }
        return cargarImagen(nombreImagen: primeraImagen)
    }
    
    func cargarImagen(nombreImagen: String) -> UIImage? {
        let startTime = CFAbsoluteTimeGetCurrent()  // ⏳ Tiempo inicial
                
        guard let archive = Archive(url: self.url, accessMode: .read),
              let entry = archive[nombreImagen] else {
            print("Error al cargar la imagen \(nombreImagen)")
            return nil
        }
        do {
            var data = Data()
            try archive.extract(entry, consumer: { data.append($0) })
            
//            let originalData = data.count
            
            let uiImage = UIImage(data: data)
            let imageJPEG = self.convertToJPEG(image: uiImage!, quality: 1.0)
//            guard let image = uiImage else {
//                print("No se pudo cargar la imagen.")
//                return nil
//            }
            
//            let decompressedSize = image.size.width * image.size.height * 3
//            let compressionRatio = Double(originalData) / Double(decompressedSize)
            
//            let endTime = CFAbsoluteTimeGetCurrent()
//            print()
//            print("| \(data.count) ~\(data.count / 1024) KB | IMAGEN \(nombreImagen) \((nombreImagen as NSString).pathExtension.lowercased())-> \(endTime - startTime) s| Image Size: \(uiImage!.size.width) x \(uiImage!.size.height) |")
//            print("decompresion: \(decompressedSize)")
//            print("compresion: \(compressionRatio)")
//            print()
            
            return imageJPEG
        } catch {
            print("Error al extraer la imagen \(nombreImagen): \(error)")
            return nil
        }
    }
    
    func convertToJPEG(image: UIImage, quality: CGFloat = 0.8) -> UIImage? {
        guard let jpegData = image.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: jpegData)
    }
    
}
