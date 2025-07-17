
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
    private let sau = SistemaArchivosUtilidades.sau
    
//    var hasThumbnail: Bool {
//        let thumbURL = ThumbnailService.shared.cacheDir
//            .appendingPathComponent("\(url.lastPathComponent).jpg")
//        return FileManager.default.fileExists(atPath: thumbURL.path)
//    }
    
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
        self.isWritable = permissions.writable
        self.isExecutable = permissions.executable
        
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
    
    func extractPageData(named name: String) -> Data? {
        return nil
    }
    
    func cargarImagen(nombreImagen: String) -> UIImage? {
        return nil
    }
    
    func cargarDatosImagen(nombreImagen: String) -> Data? {
        return nil
    }
    
}
