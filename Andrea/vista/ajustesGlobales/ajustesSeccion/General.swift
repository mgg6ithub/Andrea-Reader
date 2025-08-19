
import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

struct General: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let isSection: Bool
    
    private var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var tema: EnumTemas { ap.temaResuelto }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Ajustes generales") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: tema.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Ajusta las preferencias generales de la aplicación: idioma, barra de estado y otras opciones básicas para adaptar la app a tu dispositivo.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            //MARK: --- TAMAÑO ---
            AjustesBarraEstado(isSection: isSection)
            
//            CirculoActivoVista(isSection: isSection, nombre: "Selecciona un tema", titleSize: const.descripcionAjustes, color: ap.temaActual.secondaryText)
            
//            VStack(spacing: 0) {
//                
//                TogglePersonalizado(titulo: "Icono izquierdo", descripcion: "Activa o desactiva el icono.", opcionBinding: $ap.shadows, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: true)
//                        
//                }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
        }
    }
}
