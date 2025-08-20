

import SwiftUI

#Preview {
    AjustesSistemaColecciones(isSection: true)
//        .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667))
//        .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852))
        .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
//        .environmentObject(AppEstado(screenWidth: 834, screenHeight: 1194)
//        .environmentObject(AppEstado(screenWidth: 1024, screenHeight: 1366))
        .environmentObject(MenuEstado())
}

struct AjustesSistemaColecciones: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    private var esTradicional: Bool { ap.sistemaArchivos == .tradicional }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("Sistema de archivos") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: tema.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Elige cómo quieres navegar entre tus colecciones y archivos.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Escoge el sistema de archivos", titleSize: const.descripcionAjustes, color: ap.colorActual)
                
            HStack(spacing: 0) {
//                RectangleFormView<EnumTipoSistemaArchivos>(
//                    titulo: "Tradicional",
//                    icono: "folder.fill",
//                    coloresIcono: [Color.black],
//                    opcionSeleccionada: .tradicional,
//                    opcionActual: $ap.sistemaArchivos
//                )
//                
//                RectangleFormView<EnumTipoSistemaArchivos>(
//                    titulo: "Acceso rápido",
//                    icono: "list.bullet.rectangle",
//                    coloresIcono: [Color.black],
//                    opcionSeleccionada: .arbol,
//                    opcionActual: $ap.sistemaArchivos
//                )
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: const.cAnchoRect, height: const.cAlturaRect)
                        .foregroundColor(ap.sistemaArchivos == .tradicional ? Color.gray.opacity(1.0) : Color.gray.opacity(0.3))
                    //                        .shadow(color: esOscuro ? .black.opacity(0.225) : .black.opacity(0.225),
                    //                                radius: ap.shadows ? 5 : 0,
                    //                                x: 0,
                    //                                y: ap.shadows ? 2 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    ap.sistemaArchivos == .tradicional
                                    ? (tema == .dark ? Color.white : Color.black)
                                    : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                    
                    ZStack {
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: (ap.constantes.iconSize + 20) * 1.15))
                            .scaleEffect(x: 1.1, y: 1.3, anchor: .center)
                            .foregroundColor(ap.sistemaArchivos == .tradicional ? Color.gray.opacity(0.8) : Color.clear)
                            .zIndex(0)
                        
                        
                    }
                }
                
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            TituloInformacion(titulo: esTradicional ? "Tradicional" : "Acceso rápido", isSection: isSection)
                .animation(.smooth, value: ap.sistemaArchivos)
            
            Group {
                if esTradicional {
                    Text("El sistema de carpetas de toda la vida: organiza tus colecciones dentro de carpetas y subcarpetas. ")
                    + Text("Recomendado para bibliotecas pequeñas.").bold()
                } else {
                    Text("Todas las colecciones aparecen en un menú lateral, sin jerarquías. Al entrar en una colección solo verás sus archivos. ")
                    + Text("Recomendado para bibliotecas grandes.").bold()
                }
            }
            .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: 0, pW: 0)
            .animation(.smooth, value: ap.sistemaArchivos)
            
        }
    }
    
}
