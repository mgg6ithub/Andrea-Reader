
import SwiftUI

class AppEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let uds = UserDefaults.standard
    
    @Published var archivoEnLectura: Archivo? = nil {
        didSet {
            // Actualiza ultimoArchivoLeido cuando archivoEnLectura cambie
            if archivoEnLectura != nil {
                ultimoArchivoLeido = archivoEnLectura
                print("Actualizando el ultimo archivo leido a: ", ultimoArchivoLeido?.nombre)
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
    @Published var temaActual: EnumTemas { didSet { uds.setEnum(temaActual, forKey: cpag.temaActual ) } }
    @Published var sistemaArchivos: EnumTipoSistemaArchivos { didSet { uds.setEnum(sistemaArchivos, forKey: cpag.sistemaArchivos) } }
    
    // --- RENDIMIENTO
    @Published var shadows: Bool = true
    @Published var animaciones: Bool = true
    
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
        self.temaActual = uds.getEnum(forKey: cpag.temaActual, default: .light)
        self.sistemaArchivos = uds.getEnum(forKey: cpag.sistemaArchivos, default: .tradicional)
        
    }
    
    func aplicarNuevoTema(_ tema: EnumTemas) {
        temaActual = tema
    }
    
}
