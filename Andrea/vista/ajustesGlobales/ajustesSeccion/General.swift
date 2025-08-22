
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
    private var esOscuro: Bool { tema == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Ajustes generales") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: tema.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Ajusta las opciones generales de la aplicación: idioma, barra de estado y otras opciones básicas para adaptar la app a tu dispositivo.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            //MARK: --- TAMAÑO ---
            AjustesBarraEstado(isSection: isSection)
            
            Button(action: {
                PersistenciaDatos().reiniciarPersistencia()
            }) {
                Text("REINICIAR PERSISTENCIA")
                    .foregroundColor(.red)
            }
            .padding(15) // margen interno
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red.opacity(0.2))
            )
            .shadow(
                color: esOscuro ? .black.opacity(0.6) : .black.opacity(0.225),
                radius: ap.shadows ? 10 : 0, x: 0, y: ap.shadows ? 5 : 0
            )
            .padding(.bottom, 15)
            .padding(.top, 15)
            
//            CirculoActivoVista(isSection: isSection, nombre: "Selecciona un tema", titleSize: const.descripcionAjustes, color: ap.temaActual.secondaryText)
            
//            VStack(spacing: 0) {
//                
//                TogglePersonalizado(titulo: "Icono izquierdo", descripcion: "Activa o desactiva el icono.", opcionBinding: $ap.shadows, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: true)
//                        
//                }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
        }
    }
}
