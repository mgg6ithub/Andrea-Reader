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
        do {
            let archive = try Archive(url: self.url, accessMode: .read)
            
            // Filtra solo las imágenes dentro del archivo CBZ
            let comicImages = archive.compactMap { entry in
                if entry.path.lowercased().hasSuffix(".jpg") || entry.path.lowercased().hasSuffix(".png") {
                    return entry.path
                }
                return nil
            }
            
            let comicPages = Utilidades().simpleSorting(contentFiles: comicImages)
            return ManipulacionCadenas().filterImagesWithIndex(files: comicPages)
            
        } catch {
            print("Error al abrir el archivo CBZ: \(error)")
            return []
        }
    }

    
    func crearMiniatura() -> UIImage? {
        guard let primeraImagen = self.pages.first else { return nil }
        return cargarImagen(nombreImagen: primeraImagen)
    }
    
    func cargarImagen(nombreImagen: String) -> UIImage? {
        let startTime = CFAbsoluteTimeGetCurrent()  // ⏳ Tiempo inicial
        
        do {
            let archive = try Archive(url: self.url, accessMode: .read)

            guard let entry = archive[nombreImagen] else {
                print("Entrada no encontrada en el archivo: \(nombreImagen)")
                return nil
            }

            var data = Data()
            _ = try archive.extract(entry) { data.append($0) }

            guard let uiImage = UIImage(data: data) else {
                print("No se pudo convertir a UIImage: \(nombreImagen)")
                return nil
            }

            let imageJPEG = self.convertToJPEG(image: uiImage, quality: 1.0)

            let endTime = CFAbsoluteTimeGetCurrent()
            print("| \(data.count) B ~\(data.count / 1024) KB | \(nombreImagen) -> \(endTime - startTime) s |")

            return imageJPEG

        } catch {
            print("Error al cargar o extraer imagen \(nombreImagen): \(error)")
            return nil
        }
    }

    
    func convertToJPEG(image: UIImage, quality: CGFloat = 0.8) -> UIImage? {
        guard let jpegData = image.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: jpegData)
    }
    
}
