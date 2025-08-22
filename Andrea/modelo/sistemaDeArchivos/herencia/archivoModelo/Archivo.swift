
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
        a.paginaMasVisitada = (0,0)
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
        paginasRestantes = 10
        paginaMasVisitada = (0,0)
        
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
    
    //MARK: - --- CONSTANTES DE ESTRCUCTURAS ---
    let pd = PersistenciaDatos()
    let cpe = ClavesPersistenciaElementos()
    let p = ValoresElementoPredeterminados()
    
    //MARK: - --- INFORMACION GENERALES ---
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
    
    //MARK: - --- VARIABLES CALCULADAS Y ESTADISTICAS ---
    
    //Solamente se guardara la primera vez que se lea con la fecha en persistencia
    override var fechaPrimeraVezEntrado: Date? { didSet { pd.guardarDatoArchivo(valor: fechaPrimeraVezEntrado, elementoURL: url, key: cpe.fechaPrimeraVezEntrado) } }
    
    //NECESARIAS PARA SABER CUANDO SE INICIA LA LECTURA
    private var inicioLectura: Date?
    var estaLeyendose: Bool = false {
        didSet {
            if estaLeyendose {
                //Siempre que se vaya a iniciar la lectura...
                //Comprobamos si es la primera vez
                if self.fechaPrimeraVezEntrado == nil {
                    print("Se entra por primera vez...")
                    self.fechaPrimeraVezEntrado = Date() //Si es la primera agregamos la fecha en la que se entro.
                }
                
                //Sumamos una entrada
//                self.vecesEntrado += 1
                
                //Iniciamos la lectura
                iniciarLectura()
            } else {
                terminarLectura()
            }
        }
    }
    
    // --- PROGRESO Y PAGINAS ---
    @Published var totalPaginas: Int? { didSet { actualizarProgreso() } }
    
    @Published var paginaActual: Int { didSet { pd.guardarDatoArchivo(valor: paginaActual, elementoURL: self.url, key: cpe.progresoElemento) }} //<-guardar en persistencia la pagina actual}} //<-calculamos las paginas complementarias restantes
    
    @Published var paginasRestantes: Int = 0
    // --- PAGINAS ---
    @Published var paginaVisitadaMasTiempo: (Int, TimeInterval) = (0,0)// <- Curiosidad
    @Published var paginaMasVisitada: (Int, Int) = (0,0)         // <- Curiosidad
    @Published private var tiemposPorPagina: [Int: TimeInterval] { didSet { recalcularTiempos() } }
    @Published private var visitasPorPagina: [Int: Int] { didSet { recalcularVisitas() } }
    
    @Published var progreso: Int = 0
    @Published var progresoDouble: Double = 0.0 //redondeado a dos decimales si el progreso es %53 -> 0.53
    @Published var progresoRestante: Int = 0
    
    @Published var progresoTiempoTotal: Int = 0
    @Published var progresoTiempoTotalDouble: Double = 0.0
    
    
    // --- TIEMPOS ---
    private var timerCancellable: AnyCancellable?
    @Published var tiempoActual: TimeInterval = 0      // se actualiza en vivo
    @Published var tiempoTotal: TimeInterval { didSet { pd.guardarDatoArchivo(valor: Int(tiempoTotal), elementoURL: url, key: cpe.tiempoLecturaTotal) } } //guardamos el tiempo total al cambiarse
    @Published var tiempoRestante: TimeInterval = 0 // <- implicito en el progreso circular
    private var inicioPagina: Date? //<- calcular el tiempo
    var tiempoPorPagina: TimeInterval = 0 // <- grafica de barras o algo por el estilo moderno

    
    // --- VELOCIDAD ---
    var velocidadLectura: Double?
    var velocidadMax: Double?
    var velocidadMin: Double?
    
    // --- AVANCES Y HABITOS ---
    var avanceDiario: Double?
    var diasTotalesLectura: Int?
    var diasConsecutivosLecutra: Int?
    var horaFrecuente: Date?
    
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
        
        self.tiemposPorPagina = [:]
        self.visitasPorPagina = [:]
        
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
        
        self.tiemposPorPagina = pd.recuperarTiemposPorPagina(elementoURL: fileURL, key: cpe.tiemposPorPagina)
        
        self.visitasPorPagina = pd.recuperarVisitasPorPagina(elementoURL: fileURL, key: cpe.visitasPorPagina)
        
        super.init(nombre: fileName, url: fileURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, favortio: favorito, protegido: protegido)
        
        self.cargarPaginasAsync()
        
    }
    
    //METODO PARA INICIAR LAS ESTADISTICAS COMPLEMENTARIAS A PARTIR DE LAS PRIMARIAS QUE SE INICIALIZAN EN EL CONSTRUCTOR
    public func crearEstadisticas() {
        
//        print("Creando estadisticas")
        self.paginasRestantes = calcularPaginasRestantes()
        self.progresoRestante = 100 - progreso
//        print("Progreso restantes: ", progresoRestante)
        
        //velocidad de lectura
        calcularVelocidadLectura()
//        print("VELOCIDAD: ", velocidadLectura)
        
        //tiempo restante
        print("VARRIABLE TIEMPO TOTAL \(self.tiempoTotal) -> \(type(of: self.tiempoTotal))")
        self.tiempoRestante = estimarTiempoRestante(velocidadPaginasPorMinuto: self.velocidadLectura)
        print("VARRIABLE TIEMPO RESTANTE \(self.tiempoRestante) -> \(type(of: self.tiempoRestante))")
        
        //Calculo del progreso del tiempo total
        var progresott = (tiempoTotal > 0 && (tiempoTotal + tiempoRestante) > 0)
            ? min(tiempoTotal / (tiempoTotal + tiempoRestante), 1.0)
            : 0
        //Si hemos completado la lectura el progreso del tiempo total es 100 y no queda tiempo
        if self.progreso == 100 {
            progresott = 1.0
            self.tiempoRestante = 0
        }
        
        self.progresoTiempoTotal = Int((progresott * 100).rounded())
        print("PROGRESO TIEMPO TOTAL  INT \(self.progresoTiempoTotal) -> \(type(of: self.progresoTiempoTotal))")
        
        self.progresoTiempoTotalDouble = (progresott * 100).rounded() / 100
        print("PROGRESO TIEMPO TOTAL REDONDEADO \(self.progresoTiempoTotalDouble) -> \(type(of: self.progresoTiempoTotalDouble))")
        

        //Recalcular tiempos de paginas
        recalcularTiempos()
        recalcularVisitas()
//        print("Pagina visitada mas tiempo: ", self.paginaVisitadaMasTiempo)
//        print("Pagina mas vis: ", self.paginaMasVisitada)
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
    
    private func calcularPaginasRestantes() -> Int {
        guard let total = totalPaginas else { return 0 }
        return max(total - (paginaActual + 1), 0)
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
        guard let total = totalPaginas, total > 0 else {
            progreso = 0
            progresoDouble = 0
            return
        }
        if total == 1 {
            progreso = 100
            progresoDouble = 1.0
            return
        }
        let frac = Double(min(paginaActual, total - 1)) / Double(total - 1)
        progresoDouble = frac
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
        
//        print("AL ENTRAR DEL COMIC")
//        self.imprimirDatos()
//        print()
        
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
        
//        print("AL SALIR DEL COMIC")
//        self.imprimirDatos()
//        print()
        
        //persistencia
        pd.guardarDatoArchivo(valor: tiemposPorPagina, elementoURL: url, key: cpe.tiemposPorPagina)
        pd.guardarDatoArchivo(valor: visitasPorPagina, elementoURL: url, key: cpe.visitasPorPagina)
        
        // Parar el timer
        timerCancellable?.cancel()
        timerCancellable = nil
        
    }
    
    //FUNCIONES AUXILIARES PARA LAS ESTADISTICAS
    private func recalcularTiempos() {
        if let (pagina, value) = tiemposPorPagina.max(by: { $0.value < $1.value }) {
            paginaVisitadaMasTiempo = (pagina, value)
//            print("Pagina \(paginaVisitadaMasTiempo.0) visitada durante \(paginaVisitadaMasTiempo.1)")
        }
    }

    private func recalcularVisitas() {
        if let (pagina, value) = visitasPorPagina.max(by: { $0.value < $1.value }) {
            paginaMasVisitada = (pagina, value)
//            print("Pagina mas visitada: \(paginaMasVisitada)")
        }
    }
    
    //VELOCIDAD DE LECTURA: Paginas por minuto
    func calcularVelocidadLectura() {
        let totalTiempo = tiemposPorPagina.values.reduce(0, +) // segundos
        let paginasContadas = tiemposPorPagina.keys.count      // páginas con tiempo real
        
        guard paginasContadas > 0, totalTiempo > 0 else { return }
        
        // páginas por minuto
        velocidadLectura = Double(paginasContadas) / (totalTiempo / 60.0)
    }
    
    /// Devuelve el tiempo restante estimado en segundos.
    /// - Parameter v: velocidad en páginas por minuto. Si es nil usa histórico; si tampoco hay, usa proporcional al progreso.
    func estimarTiempoRestante(velocidadPaginasPorMinuto v: Double? = nil) -> TimeInterval {
        let total = totalPaginas ?? 0
        guard total > 0 else { return 0 }

        // Si paginaActual es índice 0-based y quieres "después de la actual":
        let paginasDespuesDeLaActual = max(total - 1 - paginaActual, 0)

        // Tiempo ya invertido en la página actual
        let tiempoEnActual = inicioPagina.map { Date().timeIntervalSince($0) } ?? 0

        // 1) Con velocidad explícita (pág/min)
        if let v, v > 0 {
            let segPorPag = 60.0 / v
            let restanteActual = max(segPorPag - tiempoEnActual, 0)
            return Double(paginasDespuesDeLaActual) * segPorPag + restanteActual
        }

        // 2) Con histórico (media de seg/página terminadas)
        let tiempoLeido = tiemposPorPagina.values.reduce(0, +)
        // Considera completas las páginas con registro + las anteriores a la actual
        let paginasCompletas = max(tiemposPorPagina.count, min(paginaActual, total - 1))
        if paginasCompletas > 0 {
            let mediaSegPorPag = tiempoLeido / Double(paginasCompletas)
            let restanteActual = max(mediaSegPorPag - tiempoEnActual, 0)
            return Double(paginasDespuesDeLaActual) * mediaSegPorPag + restanteActual
        }

        // 3) Fallback proporcional al progreso (si tienes tiempoTotal para todo el libro)
        if tiempoTotal > 0 && total > 1 {
            let fracRestante = Double(paginasDespuesDeLaActual) / Double(total - 1)
            return fracRestante * tiempoTotal
        }

        return 0
    }

    
    private func imprimirDatos() {
        print("Tiempos por pagina")
        for e in self.tiemposPorPagina {
            print("Página \(e.key) -> \(e.value)s")
        }
        print()
        print()
        print("Visitas por pagina")
        for e in self.visitasPorPagina {
            print("Página \(e.key) -> \(e.value)v")
        }
    }
    
}
