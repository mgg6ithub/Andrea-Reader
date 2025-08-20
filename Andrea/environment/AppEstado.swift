
import SwiftUI

@MainActor
class AppEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let pd = PersistenciaDatos()
    
    //DISPOSITIVO ACTUAL
    @Published var dispositivoActual: EnumDispositivoActual
    
    //MENU LATERAL
    @Published var sideMenuVisible: Bool = false
    
    @Published var archivoEnLectura: Archivo? = nil {
        didSet {
            // Actualiza ultimoArchivoLeido cuando archivoEnLectura cambie
            if archivoEnLectura != nil {
                ultimoArchivoLeido = archivoEnLectura
            }
        }
    }
    
    @Published var ultimoArchivoLeido: Archivo? = nil
    
    // --- VARIABLES AL INICIAR LA APLICACION ---
    @Published var screenWidth: CGFloat
    @Published var screenHeigth: CGFloat
    
    @Published var constantes: Constantes
    
    // --- VARIABLES PARA MANEJAR LA CARGA DINAMICA AL INICIAR LA APLICACION ---
    @Published var menuCargado = false
    @Published var historialCargado = false
    
    @Published var isFirstTimeLaunch: Bool = false
    @Published var resolucionLogica: EnumResolucionesLogicas
    
    //MARK: - --- AJUSTES GENERALES ---
    @Published var seccionSeleccionada: String { didSet {
        pd.guardarAjusteGeneral(valor: seccionSeleccionada, key: cpag.seccionSeleccionada)
    } }
    
    // --- AJUSTES TEMAS ---
    @Published var temaResuelto: EnumTemas = .light 
    @Published var temaActual: EnumTemas { didSet { pd.guardarAjusteGeneral(valor: temaActual, key: cpag.temaActual) } }
    
    // --- AJUSTES DE COLORES ---
    @Published var colorPersonalizadoActual: Color { didSet { pd.guardarAjusteGeneral(valor: colorPersonalizadoActual, key: cpag.colorPersonalizado) } }
    @Published var ajusteColorSeleccionado: EnumAjusteColor { didSet { pd.guardarAjusteGeneral(valor: ajusteColorSeleccionado, key: cpag.ajusteColor) } }
    
    //AJUSTE UNA UNICA VEZ PARA TODO EL PROGRAMA EL COLOR
    var colorActual: Color {
        switch ajusteColorSeleccionado {
        case .colorColeccion:
            return PilaColecciones.pilaColecciones.getColeccionActual().color
        case .colorNeutral:
            return .gray
        case .colorPersonalizado:
            return colorPersonalizadoActual
        }
    }
    
    //SISTEMA ARCHIVOS
    @Published var sistemaArchivos: EnumTipoSistemaArchivos { didSet { pd.guardarAjusteGeneral(valor: sistemaArchivos, key: cpag.sistemaArchivos) } }
    
    // --- RENDIMIENTO
    @Published var shadows: Bool { didSet { pd.guardarAjusteGeneral(valor: shadows, key: cpag.shadows) } }
    @Published var animaciones: Bool = true
    
    // --- MENU ---
    
    // --- HISTORIAL DE COLECCIONES ---
    @Published var historialColecciones: Bool { didSet { pd.guardarAjusteGeneral(valor: historialColecciones, key: cpag.historiaclColecciones) } }
    @Published var historialEstilo: EnumEstiloHistorialColecciones { didSet { pd.guardarAjusteGeneral(valor: historialEstilo, key: cpag.historialEstilo) } }
    @Published var historialSize: Double { didSet { pd.guardarAjusteGeneral(valor: historialSize, key: cpag.historialSize) } }
    
    // --- LIBRERIA ---
    
    //porcentaje
    @Published var porcentaje: Bool { didSet { pd.guardarAjusteGeneral(valor: porcentaje, key: cpag.porcentaje) } }
    
    @Published var porcentajeNumero: Bool { didSet { pd.guardarAjusteGeneral(valor: porcentajeNumero, key: cpag.porcentajeNumero) } }
    @Published var porcentajeNumeroSize: Double { didSet { pd.guardarAjusteGeneral(valor: porcentajeNumeroSize, key: cpag.porcentajeNumeroSize) } }
    
    @Published var porcentajeBarra: Bool { didSet { pd.guardarAjusteGeneral(valor: porcentajeBarra, key: cpag.porcentajeBarra) } }
    
    @Published var porcentajeEstilo: EnumPorcentajeEstilo { didSet { pd.guardarAjusteGeneral(valor: porcentajeBarra, key: cpag.porcentajeBarra) } }
    
    //fondo carta
    @Published var fondoCarta: Bool { didSet { pd.guardarAjusteGeneral(valor: fondoCarta, key: cpag.fondoCarta) } }
    
    // --- MAS INFORMACION DE UN ELEMENTO ---
    @Published var masInformacion: Bool = false
    @Published var elementoSeleccionado: (any ElementoSistemaArchivosProtocolo)? = nil
    @Published var pantallaCompleta: Bool = false

    @Published var vistaPrevia: Bool = false
    
    init(screenWidth: CGFloat? = nil, screenHeight: CGFloat? = nil) {
        self.isFirstTimeLaunch = true
        
        let actualScreenWidth = screenWidth ?? UIScreen.main.bounds.width
        let actualScreenHeight = screenHeight ?? UIScreen.main.bounds.height
                
        var scaleFactor = max(0.49, min(actualScreenWidth / 820, actualScreenHeight / 1180))
        var resLog: EnumResolucionesLogicas = .small
        
        switch scaleFactor {
            case ..<0.5: // Dispositivos pequeños iPhone 8, 7, 6 ...
                resLog = .small
                scaleFactor *= 1.4
            case 0.5...1.0:
                resLog = .medium
                break // No hacer nada
            case let x where x > 1.0:
                resLog = .big
            default:
                resLog = .medium
                break
        }
        
        switch (actualScreenWidth, actualScreenHeight) {
            case (..<380, ..<700):
                self.dispositivoActual = .iphoneGen3
            case (..<500, ..<900):
                self.dispositivoActual = .iphone15
            case (..<750, ..<1100):
                self.dispositivoActual = .ipad
            case (..<850, ..<1200):
                self.dispositivoActual = .ipadGen10
            case (..<1100, ..<1500):
                self.dispositivoActual = .ipad12
            default:
                self.dispositivoActual = .iphone15
                
        }
        
        self.screenWidth = actualScreenWidth
        self.screenHeigth = actualScreenHeight
        
        self.constantes = Constantes(scaleFactor: scaleFactor, resLog: resLog)
        self.resolucionLogica = resLog
        
        //Persistencia
        let p = AjustesGeneralesPredeterminados()
        
        self.seccionSeleccionada = pd.obtenerAjusteGeneral(key: cpag.seccionSeleccionada, default: p.seccionSeleccionada)
        
        //TEMA
        self.temaActual = pd.obtenerAjusteGeneralEnum(key: cpag.temaActual, default: p.temaP)

        // COLOR
        self.colorPersonalizadoActual = pd.obtenerAjusteGeneralColor(key: cpag.colorPersonalizado, default: p.colorP)
        self.ajusteColorSeleccionado = pd.obtenerAjusteGeneralEnum(key: cpag.ajusteColor, default: p.ajusteColorP)

        //SA
        self.sistemaArchivos = pd.obtenerAjusteGeneralEnum(key: cpag.sistemaArchivos, default: p.saP)
        
        // Erendimiento
        self.shadows = pd.obtenerAjusteGeneral(key: cpag.shadows, default: p.shadows)
        // self.animaciones = pd.obtenerAjusteGeneral(key: "animaciones", default: true)
        
        //HISTORIAL
        self.historialColecciones = pd.obtenerAjusteGeneral(key: cpag.historiaclColecciones, default: p.historialColecciones)
        self.historialEstilo = pd.obtenerAjusteGeneralEnum(key: cpag.historiaclColecciones, default: p.historialEstilo)
        self.historialSize = pd.obtenerAjusteGeneral(key: cpag.historialSize, default: p.historialSize)
        
        
        //LIBRERIA
        //porcentaje
        self.porcentaje = pd.obtenerAjusteGeneral(key: cpag.porcentaje, default: p.porcentaje)
        
        self.porcentajeNumero = pd.obtenerAjusteGeneral(key: cpag.porcentajeNumero, default: p.porcentajeNumero)
        self.porcentajeNumeroSize = pd.obtenerAjusteGeneral(key: cpag.porcentajeNumeroSize, default: p.porcentajeNumeroSize)
        
        self.porcentajeBarra = pd.obtenerAjusteGeneral(key: cpag.porcentajeBarra, default: p.porcentajeBarra)
        
        self.porcentajeEstilo = pd.obtenerAjusteGeneralEnum(key: cpag.porcentajeEstilo, default: p.porcentajeEstilo)
        
        //fondo carta
        self.fondoCarta = pd.obtenerAjusteGeneral(key: cpag.fondoCarta, default: p.fondoCarta)
    }
    
    func aplicarNuevoTema(_ tema: EnumTemas) {
        temaActual = tema
    }
    
}
