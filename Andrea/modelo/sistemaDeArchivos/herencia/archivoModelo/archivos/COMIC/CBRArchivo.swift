import SwiftUI
import Unrar

class CBRArchivo: Archivo, ProtocoloComic {
    
    var comicPages: [String] = []
    
    override init(fileName: String, fileURL: URL, fechaImportacion: Date, nombreOriginal: String, fechaModificacion: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
        
        //SE HACEN COSAS
        
        super.init(fileName: fileName, fileURL: fileURL, fechaImportacion: fechaImportacion, nombreOriginal: nombreOriginal, fechaModificacion: fechaModificacion, fileType: fileType, fileExtension: fileExtension, fileSize: fileSize, favorito: favorito, protegido: protegido)
        
    }
    
    //IMPORTANTE
    override func cargarPaginasTotalesAsync() {
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
    //IMPORTANTE
    
    override func extraerImagen(nombreImagen: String) -> Data? {
        do {
            let archive = try Archive(path: self.url.path)  // Abre el archivo .cbr (RAR)
            let entries = try archive.entries()
            
            if let entry = entries.first(where: { $0.fileName == nombreImagen }) {
                // Extraemos los bytes
                let data = try archive.extract(entry)
                return data
            }
        } catch {
            print("Error al abrir el archivo CBZ: \(nombreImagen) \(error)")
            return nil
        }
        return nil
    }
    
    func cargarImagen(nombreImagen: String) -> UIImage? {
        if let data = extraerImagen(nombreImagen: nombreImagen) {
            let uiImage = UIImage(data: data)  // Convierte los datos a UIImage
            //DONWSAMPLE
            let imageJPEG = ImagenMod().convertToJPEG(image: uiImage!, quality: 1.0)
            //DONWSAMPLE
            return imageJPEG
        }
        return nil
    }
    
    func cargarPaginas(applyFilters: Bool) -> [String] {
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
    
    func loadImageBackGround(named imageName: String, completion: @escaping (UIImage?) -> Void) {
        
    }
    
    func getImageDimensions() -> [Int : (width: Int, height: Int)] {
        let dimensionsDict: [Int: (width: Int, height: Int)] = [:]
        return dimensionsDict
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
            _ = imageEntries.first!
            
            // Filtramos las demás
            let restantes = imageEntries.dropFirst()
            
            // Elegimos aleatoria de las restantes
            return restantes.randomElement()?.fileName
        } catch {
            print("Error abriendo archivo CBR: \(error)")
            return nil
        }
    }
}
