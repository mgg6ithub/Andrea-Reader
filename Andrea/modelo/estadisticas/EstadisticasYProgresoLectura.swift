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
    private var inicioPaginaFecha: Date? //<- calcular el tiempo
    
    @Published var paginaActual: Int { didSet { pd.guardarDatoArchivo(valor: paginaActual, elementoURL: self.url, key: cpe.progresoElemento) }} //<-guardar en persistencia la pagina actual}} //<-calculamos las paginas complementarias restantes
    
    //SESIONES DE LECTURA
    private var sesionActual: SesionDeLectura?
    @Published var sesionesLectura: [SesionDeLectura] = [] {didSet { pd.guardarSesiones(self.sesionesLectura, for: url, key: cpe.sesionesLecturas) }}
    private var contadorSesiones: Int { (sesionesLectura.map { $0.numeroSesion }.max() ?? 0) + 1 }
    
    @Published var paginasRestantes: Int = 0
    // --- PAGINAS ---
    @Published var paginaVisitadaMasTiempo: (Int, TimeInterval) = (0,0)// <- Curiosidad
    @Published var paginaMasVisitada: (Int, Int) = (0,0)         // <- Curiosidad
    @Published var tiemposPorPagina: [Int: TimeInterval] { didSet { recalcularTiempos() } }
    @Published var visitasPorPagina: [Int: Int] { didSet { recalcularVisitas() } }
    
    @Published var progreso: Int = 0
    @Published var progresoDouble: Double = 0.0 //redondeado a dos decimales si el progreso es %53 -> 0.53
    @Published var progresoRestante: Int = 0
    
    @Published var progresoTiempoTotal: Int = 0
    @Published var progresoTiempoTotalDouble: Double = 0.0
    
    // --- TIEMPOS ---
    private var timerCancellable: AnyCancellable?
    private var tiempoAcumuladoSesion: TimeInterval = 0
    @Published var tiempoActual: TimeInterval = 0      // se actualiza en vivo
    @Published var tiempoTotal: TimeInterval { didSet { pd.guardarDatoArchivo(valor: Int(tiempoTotal), elementoURL: url, key: cpe.tiempoLecturaTotal) } } //guardamos el tiempo total al cambiarse
    @Published var tiempoRestante: TimeInterval = 0 // <- implicito en el progreso circular
    var tiempoPorPagina: TimeInterval = 0 // <- grafica de barras o algo por el estilo moderno
    
    // --- VELOCIDAD ---
    var velocidadLectura: Double?
    var velocidadMax: Double?
    var velocidadMin: Double?
    
    //--- VELOCIDAD SESIONES ---
    var velocidadSesionMed: Double = 0
    var velocidadSesionMax: Double = 0
    var velocidadSesionMin: Double = 0
    
    // --- AVANCES Y HABITOS ---
    var avanceDiario: Double?
    var diasTotalesLectura: Int?
    var diasConsecutivosLecutra: Int?
    var horaFrecuente: Date?
    
    var masInformacion: Bool = false
    @Published var completado: Bool = false
    
    //TIEMPOS MEJORA ESTADISTICAS REALES
    private let tiempoMinimoLectura: TimeInterval = 4.0   // Sesiones cortas
    private let tiempoMinimoPagina: TimeInterval = 4.0    // Páginas rápidas
    private var lecturaValidada = false                   // Marca si la sesión es válida
    
    //VARIABLE PARA PAUSAR Y REINICIAR LAS ESTADISTICAS (al entrar al menu del archivo)
    private var enPausa: Bool = false   // <- el estado real
    var pausa: Bool = false {
        didSet {
            if pausa {
                self.pausarLectura()
            } else {
                self.reanudarLectura()
            }
        }
    }
    
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
        
        //calcular velocidad lectura media de las sesiones, max y min
        calcularVelocidadesPorSesion()
        
    }
    
    //CONSTRUCTOR DE VERDAD
    init(url: URL) {
        self.url = url
        
        //entero
        self.paginaActual = pd.recuperarDatoElemento(elementoURL: url, key: cpe.progresoElemento, default: p.progresoElemento)
        self.tiempoTotal = pd.recuperarDatoElemento(elementoURL: url, key: cpe.tiempoLecturaTotal, default: p.tiempoLecturaTotal)
        self.tiemposPorPagina = pd.recuperarTiemposPorPagina(elementoURL: url, key: cpe.tiemposPorPagina)
        self.visitasPorPagina = pd.recuperarVisitasPorPagina(elementoURL: url, key: cpe.visitasPorPagina)
        
        self.sesionesLectura = pd.recuperarSesiones(for: url, key: cpe.sesionesLecturas)

    }
    
    //actualizacion de la pagina actual <- muy importante
    public func setCurrentPage(currentPage: Int) {
        // 1. Guardar tiempo de la página anterior
        if let inicio = inicioPaginaFecha {
            _ = registrarTiempoSiValido(pagina: paginaActual, desde: inicio)
        }
        
        // 2. Actualizar página actual
        paginaActual = max(0, currentPage)
        withAnimation { actualizarProgreso() }
        
        // 3. Reiniciar cronómetro solo si no está en pausa
         if !enPausa {
             inicioPaginaFecha = Date()
         } else {
             inicioPaginaFecha = nil
         }
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
    
    /// Registra el tiempo y la visita de una página si supera el umbral mínimo
    @discardableResult
    private func registrarTiempoSiValido(pagina: Int, desde inicio: Date) -> Bool {
        
        guard !enPausa else {
            print("⏸ Ignorado (menú activo)")
            return false
        }
        
        print("Registrando el tiempo en la pagina: ", pagina)
        
        let tiempoLeido = Date().timeIntervalSince(inicio)
        if tiempoLeido >= tiempoMinimoPagina {
            tiemposPorPagina[pagina, default: 0] += tiempoLeido
            visitasPorPagina[pagina, default: 0] += 1
            return true
        } else {
            print("⚠️ Página \(pagina) ignorada (solo \(tiempoLeido)s)")
            return false
        }
    }

    
    // ---------------------- //
    // Iniciar lectura normal //
    // ---------------------- //
    func iniciarLectura() {
        guard inicioLectura == nil else { return }

        inicioLectura = Date()
        lecturaValidada = false
        tiempoAcumuladoSesion = 0

        sesionActual = SesionDeLectura(
            numeroSesion: contadorSesiones,
            inicio: Date(),
            fin: nil,
            paginaInicio: paginaActual,
            paginaFin: paginaActual,
            paginasLeidas: 0,
            velocidadLectura: 0.0
        )

        // Validar sesión solo si pasa el umbral
        DispatchQueue.main.asyncAfter(deadline: .now() + tiempoMinimoLectura) { [weak self] in
            guard let self = self, self.inicioLectura != nil else { return }
            self.lecturaValidada = true
        }

        // Timer de visualización
        timerCancellable = Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { [weak self] (_: Date) in
                guard let self = self, let inicio = self.inicioLectura else { return }
                let parcial = self.tiempoAcumuladoSesion + Date().timeIntervalSince(inicio)
                self.tiempoActual = parcial
            }
    }

    // ----------------------- //
    // Terminar lectura total  //
    // ----------------------- //
    func terminarLectura() {
        pausa = false
        enPausa = false

        var sesion = tiempoAcumuladoSesion
        if let inicio = inicioLectura {
            sesion += Date().timeIntervalSince(inicio)
        }

        inicioLectura = nil
        tiempoAcumuladoSesion = 0
        tiempoActual = 0

        timerCancellable?.cancel()
        timerCancellable = nil

        // ⚠️ Validación de la sesión
        guard lecturaValidada else {
            print("⚠️ Sesión descartada por ser demasiado corta (\(sesion)s)")
            sesionActual = nil
            return
        }

        if var sesionObj = sesionActual {
            sesionObj.fin = Date()
            sesionObj.paginaFin = paginaActual
            sesionObj.paginasLeidas = max(0, paginaActual - sesionObj.paginaInicio)

            // ⚠️ Nuevo filtro: no contar sesiones sin avance
            guard sesionObj.paginasLeidas > 0 else {
                print("⚠️ Sesión descartada (sin páginas leídas)")
                sesionActual = nil
                return
            }

            let duracionMinutos = sesionObj.fin!.timeIntervalSince(sesionObj.inicio) / 60
            sesionObj.velocidadLectura = Double(sesionObj.paginasLeidas) / duracionMinutos

            sesionesLectura.append(sesionObj)
            sesionActual = nil

            tiempoTotal += sesion
        }

        // Persistencia
        pd.guardarDatoArchivo(valor: tiemposPorPagina, elementoURL: url, key: cpe.tiemposPorPagina)
        pd.guardarDatoArchivo(valor: visitasPorPagina, elementoURL: url, key: cpe.visitasPorPagina)
    }


    // ---------------------- //
    // Pausar solo temporal   //
    // ---------------------- //
    public func pausarLectura() {
        guard !enPausa else { return }
        enPausa = true

        // Acumula tiempo hasta ahora
        if let inicio = inicioLectura {
            tiempoAcumuladoSesion += Date().timeIntervalSince(inicio)
            inicioLectura = nil
        }

        timerCancellable?.cancel()
        timerCancellable = nil

        if let inicio = inicioPaginaFecha {
            _ = registrarTiempoSiValido(pagina: paginaActual, desde: inicio)
            inicioPaginaFecha = nil
        }

        print("⏸ Lectura en pausa (acumulado: \(tiempoAcumuladoSesion)s)")
    }

    // ---------------------- //
    // Reanudar después pausa //
    // ---------------------- //
    public func reanudarLectura() {
        guard enPausa else { return }
        enPausa = false

        inicioLectura = Date()
        inicioPaginaFecha = Date()

        timerCancellable = Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { [weak self] (_: Date) in
                guard let self = self, let inicio = self.inicioLectura else { return }
                let parcial = self.tiempoAcumuladoSesion + Date().timeIntervalSince(inicio)
                self.tiempoActual = parcial
            }

        print("▶️ Lectura reanudada (acumulado: \(tiempoAcumuladoSesion)s)")
    }
    
    
    private func calcularPaginasRestantes() -> Int {
        guard let total = totalPaginas else { return 0 }
        return max(total - (paginaActual + 1), 0)
    }

    
    //FUNCIONES AUXILIARES PARA LAS ESTADISTICAS
    private func recalcularTiempos() {
        if let (pagina, value) = tiemposPorPagina.max(by: { $0.value < $1.value }) {
            paginaVisitadaMasTiempo = (pagina, value)
        }
    }

    private func recalcularVisitas() {
        if let (pagina, value) = visitasPorPagina.max(by: { $0.value < $1.value }) {
            paginaMasVisitada = (pagina, value)
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
    private func estimarTiempoRestante(velocidadPaginasPorMinuto v: Double? = nil) -> TimeInterval {
        let total = totalPaginas ?? 0
        guard total > 0 else { return 0 }

        // Si paginaActual es índice 0-based y quieres "después de la actual":
        let paginasDespuesDeLaActual = max(total - 1 - paginaActual, 0)

        // Tiempo ya invertido en la página actual
        let tiempoEnActual = inicioPaginaFecha.map { Date().timeIntervalSince($0) } ?? 0

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
    
    func progresoRealEnFecha(_ fecha: Date) -> Double {
        let paginasLeidas = sesionesLectura
            .filter { $0.inicio <= fecha }
            .reduce(0) { $0 + $1.paginasLeidas }
        guard let total = totalPaginas else { return 0.0 }
        return (Double(paginasLeidas) / Double(total)) * 100
    }
    
    func progresoIdealEnFecha(_ fecha: Date) -> Double {
        guard let primera = sesionesLectura.first?.inicio,
              let ultima   = sesionesLectura.last?.inicio else { return 0 }
        
        let totalIntervalo = ultima.timeIntervalSince(primera)
        let transcurrido   = fecha.timeIntervalSince(primera)
        
        if totalIntervalo <= 0 { return 0 }
        
        return (transcurrido / totalIntervalo) * 100
    }
    
    private func calcularVelocidadesPorSesion() {
        
        var sMedCount: Double = 0
        var vMax: Double = 0
        var vMin: Double = 0
        
        for s in self.sesionesLectura {
            let sv = s.velocidadLectura
            
            sMedCount += sv
            if sv > vMax { vMax = sv }
            if vMin == 0 { vMin = sv }
            if sv < vMin { vMin = sv }
        }
        
        self.velocidadSesionMed = sMedCount / Double(self.sesionesLectura.count)
        self.velocidadSesionMax = vMax
        self.velocidadSesionMin = vMin
        
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
    
    private func imprimirSesionesLectura() {
        
        print()
        print("SESIONES DE LECTURA")
        for s in self.sesionesLectura {
            print("Sesion \(s.numeroSesion)")
            print("--------------------------------")
            print("fecha inicio: ", s.inicio)
            print("fecha fin: ", s.fin as Any)
            print("pagina inicio: ", s.paginaInicio)
            print("pagina fin: ", s.paginaFin)
            print("paginas totales: ", s.paginasLeidas)
            print("velocidad: ", s.velocidadLectura)
            print("--------------------------------")
            print()
        }
        
    }
    
}

struct SesionDeLectura: Codable, Identifiable {
    let id: UUID
    let numeroSesion: Int
    let inicio: Date
    var fin: Date?
    var paginaInicio: Int
    var paginaFin: Int
    var paginasLeidas: Int
    var velocidadLectura: Double

    init(numeroSesion: Int, inicio: Date, fin: Date? = nil,
         paginaInicio: Int, paginaFin: Int, paginasLeidas: Int, velocidadLectura: Double) {
        self.id = UUID()
        self.numeroSesion = numeroSesion
        self.inicio = inicio
        self.fin = fin
        self.paginaInicio = paginaInicio
        self.paginaFin = paginaFin
        self.paginasLeidas = paginasLeidas
        self.velocidadLectura = velocidadLectura
    }
}
