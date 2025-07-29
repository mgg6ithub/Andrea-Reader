
import SwiftUI

class Archivo: ElementoSistemaArchivos, ProtocoloArchivo, ObservableObject {
    
    @Published var tipoMiniatura: EnumTipoMiniatura = .primeraPagina
    
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
    @Published var totalPaginas: Int? {
        didSet {
            recalcularProgreso()
        }
    }
    @Published var progreso: Int = 0
    @Published var progresoEntero: Double = 0
    @Published var paginaActual: Int = 0
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

        self.progreso = 0
        self.paginaActual = 0
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
        
        super.init(nombre: fileName, url: fileURL, creationDate: creationDate, modificationDate: modificationDate)
        
        self.cargarPaginasAsync()
        
        if let paginaConcreta = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "paginaGuardada") {
//            print("Se cagra la pagina guardada desde persistencia")
            self.setCurrentPage(currentPage: paginaConcreta as! Int)
        } else {
            self.setCurrentPage(currentPage: 10)
//            PersistenciaDatos().guardarDatoElemento(url: archivo.url, atributo: "paginaGuardada", valor: 10)
        }
        
        if let tipoRaw = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "tipoMiniatura") as? String,
           let tipo = EnumTipoMiniatura(rawValue: tipoRaw) {
//            print("Se carga el tipo de miniatura desde persistencia: ", tipo)
            self.tipoMiniatura = tipo
        }
        
    }
    
    func viewContent() -> AnyView {
        return AnyView(ZStack{})
    }
    
    func getTotalPages() -> Int {
        return self.totalPaginas ?? 20
    }
    
    func setCurrentPage(currentPage: Int) {
        self.paginaActual = currentPage
        //al setear la pagina calculamos automaticamente el porcentaje
        self.progreso = Int((Double(currentPage) / Double(getTotalPages())) * 100)
        self.progresoEntero = Double(currentPage) / Double(getTotalPages())

    }
    
    func extractPageData(named nombre: String) -> Data? {
        return nil
    }
    
    func cargarImagen(nombreImagen: String) -> UIImage? {
        return nil
    }
    
    func cargarDatosImagen(nombreImagen: String) -> Data? {
        return nil
    }
    
    func cargarPaginasAsync() {
            // Implementación vacía por defecto o genérica
    }
    
    func obtenerPrimeraPagina() -> String? {
        return "corrupted"
    }
    
    private func recalcularProgreso() {
        guard let total = totalPaginas, total > 0 else {
            progreso = 0
            return
        }

        let porcentaje = Int((Double(paginaActual) / Double(total)) * 100)
        progreso = min(max(porcentaje, 0), 100)
    }
    
}
