import SwiftUI

struct AjustesLibreria: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Libreria") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: ap.temaActual.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Ajusta los libros y el comportamiento de la libreria.")
                .capaDescripcion(s: const.descripcionAjustes, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Selecciona un tema", titleSize: const.descripcionAjustes, color: ap.temaActual.secondaryText)
            
            VStack(spacing: 0) {
                
                TogglePersonalizado(titulo: "Icono izquierdo", descripcion: "Activa o desactiva el icono.", opcionBinding: $ap.shadows, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: true)
                        
                }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
        }
    }
}
