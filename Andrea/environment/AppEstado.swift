
import SwiftUI

@MainActor
class AppEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let pd = PersistenciaDatos()
    
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
    
    // --- AJUSTES TEMAS ---
    @Published var temaActual: EnumTemas { didSet { pd.guardarAjusteGeneral(valor: temaActual, key: cpag.temaActual) } }
    @Published var sistemaArchivos: EnumTipoSistemaArchivos { didSet { pd.guardarAjusteGeneral(valor: sistemaArchivos, key: cpag.sistemaArchivos) } }
    
    // --- AJUSTES DE COLORES ---
    @Published var colorPersonalizadoActual: Color = .gray
    @Published var colorPersonalizado: Bool = false
    @Published var colorNeutro: Bool = false
    @Published var aplicarColorDirectorio: Bool = true

    var colorActual: Color {
        if aplicarColorDirectorio {
            return PilaColecciones.pilaColecciones.getColeccionActual().color
        } else if colorNeutro {
            return .gray
        } else {
            return colorPersonalizadoActual
        }
    }
    
    // --- RENDIMIENTO
    @Published var shadows: Bool = true
    @Published var animaciones: Bool = true
    
    // --- BARRA DE ESTADO ---
    @Published var modoBarraEstado: ModoBarraEstado = .on
    @Published var statusBarTopInsetBaseline: CGFloat = 0
    
    var barraEstado: Bool {
        switch modoBarraEstado {
        case .on:
            return false
        case .off:
            return true
        default:
            return true
        }
    }
    
    // --- MENU ---
    
    // --- HISTORIAL DE COLECCIONES ---
    
    // --- LIBRERIA ---
    
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
        
        self.screenWidth = actualScreenWidth
        self.screenHeigth = actualScreenHeight
        
        self.constantes = Constantes(scaleFactor: scaleFactor, resLog: resLog)
        self.resolucionLogica = resLog
        
        //Persistencia
        self.temaActual = pd.obtenerAjusteGeneralEnum(key: cpag.temaActual, default: .light)
        self.sistemaArchivos = pd.obtenerAjusteGeneralEnum(key: cpag.sistemaArchivos, default: .tradicional)

        // Ejemplo si guardas un color global:
        // self.colorPersonalizadoActual = pd.obtenerAjusteGeneralColor(key: "colorPersonalizadoActual", default: .gray)

        // Ejemplo si guardas un bool global:
        // self.animaciones = pd.obtenerAjusteGeneral(key: "animaciones", default: true)
        
    }
    
    func aplicarNuevoTema(_ tema: EnumTemas) {
        temaActual = tema
    }
    
}
