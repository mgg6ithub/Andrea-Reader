

import SwiftUI

class MenuEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let uds = UserDefaults.standard
    
    //MARK: - ICONOS DEL MENU
    
    //Mostrar u ocultar iconos del menu
    @Published var menuIzquierdaFlechaLateral: Bool = true
    @Published var menuIzquierdaSideMenuIcono: Bool = true

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
    
    
    // --- AJUSTES GLOBALES DE LA APLICACION ---
    
    @Published var ajustesGlobalesPresionado: Bool = false //Para desplegar y cerrar el menu global de ajustes
    
    //Variables resizable del menu de indices con puntos lateral
    @Published var anchoIndicePuntos: CGFloat = 77.5
    @Published var anchoTexto: CGFloat = 72.5

    
    @Published var modoVistaColeccion: EnumModoVista = .cuadricula
    
    //MARK: --- MENU DERECHA ---
    
    //Funcionalidad de la vista de los ajustes globales
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
        case "AjustesMenu": return "Menu"
        case "AjustesHistorial": return "Historial"
        case "AjustesLibreria": return "Libreria"
        case "AjustesVisualizacion": return "Visual"
        default: return ""
        }
    }
    
    init() {}
    
    public func seleccionarElemento(url: URL) {
        withAnimation(.easeInOut(duration: 0.05)) { self.elementosSeleccionados.insert(url) }
        Task {
            if await self.elementosSeleccionados.count == PilaColecciones.pilaColecciones.getColeccionActual().elementos.count {
                self.todosSeleccionados = true
            }
        }
    }
    
    public func deseleccionarElemento(url: URL) {
        withAnimation(.easeInOut(duration: 0.05)) { self.elementosSeleccionados.remove(url) }
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
        withAnimation { self.elementosSeleccionados.removeAll() }
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
