import SwiftUI
import ZIPFoundation

class CBZArchivo: Archivo, ProtocoloComic {
    
    var comicPages: [String] = []
    
    func loadComicPages(applyFilters: Bool) -> [String] {
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
//            return ManipulacionCadenas().filterImagesWithIndex(files: comicPages) cuaidado al aplicar el filtro porque al contar las paginas de forma rapuda no se esta aplicando
            return comicPages

        } catch {
//            print("Error al abrir el archivo CBZ: \(error)")
            return []
        }
    }
    
    func loadImage(named imageName: String) -> UIImage? {
        do {
            let archive = try Archive(url: self.url, accessMode: .read)

            guard let entry = archive[imageName] else {
                print("Entrada no encontrada en el archivo: \(imageName)")
                return nil
            }

            var data = Data()
            _ = try archive.extract(entry) { data.append($0) }

            guard let uiImage = UIImage(data: data) else {
                print("No se pudo convertir a UIImage: \(imageName)")
                return nil
            }

            let imageJPEG = self.convertToJPEG(image: uiImage, quality: 1.0)

//            let endTime = CFAbsoluteTimeGetCurrent()
//            print("| \(data.count) B ~\(data.count / 1024) KB | \(imageName) -> \(endTime - startTime) s |")

            return imageJPEG

        } catch {
            print("Error al cargar o extraer imagen \(imageName): \(error)")
            return nil
        }
    }
    
    func loadImageBackGround(named imageName: String, completion: @escaping (UIImage?) -> Void) {
        
    }
    
    func getImageDimensions() -> [Int: (width: Int, height: Int)] {
        var dimensionsDict: [Int: (width: Int, height: Int)] = [:] // Índice -> (ancho, alto)

        guard let archive = Archive(url: self.url, accessMode: .read) else {
            print("Error al abrir el archivo CBZ")
            return [:]
        }

        // Filtrar solo imágenes .jpg y .png
        let comicImages = archive.compactMap { entry in
            if entry.path.lowercased().hasSuffix(".jpg") || entry.path.lowercased().hasSuffix(".png") {
                return entry
            }
            return nil
        }
        .prefix(5)
        
        // Iterar sobre las imágenes y obtener las dimensiones
        comicImages.enumerated().forEach { (index, entry) in
            if let dimensions = getDimensions(from: archive, entry: entry) {
                dimensionsDict[index] = dimensions
            }
        }

        return dimensionsDict
    }

    func getDimensions(from archive: Archive, entry: Entry) -> (width: Int, height: Int)? {
        do {
            var extractedData = Data()
            _ = try archive.extract(entry, consumer: { data in
                extractedData.append(data)
                return // Extraer solo primeros 4096 bytes
            })

            guard let imageSource = CGImageSourceCreateWithData(extractedData as CFData, nil),
                  let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
                  let width = properties[kCGImagePropertyPixelWidth] as? Int,
                  let height = properties[kCGImagePropertyPixelHeight] as? Int else {
                return nil
            }
            print("Dim. \(width) x \(height)")
            return (width, height)

        } catch {
            print("Error obteniendo dimensiones de \(entry.path): \(error)")
            return nil
        }
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
            let archive = try Archive(url: self.url, accessMode: .read)

            // Se detiene en la primera imagen
            if let entry = archive.first(where: { entry in
                let lowercased = entry.path.lowercased()
                return lowercased.hasSuffix(".jpg") || lowercased.hasSuffix(".jpeg") || lowercased.hasSuffix(".png")
            }) {
                return entry.path
            }

            return nil
        } catch {
            print("Error leyendo archivo CBZ: \(error)")
            return nil
        }
    }
    
    override func obtenerPaginaAleatoria() -> String? {
        do {
            let archive = try Archive(url: self.url, accessMode: .read)

            // Lista todas las imágenes en el CBZ
            let imagenes = archive.compactMap { entry -> String? in
                let lowercased = entry.path.lowercased()
                if lowercased.hasSuffix(".jpg") || lowercased.hasSuffix(".jpeg") || lowercased.hasSuffix(".png") {
                    return entry.path
                }
                return nil
            }

            guard imagenes.count > 1 else {
                // si no hay más de 1 página, no se puede devolver aleatoria distinta de la primera
                return nil
            }

            // La primera página según tu lógica actual
            let primera = imagenes.first!

            // Filtra para excluir la primera
            let restantes = imagenes.filter { $0 != primera }

            // Elige aleatoria
            return restantes.randomElement()
        } catch {
            print("Error leyendo archivo CBZ: \(error)")
            return nil
        }
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
//            return ManipulacionCadenas().filterImagesWithIndex(files: comicPages)
            return comicPages

        } catch {
//            print("Error al abrir el archivo CBZ: \(error)")
            return []
        }
    }

    
   override func cargarPaginasAsync() {
        Task {
            let total = contarPaginas()
            await MainActor.run {
                self.estadisticas.totalPaginas = total
            }
        }
    }

    func contarPaginas() -> Int {
        do {
            let archive = try Archive(url: self.url, accessMode: .read)
            let imageCount = archive.filter { entry in
                entry.path.lowercased().hasSuffix(".jpg") || entry.path.lowercased().hasSuffix(".png")
            }.count
            ManipulacionCadenas().filterImagesWithIndex(files: comicPages)
            return imageCount
        } catch {
            return 0
        }
    }

    
//    override func extractPageData(named name: String) -> Data? {
//        do {
//            let archive = try Archive(url: url, accessMode: .read)
//            guard let entry = archive[name] else { return nil }
//            var data = Data()
//            _ = try archive.extract(entry) { data.append($0) }
//            return data
//        } catch {
//            print("Error extrayendo página:", error)
//            return nil
//        }
//    }

    
    override func cargarImagen(nombreImagen: String) -> UIImage? {
//        let startTime = CFAbsoluteTimeGetCurrent()  // ⏳ Tiempo inicial
        
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

//            let endTime = CFAbsoluteTimeGetCurrent()
//            print("| \(data.count) B ~\(data.count / 1024) KB | \(nombreImagen) -> \(endTime - startTime) s |")

            return imageJPEG

        } catch {
            print("Error al cargar o extraer imagen \(nombreImagen): \(error)")
            return nil
        }
    }
    
    override func cargarDatosImagen(nombreImagen: String) -> Data? {
        do {
            let archive = try Archive(url: self.url, accessMode: .read)
            guard let entry = archive[nombreImagen] else {
                print("❌ Entrada no encontrada en archivo: \(nombreImagen)")
                return nil
            }
            var data = Data()
            _ = try archive.extract(entry) { chunk in
                data.append(chunk)
            }
            return data
        } catch {
            print("Error extrayendo datos de \(nombreImagen):", error)
            return nil
        }
    }

    
    func convertToJPEG(image: UIImage, quality: CGFloat = 0.8) -> UIImage? {
        guard let jpegData = image.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: jpegData)
    }
    
}
