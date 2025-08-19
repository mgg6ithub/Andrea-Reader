
import SwiftUI

class MenuEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let pd = PersistenciaDatos()
    
    // --- BARRA DE ESTADO ---
    @Published var modoBarraEstado: EnumBarraEstado { didSet { pd.guardarAjusteGeneral(valor: modoBarraEstado, key: cpag.barraEstado) } }
    @Published var statusBarTopInsetBaseline: CGFloat
    
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
    
    //MARK: - ICONOS DEL MENU

    //MODIFICAR ICONOS
    
    //MENU IZQUIERDA
    @Published var iconoMenuLateral: Bool { didSet { pd.guardarAjusteGeneral(valor: iconoMenuLateral, key: cpag.menuLateral) } }
    @Published var iconoFlechaAtras: Bool { didSet { pd.guardarAjusteGeneral(valor: iconoFlechaAtras, key: cpag.flechaAtras) } }
    @Published var iconoSeleccionMultiple: Bool { didSet { pd.guardarAjusteGeneral(valor: iconoSeleccionMultiple, key: cpag.seleccionMultiple)} }
    @Published var iconoNotificaciones: Bool { didSet { pd.guardarAjusteGeneral(valor: iconoNotificaciones, key: cpag.notificaciones)} }
    
    //COLORES DE LOS ICONOS
    @Published var dobleColor: Bool { didSet { pd.guardarAjusteGeneral(valor: dobleColor, key: cpag.iconosDobleColor) } }
    @Published var colorGris: Bool { didSet { pd.guardarAjusteGeneral(valor: colorGris, key: cpag.iconosColorGris) } }
    @Published var colorAutomatico: Bool { didSet { pd.guardarAjusteGeneral(valor: colorAutomatico, key: cpag.iconosColorAuto) } }

    //TAMAÑO ICONOS
    @Published var iconSize: Double { didSet { pd.guardarAjusteGeneral(valor: iconSize, key: cpag.iconSize) } }
    @Published var fuente: EnumFuenteIcono { didSet { pd.guardarAjusteGeneral(valor: fuente, key: cpag.iconoFuente) } }
    
    //FONDO DEL MENU
    @Published var fondoMenu: Bool { didSet { pd.guardarAjusteGeneral(valor: fondoMenu, key: cpag.fondoMenu) } }
    @Published var colorFondoMenu: EnumFondoMenu { didSet { pd.guardarAjusteGeneral(valor: colorFondoMenu, key: cpag.colorFondoMenu) } }
    

    // --- SELECCION MULTIPLE ---
    @Published var seleccionMultiplePresionada: Bool = false {
        didSet {
            if seleccionMultiplePresionada == false {
                deseleccionarTodos()
            }
        }
    }
    @Published var elementosSeleccionados: Set<URL> = []
    @Published var todosSeleccionados: Bool = false
    
    // --- AJUSTES DE CADA COLECCION ---
    @Published var modoVistaColeccion: EnumModoVista = .cuadricula
    
    // --- AJUSTES GLOBALES ---
    @Published var ajustesGlobalesPresionado: Bool = false
    
    let sections = [
        "General", "TemaPrincipal", "ColorPrincipal", "SistemaArchivos", "Rendimiento",
        "AjustesMenu", "AjustesHistorial", "AjustesLibreria"
    ]
    
    func sectionTitle(_ id: String) -> String {
        switch id {
        case "General": return "General"
        case "TemaPrincipal": return "Temas"
        case "ColorPrincipal": return "Colores"
        case "SistemaArchivos": return "Sistema de archivos"
        case "Rendimiento": return "Rendimiento"
        case "AjustesMenu": return "Menu"
        case "AjustesHistorial": return "Historial"
        case "AjustesLibreria": return "Libreria"
        default: return ""
        }
    }
    
    init() {
        
        //Persistencia
        let p = AjustesGeneralesPredeterminados()
    
        self.modoBarraEstado = pd.obtenerAjusteGeneralEnum(key: cpag.barraEstado, default: p.barraEstado)
        self.statusBarTopInsetBaseline = UIApplication.shared.keyWindowSafeAreaTop
        
        //modificaicon de iconos
        self.iconoMenuLateral = pd.obtenerAjusteGeneral(key: cpag.menuLateral, default: p.menuLateral)
        self.iconoFlechaAtras = pd.obtenerAjusteGeneral(key: cpag.flechaAtras , default: p.flechaAtras)
        self.iconoSeleccionMultiple = pd.obtenerAjusteGeneral(key: cpag.seleccionMultiple , default: p.seleccionMultiple)
        self.iconoNotificaciones = pd.obtenerAjusteGeneral(key: cpag.notificaciones , default: p.notificaciones)
        
        //Colores iconos
        self.dobleColor = pd.obtenerAjusteGeneral(key: cpag.iconosDobleColor, default: p.iconosDobleColor)
        self.colorGris = pd.obtenerAjusteGeneral(key: cpag.iconosColorGris, default: p.iconosColorGris)
        self.colorAutomatico = pd.obtenerAjusteGeneral(key: cpag.iconosColorAuto, default: p.iconosColorAuto)
        
        //tamaños iconos
        self.iconSize = pd.obtenerAjusteGeneral(key: cpag.iconSize, default: p.iconSize)
        self.fuente = pd.obtenerAjusteGeneralEnum(key: cpag.iconoFuente, default: p.iconoFuente)
        
        //fondo
        self.fondoMenu = pd.obtenerAjusteGeneral(key: cpag.fondoMenu, default: p.fondoMenu)
        self.colorFondoMenu = pd.obtenerAjusteGeneralEnum(key: cpag.colorFondoMenu, default: p.colorFondoMenu)
    }
    
    //MARK: --- LOGICA PARA LA SELECCION MULTIPLE --- 
    
    public func seleccionarElemento(url: URL) {
        let _ = withAnimation(.easeInOut(duration: 0.05)) { self.elementosSeleccionados.insert(url) }
        Task {
            if await self.elementosSeleccionados.count == PilaColecciones.pilaColecciones.getColeccionActual().elementos.count {
                self.todosSeleccionados = true
            }
        }
    }
    
    public func deseleccionarElemento(url: URL) {
        let _ = withAnimation(.easeInOut(duration: 0.05)) { self.elementosSeleccionados.remove(url) }
        Task {
            if await self.elementosSeleccionados.count != PilaColecciones.pilaColecciones.getColeccionActual().elementos.count {
                self.todosSeleccionados = false
            }
        }
    }
    
    public func seleccionarTodos() {
        Task {
            let elementos = await PilaColecciones.pilaColecciones.getColeccionActual().elementos
            await MainActor.run {
                for elemento in elementos {
                    self.seleccionarElemento(url: elemento.url)
                }
            }
        }
        self.todosSeleccionados = true
    }
    
    public func deseleccionarTodos() {
        let _ = withAnimation { self.elementosSeleccionados.removeAll() }
        self.todosSeleccionados = false
    }
    
    //--- recorrer todos los elementos seleccionados y aplicar la accion por cada elemento ---
    public func aplicarAccionPorElemento(_ accion: @escaping (ElementoSistemaArchivos) async -> Void) {

        for url in self.elementosSeleccionados {
            Task {
                let coleccionActual = await PilaColecciones.pilaColecciones.getColeccionActual()
                guard let elemento = await coleccionActual.elementos.first(where: { $0.url == url }) else { return }

                await accion(elemento)
            }
        }
        
        self.deseleccionarTodos()
        
    }
    
}

extension UIApplication {
    var keyWindowSafeAreaTop: CGFloat {
        if #available(iOS 15.0, *) {
            return (self.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .flatMap { $0.windows }
                        .first { $0.isKeyWindow })?.safeAreaInsets.top ?? 20
        } else if #available(iOS 13.0, *) {
            return (self.windows.first { $0.isKeyWindow })?.safeAreaInsets.top ?? 20
        } else {
            return self.keyWindow?.safeAreaInsets.top ?? 20
        }
    }
}
