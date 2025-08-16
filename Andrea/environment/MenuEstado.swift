
import SwiftUI

class MenuEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let uds = UserDefaults.standard
    
    //MARK: - ICONOS DEL MENU
    
    @Published var iconosSize: CGFloat = ConstantesPorDefecto().iconSize
    
    //MENU IZQUIERDA
    
    @Published var menuIzquierdaFlechaLateral: Bool = true
    @Published var menuIzquierdaSideMenuIcono: Bool = true

    //MENU CENTRO
    
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
    
    init() {}
    
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
