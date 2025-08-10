
import SwiftUI


class Archivo: ElementoSistemaArchivos, ProtocoloArchivo {
    
    @Published var tipoMiniatura: EnumTipoMiniatura = .primeraPagina
    
    //ATRIBUTOS DEL DIRECTORIO AL QUE PERTENECE
    var dirURL: URL = URL(fileURLWithPath: "")
    var dirName: String = ""
    var dirColor: UIColor = .gray
    
    //ATRIBUTOS
    var esColeccion = false
    var fileType: EnumTipoArchivos
    var fileExtension: String
    var mimeType: String
    var fileSize: Int
    var isReadable: Bool
    var isWritable: Bool
    var isExecutable: Bool
    
    //ATRIBUTOS EXTRAIDOS DEL ARCHIVO
    @Published var nombreOriginal: String?
    var perteneceAcoleccion: String?
    var numeroDeLaColeccion: Int?
    
    @Published var formatoEscaneo: String?
    @Published var entidadEscaneo: String?
    @Published var fechaPublicacion: String?
    
    var idioma: EnumIdiomas = .castellano
    var genero: String = ""
    
    //MARK: - --- VARIABLES CALCULADAS ---
    //PROGRESO
    @Published var totalPaginas: Int? {
        didSet {
            recalcularProgreso()
        }
    }
    @Published var progreso: Int = 0
    @Published var progresoEntero: Double = 0
    @Published var paginaActual: Int = 0

    //TIEMPOS
    var tiempoTotal: TimeInterval?
    var tiempoPorPagina: TimeInterval?
    var tiempoRestante: TimeInterval?           // Si quieres la fecha/hora estimada de finalización
    
    //Paginas
    var paginaVisitadaMasTiempo: TimeInterval?           // Si quieres la fecha/hora estimada de finalizació
    var paginasRestantes: Int?          // Número de páginas
    var paginaMasVisitada: Int?         // Número de página, no String
    
    //DIAS
    var avanceDiario: Double?
    var diasTotalesLectura: Int?
    var diasConsecutivosLecutra: Int?
    var horaFrecuente: Date?
    
    //velocidad
    var velocidadLectura: Double?
    var velocidadMax: Double?
    var velocidadMin: Double?
    
    var masInformacion: Bool = false
    
    //MODELOS NECESARIOS
    private let sau = SistemaArchivosUtilidades.sau
    
    override init() {
        self.dirURL = URL(fileURLWithPath: "")
        self.dirName = ""
        self.dirColor = .gray
        
        self.esColeccion = false
        self.fileType = .unknown
        self.fileExtension = ""
        self.mimeType = "application/octet-stream"
        self.fileSize = 0
        self.isReadable = false
        self.isWritable = false
        self.isExecutable = false

        self.progreso = 0
        self.paginaActual = 0

        super.init()
    }
    
    
    init(fileName: String, fileURL: URL, fechaImportacion: Date, fechaModificacion: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
            
        self.fileType = fileType
        self.fileExtension = fileExtension
        self.mimeType = sau.getMimeType(for: fileURL)
        self.fileSize = fileSize
        
        let permissions = sau.getFilePermissions(for: fileURL)

        self.isReadable = permissions.readable
        self.isWritable = permissions.writable
        self.isExecutable = permissions.executable
        
        super.init(nombre: fileName, url: fileURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, favortio: favorito, protegido: protegido)
        
        self.cargarPaginasAsync()
        
        //--- PROGRESO DEL ARCHIVO ---
        if let paginaConcreta = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "progreso") {
            self.setCurrentPage(currentPage: paginaConcreta as! Int)
        } else {
            self.setCurrentPage(currentPage: 10)
        }
        
        //--- TIPO DE IMAGEN ---
        if let tipoRaw = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "tipoMiniatura") as? String,
           let tipo = EnumTipoMiniatura(rawValue: tipoRaw) {
            self.tipoMiniatura = tipo
        }
        
    }
    
    
    private func cargarOAveriguar<T>(
        atributo: String,
        tipo: T.Type,
        desde url: URL,
        extractor: () -> T?
    ) -> T? {
        if let valor = PersistenciaDatos().obtenerAtributoConcreto(url: url, atributo: atributo) as? T {
            return valor
        }
        return extractor()
    }

    
    func inicializarValoresEstadisticos() {
        
        print("Inicializando datos para la prueba")
        print()
        
        //CADENAS
        print("Inicializando datos para la prueba\n")
        self.nombreOriginal = cargarOAveriguar(atributo: "nombreOriginal", tipo: String.self, desde: self.url) { nil }
        self.fechaPublicacion = cargarOAveriguar(atributo: "fechaPublicacion", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { Fechas().extraerAno(from: $0) } }
        self.formatoEscaneo = cargarOAveriguar(atributo: "formatoEscaneo", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerFormatoEscaneo(from: $0) } }
        self.entidadEscaneo = cargarOAveriguar(atributo: "entidadEscaneo", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerEntidad(from: $0) } }
        self.numeroDeLaColeccion = cargarOAveriguar(atributo: "numeroDeLaColeccion", tipo: Int.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerNumeroDeLaColeccion(from: $0) } }
        
        // TIEMPOS
        tiempoTotal = 0
        tiempoPorPagina = 0
        tiempoRestante = 0
        
        // PÁGINAS
        paginaVisitadaMasTiempo = 0
        paginasRestantes = 0
        paginaMasVisitada = 0
        
        // DÍAS
        avanceDiario = 0
        diasTotalesLectura = 0
        diasConsecutivosLecutra = 0
        horaFrecuente = nil // Mejor nil si no hay hora registrada aún
        
        // VELOCIDAD
        velocidadLectura = 0
        velocidadMax = 0
        velocidadMin = 0
        
        masInformacion = true
        
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
    
    public func completarLectura() {
        if self.progreso != 100 {
            withAnimation { self.progreso = 100 }
        } else {
            withAnimation { self.progreso = 0 }
        }
        PersistenciaDatos().guardarDatoElemento(url: self.url, atributo: "progreso", valor: self.progreso)
    }
    
}
