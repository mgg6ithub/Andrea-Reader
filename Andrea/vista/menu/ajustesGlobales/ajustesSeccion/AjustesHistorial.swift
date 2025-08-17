import SwiftUI

struct AjustesHistorial: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Historial de colecciones") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Un historial rapido para navegar y ubicarte entre las colecciones. Quitalo o modificalo a tu gusto.")
                .capaDescripcion(s: const.descripcionAjustes, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Selecciona un tema", titleSize: const.descripcionAjustes, color: ap.temaActual.secondaryText)
            
            VStack(spacing: 0) {
                        
                TogglePersonalizado(titulo: "Historial de colecciones", descripcion: "Activa o desactiva el historial.", opcionBinding: $ap.historialColecciones, opcionTrue: "Deshabilitar historial", opcionFalse: "Habilitar historial", isInsideToggle: true, isDivider: ap.historialColecciones ? true : false)
                
                if ap.historialColecciones {
                    VStack( alignment: .trailing, spacing: 0) {
                        TogglePersonalizado(
                            titulo: "Básico",
                            opcionBinding: Binding(
                                get: { ap.historialEstilo == .basico },
                                set: { isOn in
                                    if isOn { ap.historialEstilo = .basico }
                                }
                            ),
                            opcionTrue: "Deshabilitar estilo",
                            opcionFalse: "Habilitar estilo",
                            isInsideToggle: true,
                            isDivider: false
                        ).fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                        
                        TogglePersonalizado(
                            titulo: "Degradado",
                            opcionBinding: Binding(
                                get: { ap.historialEstilo == .degradado },
                                set: { isOn in
                                    if isOn { ap.historialEstilo = .degradado }
                                }
                            ),
                            opcionTrue: "Deshabilitar estilo",
                            opcionFalse: "Habilitar estilo",
                            isInsideToggle: true,
                            isDivider: false
                        ).fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                        
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Tamaño")
                            .font(.headline)
                            .foregroundColor(ap.temaActual.colorContrario)
                        Spacer()
                        Text("\(Int(ap.historialSize)) pt")
                            .font(.subheadline)
                            .foregroundColor(ap.temaActual.secondaryText)
                    }

                    IconSizeSlider(
                        value: $ap.historialSize,
                        min: 16,
                        max: 26,
                        recommended: AjustesGeneralesPredeterminados().historialSize,
                        trackColor: ap.temaActual.colorContrario,     // base
                        fillColor: .blue,                             // progreso
                        markerColor: ap.temaActual.colorContrario,    // muesca
                        textColor: ap.temaActual.secondaryText        // “24 pt”
                    )
                    
                    Text("Escoge el tamaño que quieras para el historial de colecciones.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
        }
    }
}
