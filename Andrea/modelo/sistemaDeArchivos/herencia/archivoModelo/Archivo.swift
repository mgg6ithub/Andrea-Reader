
import SwiftUI

class Archivo: ElementoSistemaArchivos, ProtocoloArchivo, ObservableObject {
    
    //ARRAY CON LOS NOMBRES DE LAS PAGINAS 1,2,3,4...
    var pages: [String] = []
    
    //ATRIBUTOS DEL DIRECTORIO AL QUE PERTENECE
    var dirURL: URL = URL(fileURLWithPath: "")
    var dirName: String = ""
    var dirColor: UIColor = .gray
    
    
    //ATRIBUTOS
    var isDirectory = false
    var fileType: EnumTipoArchivos
    var fileExtension: String
    var mimeType: String
    var fileSize: Int
    var isReadable: Bool
    var isWritable: Bool
    var isExecutable: Bool
    var isProtected: Bool = false
    
    
    //ATRIBUTOS EXTRAIDOS DEL ARCHIVO
    var fileOriginalName: String?
    var scanFormat: String?
    var fileOirinalScannedSource: String?
    var fileOriginalDate: Date?
    var colectionCurrentIssue: Int?
    var colectionTotalIssues: Int?
    
    
    //PROGRESO
    var fileTotalPages: Int = 0
    @Published var fileProgressPercentage: Int = 0
    @Published var fileProgressPercentageEntero: Double = 0
    @Published var currentSavedPage: Int = 0
    var finisheReadingDate: Date?
    
    
    //MODELOS NECESARIOS
    var sau = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton
    
    //IMAGENES
    @Published var imagenArchivo: ImagenArchivo
    
    override init() {
        self.dirURL = URL(fileURLWithPath: "")
        self.dirName = ""
        self.dirColor = .gray
        
        self.isDirectory = false
        self.fileType = .unknown
        self.fileExtension = ""
        self.mimeType = "application/octet-stream"
        self.fileSize = 0
        self.isReadable = false
        self.isWritable = false
        self.isExecutable = false
        self.isProtected = false

        self.fileTotalPages = 0
        self.fileProgressPercentage = 0
        self.currentSavedPage = 0
        self.finisheReadingDate = nil
        
        self.imagenArchivo = ImagenArchivo(tipoArchivo: fileType, colorColeccion: .green)

        super.init()
    }
    
    init(fileName: String, fileURL: URL, creationDate: Date, modificationDate: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int) {
            
        self.fileType = fileType
        self.fileExtension = fileExtension
        self.mimeType = sau.getMimeType(for: fileURL)
        self.fileSize = fileSize
        
        let permissions = sau.getFilePermissions(for: fileURL)
        
        self.isReadable = permissions.readable
        self.isWritable = permissions.readable
        self.isExecutable = permissions.readable
        
        self.imagenArchivo = ImagenArchivo(tipoArchivo: fileType, colorColeccion: .green)
        
        super.init(name: fileName, url: fileURL, creationDate: creationDate, modificationDate: modificationDate)
        
    }
    
    func viewContent() -> AnyView {
        return AnyView(ZStack{})
    }
    
    func getTotalPages() -> Int {
        return self.fileTotalPages
    }
    
    func setCurrentPage(currentPage: Int) {
        self.currentSavedPage = currentPage
        //al setear la pagina calculamos automaticamente el porcentaje
        self.fileProgressPercentage = Int((Double(currentPage) / Double(getTotalPages())) * 100)
        self.fileProgressPercentageEntero = Double(currentPage) / Double(getTotalPages())

    }
    
    func crearImagenArchivo() -> ImagenArchivo {
        return ImagenArchivo(tipoArchivo: self.fileType, colorColeccion: .green)
    }
    
    func crearMiniaturaPortada() {}
    
//    func crearImagenArchivo(tipoArchivo: EnumTipoArchivos, miniaturaPortada: UIImage?, miniaturaContraPortada: UIImage?) -> ImagenArchivo {
//        
////        print("Creando una miniatura por defecto para: ", tipoArchivo)
//        var tempImagen = createDefaultThumbnail(defaultFileThumbnail: EnumMiniaturasArchivos.uiImage(for: tipoArchivo))?.uiImage
////        var tempImagen = ConstantesPorDefecto().dNotFoundUIImage
//        //        var tempBackImagen = tempImagen
//        
//        var tempImageAbsoluteURL = URL(fileURLWithPath: "")
//        //        var tempBackImagenAbsoluteURL = URL(fileURLWithPath: "")
//        
////        if let mPortada = miniaturaPortada {
////            tempImagen = mPortada.resized(to: ConstantesPorDefecto().dComicSize)
////            tempImageAbsoluteURL = self.url
////        }
//        
//        let sau = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton
//        let mc = ManipulacionCadenas()
//
//        return ImagenArchivo(
//            id: UUID(),
//            imageName: sau.getFileName(fileURL: tempImageAbsoluteURL),
//            uiImage: tempImagen!,
//            absoluteImageURL: tempImageAbsoluteURL,
//            relativeImageURL: mc.relativizeURLNOextension(elementURL: tempImageAbsoluteURL),
//            imageSize: sau.getFileSize(fileURL: tempImageAbsoluteURL),
//            imageDimensions: ImagenArchivoModelo().calculateUIImageDimensions(uiImage: tempImagen))
//    }
    
    
}
