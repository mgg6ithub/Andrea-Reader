
import SwiftUI
import Combine

extension Archivo {
    static var preview: Archivo {
        let a = Archivo()
        
        // Datos de archivo
        a.nombre = "Archivo Demo"
        a.totalPaginas = 120
        a.paginaActual = 45
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
        
        // Valores calculados inicializados a 0 o nil seguros
        a.tiempoTotal = 0
        a.tiempoPorPagina = 0
        a.tiempoRestante = 0
        a.paginaVisitadaMasTiempo = (0, 0)
        a.paginasRestantes = 75
        a.paginaMasVisitada = 10
        a.avanceDiario = 0
        a.diasTotalesLectura = 0
        a.diasConsecutivosLecutra = 0
        a.horaFrecuente = nil
        a.velocidadLectura = 0
        a.velocidadMax = 0
        a.velocidadMin = 0
        a.masInformacion = true
        
        return a
    }
}



class Archivo: ElementoSistemaArchivos, ProtocoloArchivo {
    
    // --- PREVIEW ---
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
        
        self.nombreOriginal = cargarOAveriguar(atributo: "nombreOriginal", tipo: String.self, desde: self.url) { nil }
        self.fechaPublicacion = cargarOAveriguar(atributo: "fechaPublicacion", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { Fechas().extraerAno(from: $0) } }
        self.formatoEscaneo = cargarOAveriguar(atributo: "formatoEscaneo", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerFormatoEscaneo(from: $0) } }
        self.entidadEscaneo = cargarOAveriguar(atributo: "entidadEscaneo", tipo: String.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerEntidad(from: $0) } }
        self.numeroDeLaColeccion = cargarOAveriguar(atributo: "numeroDeLaColeccion", tipo: Int.self, desde: self.url) { self.nombreOriginal.flatMap { ManipulacionCadenas().extraerNumeroDeLaColeccion(from: $0) } }
        
        if let fechaString = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "fechaImportacion") as? String,
           let fecha = Fechas().parseDate1(fechaString) {
            self.fechaImportacion = fecha
        }
        
        //Obtenemos la puntuacion
        if let puntuacion = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "puntuacion") as? Double {
            self.puntuacion = puntuacion
        }
        
        //OBTENER LAS DIMENDIONES DE LAS PORTADAS
        
        // TIEMPOS
        tiempoTotal = 0
        tiempoPorPagina = 0
        tiempoRestante = 0
        
        // PÁGINAS
        paginaVisitadaMasTiempo = (0, 0)
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
        
    }// --- PREVIEW ---
    
    
    // --- PROGRESO DEL ARCHIVO ---
    let pd = PersistenciaDatos()
    let cpe = ClavesPersistenciaElementos()
    let p = ValoresElementoPredeterminados()
    
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
    
    @Published var puntuacion: Double = 0
    var autor: String = ""
    var idioma: EnumIdiomas = .castellano
    var genero: String = ""
    
    //MARK: - --- VARIABLES CALCULADAS ---
    //PROGRESO
    @Published var totalPaginas: Int? {
        didSet {
            actualizarProgreso()
        }
    }
    
    //TIEMPO
    private var inicioLectura: Date?
    
    var estaLeyendose: Bool = false {
        didSet {
            if estaLeyendose {
                iniciarLectura()
            } else {
                terminarLectura()
            }
        }
    }
    
    @Published var progreso: Int = 0
    @Published var progresoEntero: Double = 0
    @Published var paginaActual: Int { didSet { pd.guardarDatoArchivo(valor: paginaActual, elementoURL: self.url, key: cpe.progresoElemento) }}
    
    //TIEMPOS
    private var timerCancellable: AnyCancellable?
    @Published var tiempoActual: TimeInterval = 0      // se actualiza en vivo
    @Published var tiempoTotal: TimeInterval { didSet { pd.guardarDatoArchivo(valor: Int(tiempoTotal), elementoURL: url, key: cpe.tiempoLecturaTotal) } } //guardamos el tiempo total al cambiarse
    var tiempoPorPagina: TimeInterval = 0 // <- grafica de barras o algo por el estilo moderno
    var tiempoRestante: TimeInterval = 0 // <- implicito en el progreso circular
    
    //Paginas
    private var inicioPagina: Date?
    @Published var paginaVisitadaMasTiempo: (Int, TimeInterval) = (0,0)// <- Curiosidad
    var paginasRestantes: Int?          // <- progresp circular
    @Published var paginaMasVisitada: Int = 0         // <- Curiosidad
    
    private var tiemposPorPagina: [Int: TimeInterval] = [:]  // tiempo acumulado
    private var visitasPorPagina: [Int: Int] = [:]           // nº de veces abierta
    
    //DIAS (ESTO ES MAS PARA ARCHIVOS GRANDES)
    var avanceDiario: Double?
    var diasTotalesLectura: Int?
    var diasConsecutivosLecutra: Int?
    var horaFrecuente: Date?
    
    //velocidad <- necesito un grafico
    var velocidadLectura: Double?
    var velocidadMax: Double?
    var velocidadMin: Double?
    
    var masInformacion: Bool = false
    
    //MODELOS NECESARIOS
    private let sau = SistemaArchivosUtilidades.sau
    
    @Published var completado: Bool = false
    
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
        
        self.tiempoTotal = 0
        
        super.init()
    }
    
    //CONSTRUCTOR DE VERDAD
    init(fileName: String, fileURL: URL, fechaImportacion: Date, fechaModificacion: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
        self.fileType = fileType
        self.fileExtension = fileExtension
        self.mimeType = sau.getMimeType(for: fileURL)
        self.fileSize = fileSize
        
        let permissions = sau.getFilePermissions(for: fileURL)
        
        self.isReadable = permissions.readable
        self.isWritable = permissions.writable
        self.isExecutable = permissions.executable
        
        //entero
        self.paginaActual = pd.recuperarDatoElemento(elementoURL: fileURL, key: cpe.progresoElemento, default: p.progresoElemento)
        
        //enum
        self.tipoMiniatura = pd.recuperarDatoArchivoEnum(elementoURL: fileURL, key: cpe.miniaturaElemento, default: p.miniaturaElemento)
        
        self.tiempoTotal = pd.recuperarDatoElemento(elementoURL: fileURL, key: cpe.tiempoLecturaTotal, default: p.tiempoLecturaTotal)
        
        super.init(nombre: fileName, url: fileURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, favortio: favorito, protegido: protegido)
        
        self.cargarPaginasAsync()
        
    }
    
    //MARK: - --- FUNCIONES GENERALES ---
    func viewContent() -> AnyView {
        return AnyView(ZStack{})
    }
    
    func getTotalPages() -> Int {
        return self.totalPaginas ?? 0
    }
    
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
    
    //MARK: - --- PROGRESO Y ESTADISTICAS ---
    func setCurrentPage(currentPage: Int) {
        
        // 1. Guardar tiempo en la página actual
        if let inicio = inicioPagina {
            let tiempoLeido = Date().timeIntervalSince(inicio)
            tiemposPorPagina[paginaActual, default: 0] += tiempoLeido
        }
        
        paginaActual = max(0, currentPage) //<- asigna la pagina actual
        withAnimation {
            actualizarProgreso()
        }
        
        // 3. Registrar visita
       visitasPorPagina[paginaActual, default: 0] += 1
       
       // 4. Reiniciar inicio de cronómetro
       inicioPagina = Date()
        
    }
    
    private func actualizarProgreso() {
        guard let total = totalPaginas, total > 1 else {
            progreso = 0
            progresoEntero = 0
            return
        }
        let frac = Double(min(paginaActual, total - 1)) / Double(total - 1)
        progresoEntero = frac
        progreso = Int(round(frac * 100))
    }
    
    
    public func completarLectura() {
        guard let total = totalPaginas, total > 0 else { return }
        if progreso != 100 {
            paginaActual = total - 1
            completado = true
        } else {
            paginaActual = 0
            completado = false
        }
        actualizarProgreso()
        pd.guardarDatoElemento(url: url, atributo: "progreso", valor: progreso)
    }
    
    
    //MARK: - --- ESTADISTICAS ---
    func iniciarLectura() {
        guard inicioLectura == nil else { return }
        inicioLectura = Date()
        
        // Iniciar un timer cada segundo
        timerCancellable = Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { [weak self] (_: Date) in   // 👈 aclarar que el valor emitido es Date
                guard let self = self, let inicio = self.inicioLectura else { return }
                self.tiempoActual = Date().timeIntervalSince(inicio)
            }
    }
    
    func terminarLectura() {
        guard let inicio = inicioLectura else { return }
        
        let sesion = Date().timeIntervalSince(inicio)
        tiempoTotal += sesion
        tiempoActual = 0
        inicioLectura = nil
        
        // ⬇️ Muy importante: acumular tiempo en la página actual
        if let inicioPagina = inicioPagina {
            let tiempoLeido = Date().timeIntervalSince(inicioPagina)
            tiemposPorPagina[paginaActual, default: 0] += tiempoLeido
            self.inicioPagina = nil
        }
        
        //Recalcular tiempos de paginas
        recalcularTiempos()
        recalcularVisitas()
        
        //velocidad de lectura
        calcularVelocidadLectura()
        
        // Parar el timer
        timerCancellable?.cancel()
        timerCancellable = nil
        
    }
    
    //FUNCIONES AUXILIARES PARA LAS ESTADISTICAS
    private func recalcularTiempos() {
        if let (pagina, value) = tiemposPorPagina.max(by: { $0.value < $1.value }) {
            paginaVisitadaMasTiempo = (pagina, value)
            print("Pagina \(paginaVisitadaMasTiempo.0) visitada durante \(paginaVisitadaMasTiempo.1)")
        }
    }

    private func recalcularVisitas() {
        if let (pagina, _) = visitasPorPagina.max(by: { $0.value < $1.value }) {
            paginaMasVisitada = pagina
            print("Pagina mas visitada: \(paginaMasVisitada)")
        }
    }
    
    //VELOCIDAD DE LECTURA: Paginas por minuto
    func calcularVelocidadLectura() {
        guard let total = totalPaginas, total > 0 else { return }
        let paginasLeidas = min(paginaActual, total)
        guard paginasLeidas > 0, tiempoTotal > 0 else { return }
        
        velocidadLectura = Double(paginasLeidas) / (tiempoTotal / 60.0)
        print("Velocidad de lectura: ", velocidadLectura)
    }
    
}
