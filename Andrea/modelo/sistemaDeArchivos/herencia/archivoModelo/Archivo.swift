
import SwiftUI
import Combine

extension Archivo {
    static var preview: Archivo {
        let a = Archivo()
        
        // Datos de archivo
        a.nombre = "Archivo Demo"
//        a.totalPaginas = 120
//        a.paginaActual = 45
        a.fileSize = 1024 * 1024 * 5 // 5 MB
        a.fileExtension = "cbr"
        a.url = URL(fileURLWithPath: "/preview/path/archivo.cbr")
        a.relativeURL = "archivo.cbr"
        
        // Metadatos
        a.fechaPublicacion = "2024-01-01"
        a.numeroDeLaColeccion = 1
        a.nombreOriginal = "ArchivoOriginal.cbr"
        a.formatoEscaneo = "HD"
        a.entidadEscaneo = "Escaneador Demo"
        a.fechaImportacion = Date()
        
        a.estadisticas = EstadisticasYProgresoLectura(url: a.url)
        a.estadisticas.progreso = 34
        a.estadisticas.progresoDouble = 0.34
        // Valores calculados inicializados a 0 o nil seguros
//        a.tiempoTotal = 0
//        a.tiempoPorPagina = 0
//        a.tiempoRestante = 0
//        a.paginaVisitadaMasTiempo = (0, 0)
//        a.paginasRestantes = 75
//        a.paginaMasVisitada = (0,0)
//        a.avanceDiario = 0
//        a.diasTotalesLectura = 0
//        a.diasConsecutivosLecutra = 0
//        a.horaFrecuente = nil
//        a.velocidadLectura = 0
//        a.velocidadMax = 0
//        a.velocidadMin = 0
//        a.masInformacion = true
        
        return a
    }
}



class Archivo: ElementoSistemaArchivos, ProtocoloArchivo {
    
    // --- PREVIEW ---
//    private func cargarOAveriguar<T>(
//        atributo: String,
//        tipo: T.Type,
//        desde url: URL,
//        extractor: () -> T?
//    ) -> T? {
//        if let valor = PersistenciaDatos().obtenerAtributoConcreto(url: url, atributo: atributo) as? T {
//            return valor
//        }
//        return extractor()
//    }
    
//    func inicializarValoresEstadisticos() {
//        
//        self.nombreOriginal = cargarOAveriguar(atributo: "nombreOriginal", tipo: String.self, desde: self.url) { nil }
//        self.fechaPublicacion = cargarOAveriguar(atributo: "fechaPublicacion", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { Fechas().extraerAno(from: $0) } }
//        self.formatoEscaneo = cargarOAveriguar(atributo: "formatoEscaneo", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerFormatoEscaneo(from: $0) } }
//        self.entidadEscaneo = cargarOAveriguar(atributo: "entidadEscaneo", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerEntidad(from: $0) } }
//        self.numeroDeLaColeccion = cargarOAveriguar(atributo: "numeroDeLaColeccion", tipo: Int.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerNumeroDeLaColeccion(from: $0) } }
//        
//        if let fechaString = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "fechaImportacion") as? String,
//           let fecha = Fechas().parseDate1(fechaString) {
//            self.fechaImportacion = fecha
//        }
//        
//        //Obtenemos la puntuacion
//        if let puntuacion = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "puntuacion") as? Double {
//            self.puntuacion = puntuacion
//        }
//        
//        //OBTENER LAS DIMENDIONES DE LAS PORTADAS
//        
//        // TIEMPOS
////        tiempoTotal = 0
////        tiempoPorPagina = 0
////        tiempoRestante = 0
////        
////        // PÁGINAS
////        paginaVisitadaMasTiempo = (0, 0)
////        paginasRestantes = 10
////        paginaMasVisitada = (0,0)
////        
////        // DÍAS
////        avanceDiario = 0
////        diasTotalesLectura = 0
////        diasConsecutivosLecutra = 0
////        horaFrecuente = nil // Mejor nil si no hay hora registrada aún
////        
////        // VELOCIDAD
////        velocidadLectura = 0
////        velocidadMax = 0
////        velocidadMin = 0
////        
////        masInformacion = true
//        
//    }// --- PREVIEW ---
    
