import SwiftUI
import Unrar

class CBRArchivo: Archivo, ProtocoloComic {
    var comicPages: [String] = []
    
    func loadComicPages(applyFilters: Bool) -> [String] {
        do {
            let archive = try Archive(path: self.url.path)
            let entries = try archive.entries()
            // Filtra solo las imágenes dentro del archivo CBZ
            let comicImages = entries.compactMap { entry in

                if entry.fileName.lowercased().hasSuffix(".jpg") || entry.fileName.lowercased().hasSuffix(".png") {
                    return entry.fileName
                }

                return nil
            }

            let comicPages = Utilidades().simpleSorting(contentFiles: comicImages)
//            return ManipulacionCadenas().filterImagesWithIndex(files: comicPages)
            return comicPages

        } catch {
//            print("Error al abrir el archivo CBZ: \(error)")
            return []
        }
    }
    
    func loadImage(named imageName: String) -> UIImage? {
        do {
            let archive = try Archive(path: self.url.path)  // Abre el archivo .cbr (RAR)
            let entries = try archive.entries()
            
            if let entry = entries.first(where: { $0.fileName == imageName }) {
                
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
    
    func loadImageBackGround(named imageName: String, completion: @escaping (UIImage?) -> Void) {
        
    }
    
    func getImageDimensions() -> [Int : (width: Int, height: Int)] {
        var dimensionsDict: [Int: (width: Int, height: Int)] = [:]
        return dimensionsDict
    }
    
    func invertirPaginas() {
        
    }
    
    func invertirPaginaActual() {
        
    }
    
    
    override init(fileName: String, fileURL: URL, fechaImportacion: Date, fechaModificacion: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
        
        //SE HACEN COSAS
        
        super.init(fileName: fileName, fileURL: fileURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, fileType: fileType, fileExtension: fileExtension, fileSize: fileSize, favorito: favorito, protegido: protegido)
        
//        self.pages = cargarPaginas()
//        self.imagenArchivo = self.crearImagenArchivo(tipoArchivo: self.fileType, miniaturaPortada: self.crearMiniaturaPortada(), miniaturaContraPortada: self.crearMiniaturaContraPortada())
    }
    
    override func obtenerPrimeraPagina() -> String? {
        do {
            let archive = try Archive(path: self.url.path)
            let entries = try archive.entries()
            
            // Filtrar solo imágenes y ordenarlas por nombre
            let imageEntries = entries
                .filter { entry in
                    let name = entry.fileName.lowercased()
                    return name.hasSuffix(".jpg") || name.hasSuffix(".jpeg") || name.hasSuffix(".png")
                }
                .sorted { $0.fileName.localizedStandardCompare($1.fileName) == .orderedAscending }
            
            // Devolver la primera si existe
            return imageEntries.first?.fileName
        } catch {
            print("Error abriendo archivo CBR: \(error)")
            return nil
        }
    }
    
    override func obtenerPaginaAleatoria() -> String? {
        do {
            let archive = try Archive(path: self.url.path)
            let entries = try archive.entries()
            
            // Filtrar solo imágenes y ordenarlas por nombre
            let imageEntries = entries
                .filter { entry in
                    let name = entry.fileName.lowercased()
                    return name.hasSuffix(".jpg") || name.hasSuffix(".jpeg") || name.hasSuffix(".png")
                }
                .sorted { $0.fileName.localizedStandardCompare($1.fileName) == .orderedAscending }
            
            // Si no hay al menos 2 imágenes, no hay "aleatoria distinta de la primera"
            guard imageEntries.count > 1 else { return nil }
            
            // La primera según tu lógica
            let primera = imageEntries.first!
            
            // Filtramos las demás
            let restantes = imageEntries.dropFirst()
            
            // Elegimos aleatoria de las restantes
            return restantes.randomElement()?.fileName
        } catch {
            print("Error abriendo archivo CBR: \(error)")
            return nil
        }
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

    
    override func cargarPaginasAsync() {
        Task {
            let total = contarPaginas()
            await MainActor.run {
                self.estadisticas.totalPaginas = total
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
