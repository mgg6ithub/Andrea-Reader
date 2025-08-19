

import SwiftUI

#Preview {
    AjustesGlobales()
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
                RectangleFormView<EnumTipoSistemaArchivos>(
                    titulo: "Tradicional",
                    icono: "folder.fill",
                    coloresIcono: [Color.black],
                    opcionSeleccionada: .tradicional,
                    opcionActual: $ap.sistemaArchivos
                )
                
                RectangleFormView<EnumTipoSistemaArchivos>(
                    titulo: "Acceso rápido",
                    icono: "list.bullet.rectangle",
                    coloresIcono: [Color.black],
                    opcionSeleccionada: .arbol,
                    opcionActual: $ap.sistemaArchivos
                )
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            HStack(spacing: 6) {
                Image(systemName: "info.bubble")
                    .foregroundColor(tema.colorContrario)
                    .font(.system(size: const.iconSize * 0.5)) // ajusta al tamaño que uses en la UI
                
                Text(esTradicional ? "Tradicional" : "Acceso rápido")
                    .capaDescripcion(s: const.descripcionAjustes, c: tema.colorContrario, pH: 0, pW: 0, b: true)
                    .underline(isSection, color: ap.colorActual)
            }
            .padding(.bottom, 6)
            
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
