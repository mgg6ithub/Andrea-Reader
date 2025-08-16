
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

struct AjustesMenu: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    private let cpd = ConstantesPorDefecto()
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("Menu") //TITULO
                .capaTituloPrincipal(s: const.titleSize, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("El menu son los iconos de arriba del todo y puedes personalizarlos como mas te guste.")
                .capaDescripcion(s: const.titleSize, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            AjustesBarraEstado()
            
            CirculoActivoVista(isSection: isSection, nombre: "Selecciona un tema", titleSize: const.titleSize, color: ap.temaActual.secondaryText)
            
            VStack(spacing: 0) {
                        
                TogglePersonalizado(titulo: "Icono izquierdo", descripcion: "Activa o desactiva el icono.", opcionBinding: $ap.shadows, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: false)
                
//                Text("Las sombras pueden afectar al rendimiento del programa, ralentizando la experiencia del usuario. El clásico dilema entre estilo y rendimiento.")
//                    .capaDescripcion(s: const.titleSize * 0.8, c: ap.temaActual.secondaryText, pH: 0, pW: 0)
                        
                }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
        }
    }
}
