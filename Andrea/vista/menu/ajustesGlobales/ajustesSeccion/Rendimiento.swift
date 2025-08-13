
import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667))
//        .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852))
//        .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
//        .environmentObject(AppEstado(screenWidth: 834, screenHeight: 1194)
//        .environmentObject(AppEstado(screenWidth: 1024, screenHeight: 1366))
        .environmentObject(MenuEstado())
}

struct Rendimiento: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    // --- PARAMETROS ---
    var isSection: Bool
    
    // --- VARIABLES CALCULADAS ---
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            Text("Rendimiento")
                .capaTituloPrincipal(s: const.titleSize, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Ajustes para mejorar el rendimiento del programa sacrificando el aspecto visual.")
                .capaDescripcion(s: const.titleSize, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Modifica las sombras", titleSize: const.titleSize, color: ap.temaActual.secondaryText)
            
            VStack(spacing: 0) {
                        
                TogglePersonalizado(titulo: "Sombras", descripcion: "Activa o desactiva las sombras de la interfaz.", opcionBinding: $ap.shadows, opcionTrue: "Deshabilitar sombras", opcionFalse: "Habilitar sombras", isInsideToggle: true, isDivider: true)
                
                Text("Las sombras pueden afectar al rendimiento del programa, ralentizando la experiencia del usuario. El clásico dilema entre estilo y rendimiento.")
                    .capaDescripcion(s: const.titleSize * 0.8, c: ap.temaActual.secondaryText, pH: 0, pW: 0)
                        
                }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
        }
        .padding(.horizontal, ap.resolucionLogica == .small ? 0 : const.padding35 * 2)
        
    }
}

