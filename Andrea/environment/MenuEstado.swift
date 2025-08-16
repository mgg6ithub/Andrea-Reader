
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
    
    @Published var iconosSize: CGFloat = ConstantesPorDefecto().iconSize
    
    //COLORES DE LOS ICONOS
    @Published var colorGris: Bool = true
    @Published var colorAutomatico: Bool = false
    @Published var dobleColor: Bool = false
    
    //TAMAÑO ICONOS
    @Published var iconSize: Double { didSet { pd.guardarAjusteGeneral(valor: iconSize, key: cpag.iconSize) } }
    @Published var fuente: IconFontWeight = .thin
    
    //MENU IZQUIERDA
    
    @Published var iconoFlechaAtras: Bool = false
    @Published var iconoMenuLateral: Bool = false

    //MENU CENTRO
    @Published var iconoSeleccionMultiple: Bool = true
    
    //MENU DERECHA
    @Published var iconoNoticicaciones: Bool = true
    
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
        "TemaPrincipal", "ColorPrincipal", "SistemaArchivos", "Rendimiento",
        "AjustesMenu", "AjustesHistorial", "AjustesLibreria", "AjustesVisualizacion"
    ]
    
    func sectionTitle(_ id: String) -> String {
        switch id {
        case "TemaPrincipal": return "Temas"
        case "ColorPrincipal": return "Colores"
        case "SistemaArchivos": return "Sistema de archivos"
        case "Rendimiento": return "Rendimiento"
//        case "AjustesBarraEstado": return "AjustesBarraEstado"
        case "AjustesMenu": return "Menu"
        case "AjustesHistorial": return "Historial"
        case "AjustesLibreria": return "Libreria"
        case "AjustesVisualizacion": return "Visual"
        default: return ""
        }
    }
    
    init() {
        
        //Persistencia
        let p = AjustesGeneralesPredeterminados()
    
        self.modoBarraEstado = pd.obtenerAjusteGeneralEnum(key: cpag.barraEstado, default: p.barraEstado)
        self.statusBarTopInsetBaseline = UIApplication.shared.keyWindowSafeAreaTop
        
        self.iconSize = pd.obtenerAjusteGeneral(key: cpag.iconSize, default: p.iconSize)
        
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
