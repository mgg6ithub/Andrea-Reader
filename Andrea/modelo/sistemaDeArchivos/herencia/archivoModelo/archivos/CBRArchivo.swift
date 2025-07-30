
import SwiftUI
import Unrar

class CBRArchivo: Archivo {
    
    override init(fileName: String, fileURL: URL, creationDate: Date, modificationDate: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
        
        //SE HACEN COSAS
        
        super.init(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileExtension, fileSize: fileSize, favorito: favorito, protegido: protegido)
        
//        self.pages = cargarPaginas()
//        self.imagenArchivo = self.crearImagenArchivo(tipoArchivo: self.fileType, miniaturaPortada: self.crearMiniaturaPortada(), miniaturaContraPortada: self.crearMiniaturaContraPortada())
    }
    
//    func cargarPaginas() -> [String] {
//        do {
//            let archive = try Archive(path: self.url.path)
//            let entries = try archive.entries()
//            // Filtra solo las imágenes dentro del archivo CBZ
//            let comicImages = entries.compactMap { entry in
//                
//                if entry.fileName.lowercased().hasSuffix(".jpg") || entry.fileName.lowercased().hasSuffix(".png") {
//                    return entry.fileName
//                }
//                
//                return nil
//            }
//            
//            let comicPages = Utilidades().simpleSorting(contentFiles: comicImages)
//            return ManipulacionCadenas().filterImagesWithIndex(files: comicPages)
//            
//        } catch {
////            print("Error al abrir el archivo CBZ: \(error)")
//            return []
//        }
//    }
//    
    
    override func obtenerPrimeraPagina() -> String? {
        do {
            let archive = try Archive(path: self.url.path)
            let entries = try archive.entries()
            
            for entry in entries {
                let lowercasedName = entry.fileName.lowercased()
                if lowercasedName.hasSuffix(".jpg") || lowercasedName.hasSuffix(".jpeg") || lowercasedName.hasSuffix(".png") {
                    return entry.fileName
                }
            }
            return nil
        } catch {
            print("Error abriendo archivo CBR: \(error)")
            return nil
        }
    }

    
    override func cargarPaginasAsync() {
        Task {
            let total = contarPaginas()
            await MainActor.run {
                self.totalPaginas = total
            }
        }
    }
    
    // Ejemplo: contar páginas de CBZ (haz lo mismo para CBR)
    func contarPaginas() -> Int {
        do {
            let archive = try Archive(path: self.url.path)
            let entries = try archive.entries()

            let total = entries.filter {
                $0.fileName.lowercased().hasSuffix(".jpg") ||
                $0.fileName.lowercased().hasSuffix(".png")
            }.count

            return total
        } catch {
            return 0
        }
    }
    
    override func cargarImagen(nombreImagen: String) -> UIImage? {
        
        do {
            let archive = try Archive(path: self.url.path)  // Abre el archivo .cbr (RAR)
            let entries = try archive.entries()
            
            if let entry = entries.first(where: { $0.fileName == nombreImagen }) {
                
                let extractedData = try archive.extract(entry)
                
                let uiImage = UIImage(data: extractedData)  // Convierte los datos a UIImage
                let imageJPEG = self.convertToJPEG(image: uiImage!, quality: 1.0)
                return imageJPEG
            }

            
        } catch {
            print("Error a la hora de cargar el archivo CBR ", self.nombre)
            return nil
        }
        return nil
    }
    
    override func cargarDatosImagen(nombreImagen: String) -> Data? {
        do {
            // Abrimos el .cbr/.rar
            let archive = try Archive(path: self.url.path)
            let entries = try archive.entries()
            
            // Buscamos la entrada que coincida con el nombre
            if let entry = entries.first(where: { $0.fileName == nombreImagen }) {
                // Extraemos los bytes
                let extractedData = try archive.extract(entry)
                return extractedData
            }
        } catch {
            print("Error al cargar datos de imagen \(nombreImagen) en \(self.nombre):", error)
            return nil
        }
        return nil
    }

    
    func convertToJPEG(image: UIImage, quality: CGFloat = 0.8) -> UIImage? {
        guard let jpegData = image.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: jpegData)
    }
    
}
