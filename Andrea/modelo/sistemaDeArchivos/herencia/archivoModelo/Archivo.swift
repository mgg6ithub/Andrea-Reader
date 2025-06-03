
import SwiftUI

class Archivo: ElementoSistemaArchivos, ProtocoloArchivo {
    
    //ATRIBUTOS DEL DIRECTORIO AL QUE PERTENECE
    var dirURL: URL = URL(fileURLWithPath: "")
    var dirName: String = ""
    var dirColor: UIColor = .gray
    
    //ATRIBUTOS
    var isDirectory = false
    var fileType: String
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
//    var fs = FileSystem.getFileSystemInstance
    var sau = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton
    
    //IMAGENES
//    var fileImageModel: FileImageModel = FileImageModel()
    
    override init() {
        self.dirURL = URL(fileURLWithPath: "")
        self.dirName = ""
        self.dirColor = .gray
        
        self.isDirectory = false
        self.fileType = "unknown"
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

//        self.fileImageModel = FileImageModel()

        super.init()
    }
    
    init(fileName: String, fileURL: URL, creationDate: Date, modificationDate: Date, fileType: String, fileExtension: String, fileSize: Int) {
            
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
        return 0
    }
    
    func setCurrentPage(currentPage: Int) {
        
    }
    
}
