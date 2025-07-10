//
//  MenuState.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

class MenuEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    private let uds = UserDefaults.standard
    
    //MARK: - ICONOS DEL MENU
    
    //Mostrar u ocultar iconos del menu
    @Published var menuIzquierdaFlechaLateral: Bool = true
    @Published var menuIzquierdaSideMenuIcono: Bool = true

    
    //MARK: - AJUSTES GLOBALES
    
    @Published var isGlobalSettingsPressed: Bool = false //Para desplegar y cerrar el menu global de ajustes
    
    //Variables resizable del menu de indices con puntos lateral
    @Published var anchoIndicePuntos: CGFloat = 60
    @Published var separacionBarra: CGFloat = 69
    @Published var alturaBarra: CGFloat = 72.5
    @Published var anchoTexto: CGFloat = 65
    
    //Variables secciones de cada ajustes
    @Published var altoRectanguloFondo: CGFloat = 230 //Alto del rectangulo de fondo para los ajustes general
    @Published var anchoRectanguloSmall: CGFloat = 100 //Ancho del rectangulo peke que contiene una opcion (por ejemplo el de un tema)
    @Published var altoRectanguloSmall: CGFloat = 140 //Ancho del rectangulo peke que contiene una opcion (por ejemñplo el de un tema)
    
    @Published var modoVistaColeccion: EnumModoVista = .cuadricula
    
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
    
}
