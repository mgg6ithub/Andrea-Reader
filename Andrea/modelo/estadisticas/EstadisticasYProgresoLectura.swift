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
    private let tiempoMinimoLectura: TimeInterval = 2.0   // Sesiones cortas
    private let tiempoMinimoPagina: TimeInterval = 2.0    // Páginas rápidas
    private var lecturaValidada = false                   // Marca si la sesión es válida
    
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
        
        // TEST
        // Día 1 - hace 1 día desde hoy
//        let dia1 = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
//
//        let s1 = SesionDeLectura(
//            numeroSesion: 1,
//            inicio: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: dia1)!,
//            fin: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: dia1)!,
//            paginaInicio: 0,
//            paginaFin: 12,
//            paginasLeidas: 12,
//            velocidadLectura: 2.5
//        )
//
//        let s2 = SesionDeLectura(
//            numeroSesion: 2,
//            inicio: Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: dia1)!,
//            fin: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: dia1)!,
//            paginaInicio: 12,
//            paginaFin: 22,
//            paginasLeidas: 10,
//            velocidadLectura: 1.8
//        )
//
//        // ➕ Nueva sesión Día 1
//        let s3 = SesionDeLectura(
//            numeroSesion: 3,
//            inicio: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: dia1)!,
//            fin: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: dia1)!,
//            paginaInicio: 22,
//            paginaFin: 30,
//            paginasLeidas: 8,
//            velocidadLectura: 1.6
//        )
//
//
//        // Día 2 - hoy
//        let dia2 = Date()
//
//        let s4 = SesionDeLectura(
//            numeroSesion: 4,
//            inicio: Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: dia2)!,
//            fin: Calendar.current.date(bySettingHour: 10, minute: 15, second: 0, of: dia2)!,
//            paginaInicio: 22,
//            paginaFin: 40,
//            paginasLeidas: 18,
//            velocidadLectura: 3.2
//        )
//
//        let s5 = SesionDeLectura(
//            numeroSesion: 5,
//            inicio: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: dia2)!,
//            fin: Calendar.current.date(bySettingHour: 15, minute: 45, second: 0, of: dia2)!,
//            paginaInicio: 40,
//            paginaFin: 50,
//            paginasLeidas: 10,
//            velocidadLectura: 2.0
//        )
//
//        let s6 = SesionDeLectura(
//            numeroSesion: 6,
//            inicio: Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: dia2)!,
//            fin: Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: dia2)!,
//            paginaInicio: 50,
//            paginaFin: 65,
//            paginasLeidas: 15,
//            velocidadLectura: 7.0
//        )
//
//        // ➕ Nuevas sesiones Día 2
//        let s7 = SesionDeLectura(
//            numeroSesion: 7,
//            inicio: Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: dia2)!,
//            fin: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: dia2)!,
//            paginaInicio: 65,
//            paginaFin: 75,
//            paginasLeidas: 10,
//            velocidadLectura: 2.8
//        )
//
//        let s8 = SesionDeLectura(
//            numeroSesion: 8,
//            inicio: Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: dia2)!,
//            fin: Calendar.current.date(bySettingHour: 23, minute: 45, second: 0, of: dia2)!,
//            paginaInicio: 75,
//            paginaFin: 90,
//            paginasLeidas: 15,
//            velocidadLectura: 3.5
//        )

//        self.sesionesLectura.append(contentsOf: [s1, s2, s3, s4, s5, s6, s7, s8])

    }
    
    //actualizacion de la pagina actual <- muy importante
    public func setCurrentPage(currentPage: Int) {
        // 1. Guardar tiempo de la página anterior
        if let inicio = inicioPaginaFecha {
            _ = registrarTiempoSiValido(pagina: paginaActual, desde: inicio)
        }
        
        // 2. Actualizar página actual
        paginaActual = max(0, currentPage)
        withAnimation {
            actualizarProgreso()
        }
        
        // 3. Reiniciar cronómetro
        inicioPaginaFecha = Date()
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

    
    //MARK: - --- ESTADISTICAS ---
    func iniciarLectura() {
        guard inicioLectura == nil else { return }
        
        inicioLectura = Date()
        lecturaValidada = false
        
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
        
        // Timer de visualización (igual que antes)
        timerCancellable = Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .sink { [weak self] (_: Date) in
                guard let self = self, let inicio = self.inicioLectura else { return }
                self.tiempoActual = Date().timeIntervalSince(inicio)
            }
    }

    
    func terminarLectura() {
        guard let inicio = inicioLectura else { return }
        
        let sesion = Date().timeIntervalSince(inicio)
        inicioLectura = nil
        tiempoActual = 0
        
        timerCancellable?.cancel()
        timerCancellable = nil
        
        // ⚠️ Descartar sesión demasiado corta
        guard lecturaValidada else {
            print("⚠️ Sesión descartada por ser demasiado corta (\(sesion)s)")
            sesionActual = nil
            return
        }
        
        tiempoTotal += sesion
        
        // ⬇️ Usar función utilitaria para registrar la última página
        if let inicioPaginaFecha = inicioPaginaFecha {
            _ = registrarTiempoSiValido(pagina: paginaActual, desde: inicioPaginaFecha)
            self.inicioPaginaFecha = nil
        }
        
        if var sesion = sesionActual {
            sesion.fin = Date()
            sesion.paginaFin = paginaActual
            sesion.paginasLeidas = max(1, paginaActual - sesion.paginaInicio)
            
            let duracionMinutos = sesion.fin!.timeIntervalSince(sesion.inicio) / 60
            sesion.velocidadLectura = Double(sesion.paginasLeidas) / duracionMinutos
            
            sesionesLectura.append(sesion)
            sesionActual = nil
        }
        
        pd.guardarDatoArchivo(valor: tiemposPorPagina, elementoURL: url, key: cpe.tiemposPorPagina)
        pd.guardarDatoArchivo(valor: visitasPorPagina, elementoURL: url, key: cpe.visitasPorPagina)
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
