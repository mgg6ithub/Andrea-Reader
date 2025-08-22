import SwiftUI
import Combine

final class EstadisticasYProgresoLectura: ObservableObject {
    
    let pd = PersistenciaDatos()
    let cpe = ClavesPersistenciaElementos()
    let p = ValoresElementoPredeterminados()
    
    private let url: URL

    //MARK: - --- VARIABLES CALCULADAS Y ESTADISTICAS ---
    // --- PROGRESO Y PAGINAS ---
    @Published var totalPaginas: Int? { didSet { actualizarProgreso() } }
    
    private var inicioLectura: Date?
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
    @Published var completado: Bool = false
    
    //METODO PARA INICIAR LAS ESTADISTICAS COMPLEMENTARIAS A PARTIR DE LAS PRIMARIAS QUE SE INICIALIZAN EN EL CONSTRUCTOR
    public func crearEstadisticas() {
        self.paginasRestantes = calcularPaginasRestantes()
        self.progresoRestante = 100 - progreso
        
        //velocidad de lectura
        calcularVelocidadLectura()
        
        //tiempo restante
        self.tiempoRestante = estimarTiempoRestante(velocidadPaginasPorMinuto: self.velocidadLectura)
        
        //Calculo del progreso del tiempo total
        var progresott = (tiempoTotal > 0 && (tiempoTotal + tiempoRestante) > 0)
            ? min(tiempoTotal / (tiempoTotal + tiempoRestante), 1.0)
            : 0
        //Si hemos completado la lectura el progreso del tiempo total es 100 y no queda tiempo
        if self.progreso == 100 {
            progresott = 1.0
            self.tiempoRestante = 0
        }
        
        self.progresoTiempoTotal = Int((progresott * 100).rounded()) // <- progreso del tiempo total
        self.progresoTiempoTotalDouble = (progresott * 100).rounded() / 100 // <- lo mismo pero en double

        //Recalcular tiempos de paginas
        recalcularTiempos()
        recalcularVisitas()
    }
    
    init(url: URL) {
        self.url = url
        
        //entero
        self.paginaActual = pd.recuperarDatoElemento(elementoURL: url, key: cpe.progresoElemento, default: p.progresoElemento)
        self.tiempoTotal = pd.recuperarDatoElemento(elementoURL: url, key: cpe.tiempoLecturaTotal, default: p.tiempoLecturaTotal)
        self.tiemposPorPagina = pd.recuperarTiemposPorPagina(elementoURL: url, key: cpe.tiemposPorPagina)
        self.visitasPorPagina = pd.recuperarVisitasPorPagina(elementoURL: url, key: cpe.visitasPorPagina)
    }
    
    public func setCurrentPage(currentPage: Int) {
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
    
    
    private func calcularPaginasRestantes() -> Int {
        guard let total = totalPaginas else { return 0 }
        return max(total - (paginaActual + 1), 0)
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
    // - Parameter v: velocidad en páginas por minuto. Si es nil usa histórico; si tampoco hay, usa proporcional al progreso.
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