    //MARK: - --- CONSTANTES DE ESTRCUCTURAS ---
    let pd = PersistenciaDatos()
    let cpe = ClavesPersistenciaElementos()
    let p = ValoresElementoPredeterminados()
    
    //MARK: - --- INFORMACION GENERALES ---
    @Published var tipoMiniatura: EnumTipoMiniatura = .primeraPagina
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
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
    
    @Published var puntuacion: Double = 0
    var autor: String = ""
    var idioma: EnumIdiomas = .castellano
    var genero: String = ""
    
    //MODELOS NECESARIOS
    private let sau = SistemaArchivosUtilidades.sau
    
    override init() {
        self.dirURL = URL(fileURLWithPath: "")
        self.dirName = ""
        self.dirColor = .gray
        self.estadisticas = EstadisticasYProgresoLectura(url: dirURL)
        
        self.esColeccion = false
        self.fileType = .unknown
        self.fileExtension = ""
        self.mimeType = "application/octet-stream"
        self.fileSize = 0
        self.isReadable = false
        self.isWritable = false
        self.isExecutable = false
        
//        self.progreso = 0
//        self.paginaActual = 0
        
//        self.tiempoTotal = 0
        
//        self.tiemposPorPagina = [:]
//        self.visitasPorPagina = [:]
        
        super.init()
    }
    
    //CONSTRUCTOR DE VERDAD
    init(fileName: String, fileURL: URL, fechaImportacion: Date, fechaModificacion: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
        
        self.estadisticas = EstadisticasYProgresoLectura(url: fileURL)
        
        self.fileType = fileType
        self.fileExtension = fileExtension
        self.mimeType = sau.getMimeType(for: fileURL)
        self.fileSize = fileSize
        
        let permissions = sau.getFilePermissions(for: fileURL)
        
        self.isReadable = permissions.readable
        self.isWritable = permissions.writable
        self.isExecutable = permissions.executable
        
        //enum
        self.tipoMiniatura = pd.recuperarDatoArchivoEnum(elementoURL: fileURL, key: cpe.miniaturaElemento, default: p.miniaturaElemento)
        
        //puntuacion (rating)
        self.puntuacion = pd.recuperarDatoElemento(elementoURL: fileURL, key: cpe.puntuacion, default: p.puntuacion)
        
        super.init(nombre: fileName, url: fileURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, favortio: favorito, protegido: protegido)
        
        self.cargarPaginasAsync()
        
    }
    
    /**
     Carga los datos necesarios para cuando se ejecuta la vista "mas informacion".
     Datos que no son necesarios al crear la instancia.
     */
    public func cargarDatosMasInformacion() {
        self.autor = pd.recuperarDatoElemento(elementoURL: self.url, key: cpe.autor, default: p.autor)
        self.descripcion = pd.recuperarDatoElemento(elementoURL: self.url, key: cpe.descripcion, default: p.descripcion)
    }
    

    
    //MARK: - --- FUNCIONES GENERALES ---
    func viewContent() -> AnyView {
        return AnyView(ZStack{})
    }
    
//    func getTotalPages() -> Int {
//        return self.totalPaginas ?? 0
//    }
    
    //MARK: - --- FUNCIONES POLIMORFICAS PARA SER OVRRIDEADAS ---
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
    
    //Solamente se guardara la primera vez que se lea con la fecha en persistencia
    override var fechaPrimeraVezEntrado: Date? { didSet { pd.guardarDatoArchivo(valor: fechaPrimeraVezEntrado, elementoURL: url, key: cpe.fechaPrimeraVezEntrado) } }
    
    //NECESARIAS PARA SABER CUANDO SE INICIA LA LECTURA
    var leyendose: Bool = false {
        didSet {
            if leyendose {
                //Siempre que se vaya a iniciar la lectura...
                //Comprobamos si es la primera vez
                if self.fechaPrimeraVezEntrado == nil {
                    print("Se entra por primera vez...")
                    self.fechaPrimeraVezEntrado = Date() //Si es la primera agregamos la fecha en la que se entro.
                }
                
                //Sumamos una entrada
//                self.vecesEntrado += 1
                
                //Iniciamos la lectura
                estadisticas.iniciarLectura()
            } else {
                estadisticas.terminarLectura()
            }
        }
    }
    

    
}
