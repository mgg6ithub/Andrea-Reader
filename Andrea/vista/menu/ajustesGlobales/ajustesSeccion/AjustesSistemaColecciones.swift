

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
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            Text("Sistema de archivos") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Los temas son combinaciones de colores que se aplican globalmente a toda la interfaz. Los temas claro y oscuro son los mas usados.")
                .capaDescripcion(s: const.descripcionAjustes, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
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
                    titulo: "Arbol",
                    icono: "tree.fill",
                    coloresIcono: [Color.black],
                    opcionSeleccionada: .arbol,
                    opcionActual: $ap.sistemaArchivos
                )
                
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
        }
//        .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
    }
    
}
