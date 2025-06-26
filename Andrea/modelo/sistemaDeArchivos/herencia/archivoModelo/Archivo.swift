
import SwiftUI

class Archivo: ElementoSistemaArchivos, ProtocoloArchivo {
    
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
    var imagenArchivo: ImagenArchivo = ImagenArchivo()
    
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
    
    func crearImagenArchivo(tipoArchivo: EnumTipoArchivos, miniaturaPortada: UIImage?, miniaturaContraPortada: UIImage?) -> ImagenArchivo {
        
        //0. Si el archivo con su URL ya tiene de persistencia unas imagenes que el usuaruo cambio se utilizaran esas y se sale del metodo
        
        //Si no tiene imagenes de persistencia.S
        //1. Si cualquiera de las miniaturas es nil colocamos una por defecto
        
        print("Creando una miniatura por defecto para: ", tipoArchivo)
        var tempImagen = createDefaultThumbnail(defaultFileThumbnail: EnumMiniaturasArchivos.uiImage(for: tipoArchivo))?.uiImage
        //        var tempBackImagen = tempImagen
        
        var tempImageAbsoluteURL = URL(fileURLWithPath: "")
        //        var tempBackImagenAbsoluteURL = URL(fileURLWithPath: "")
        
        if let mPortada = miniaturaPortada {
            tempImagen = mPortada.resized(to: ConstantesPorDefecto().dComicSize)
            tempImageAbsoluteURL = self.url
        }
        
        //        if let mContraPortada = miniaturaContraPortada {
        //            tempBackImagen = mContraPortada.resized(to: ConstantesPorDefecto().dComicSize)
        //            tempBackImagenAbsoluteURL = self.url
        //        }
        
        //2. Creamos la instancia de ImagenArchivo con las imagenes y sus URLs
        
        let sau = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton
        let mc = ManipulacionCadenas()
        
        //        return ImagenArchivo(
        //            id: UUID(),
        //
        //            imageName: sau.getFileName(fileURL: tempImageAbsoluteURL),
        //            backImageName: sau.getFileName(fileURL: tempBackImagenAbsoluteURL),
        //
        //            uiImage: tempImagen!,
        //            backuiImage: tempBackImagen!,
        //
        //            absoluteImageURL: tempImageAbsoluteURL,
        //            relativeImageURL: mc.relativizeURLNOextension(elementURL: tempImageAbsoluteURL),
        //
        //            absoluteBackImageURL: tempBackImagenAbsoluteURL,
        //            relativeBackImageURL: mc.relativizeURLNOextension(elementURL: tempBackImagenAbsoluteURL),
        //
        //            imageSize: sau.getFileSize(fileURL: tempImageAbsoluteURL),
        //            backImageSize: sau.getFileSize(fileURL: tempBackImagenAbsoluteURL),
        //
        //            imageDimensions: ImagenArchivoModelo().calculateUIImageDimensions(uiImage: tempImagen),
        //            backImageDimensions: ImagenArchivoModelo().calculateUIImageDimensions(uiImage: tempBackImagen)
        //        )
        return ImagenArchivo(
            id: UUID(),
            imageName: sau.getFileName(fileURL: tempImageAbsoluteURL),
            uiImage: tempImagen!,
            absoluteImageURL: tempImageAbsoluteURL,
            relativeImageURL: mc.relativizeURLNOextension(elementURL: tempImageAbsoluteURL),
            imageSize: sau.getFileSize(fileURL: tempImageAbsoluteURL),
            imageDimensions: ImagenArchivoModelo().calculateUIImageDimensions(uiImage: tempImagen))
    }
    
    func createDefaultThumbnail(defaultFileThumbnail: UIImage, color: UIColor? = nil) -> (uiImage: UIImage, imageData: Data?, imageDimensions: (width: Int, height: Int))? {
            let thumbnailSize: CGSize = ConstantesPorDefecto().dComicSize
            
    //        if let archivoPDFImage = UIImage(named: defaultFileThumbnail) {
                
    //                let azulSuave = UIColor(red: 0.5, green: 0.7, blue: 1.0, alpha: 1.0)
                    let verdeSuave = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0) // Verde suave
    //            let rojoSuave = UIColor(red: 0.9, green: 0.5, blue: 0.5, alpha: 1.0) // Rojo suave


                let negroGrisAzul = UIColor(red: 51/255.0, green: 62/255.0, blue: 72/255.0, alpha: 1.0)
                let blanco = UIColor(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1.0)
            
            var ternariColor: UIColor = color ?? self.dirColor
                
            let symbolColorConfig = UIImage.SymbolConfiguration(paletteColors: [negroGrisAzul, blanco, ternariColor])  // Ajusta los colores según sea necesario
                let coloredImage = defaultFileThumbnail.applyingSymbolConfiguration(symbolColorConfig)
                
                let size = CGSize(width: 247, height: 304)
                
                // Ajusta la posición de la imagen moviéndola hacia arriba (cambia el valor del origen 'y')
                let offsetY: CGFloat = -20  // Ajusta este valor para mover la imagen hacia arriba o abajo
                let offsetX: CGFloat = -28  // Ajusta este valor para mover la imagen hacia arriba o abajo
                
                // Redibujar la imagen manteniendo sus proporciones pero desplazada hacia arriba
                UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, 0.0)
                coloredImage?.draw(in: CGRect(origin: CGPoint(x: offsetX, y: offsetY), size: size))  // Aplica el desplazamiento en Y
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                // Obtener los datos de la imagen redimensionada
                let imageData = resizedImage?.jpegData(compressionQuality: 1.0)
                let imageDimensions = (width: Int(resizedImage?.size.width ?? 0), height: Int(resizedImage?.size.height ?? 0))
                
                return (resizedImage ?? defaultFileThumbnail, imageData, imageDimensions)
    //        } else {
    //            print("No se pudo cargar la imagen de archivo-pdf desde los assets")
    //        }
    //        return nil
        }
    
}
