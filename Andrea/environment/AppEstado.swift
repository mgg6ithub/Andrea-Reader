
import SwiftUI

class AppEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let uds = UserDefaults.standard
    
    //MARK: --- marcas de cargado dinamico ---
    @Published var menuCargado = false
    @Published var historialCargado = false
    
    @Published var isFirstTimeLaunch: Bool = false
    @Published var resolucionLogica: EnumResolucionesLogicas
    
    //Persistencia
    @Published var temaActual: EnumTemas { didSet { uds.setEnum(temaActual, forKey: cpag.temaActual ) } }
    @Published var sistemaArchivos: EnumTipoSistemaArchivos { didSet { uds.setEnum(sistemaArchivos, forKey: cpag.sistemaArchivos) } }
    
    @Published var shadows: Bool = true
    @Published var test: Bool = false
    @Published var animaciones: Bool = true
    
    @Published var screenWidth: CGFloat
    @Published var screenHeigth: CGFloat
    
    @Published var constantes: Constantes
    
    @Published var isScrolling: Bool = false
    
    //MARK: --- mas informacion ---
    @Published var masInformacion: Bool = false
    @Published var elementoSeleccionado: (any ElementoSistemaArchivosProtocolo)? = nil
    @Published var pantallaCompleta: Bool = false
    
    //MARK: --- vista previa seleccionada ---
    @Published var vistaPrevia: Bool = false
    
    init(screenWidth: CGFloat? = nil, screenHeight: CGFloat? = nil) {
        self.isFirstTimeLaunch = true
        
        let actualScreenWidth = screenWidth ?? UIScreen.main.bounds.width
        let actualScreenHeight = screenHeight ?? UIScreen.main.bounds.height
                
        var scaleFactor = max(0.49, min(actualScreenWidth / 820, actualScreenHeight / 1180))
//        var scaleFactor = min(actualScreenWidth / 820, actualScreenHeight / 1180)
        var resLog: EnumResolucionesLogicas = .small
        
        switch scaleFactor {
            case ..<0.5: // Dispositivos pequeños iPhone 8, 7, 6 ...
                resLog = .small
                scaleFactor *= 1.4
            case 0.5...1.0:
                resLog = .medium
                break // No hacer nada
            case let x where x > 1.0: // Valores mayores a 1.0
                resLog = .big
//            scaleFactor *= 1.1
            default:
                resLog = .medium
                break
        }
        
        self.screenWidth = actualScreenWidth
        self.screenHeigth = actualScreenHeight
        
        print(scaleFactor)
        print(resLog)
        print()
        
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
