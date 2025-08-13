
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

struct AjustesBarraEstado: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var isSection: Bool
    var const: Constantes { ap.constantes }
    private let cpd = ConstantesPorDefecto()
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * const.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * const.scaleFactor} // 20
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Barra de estado") //TITULO
                .capaTituloPrincipal(s: const.titleSize, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Franja superior del dispositivo que muestra la hora, señal, Wi-Fi y batería. Muéstrala, ocúltala o deja que el sistema elija.")
                .capaDescripcion(s: const.titleSize, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Modifica la barra de estado", titleSize: const.titleSize, color: ap.temaActual.secondaryText)
            
            HStack(spacing: 0) {
                RectangleFormView<ModoBarraEstado>(
                    titulo: "Activar",
                    icono: "eye.fill",
                    coloresIcono: [ap.temaActual.colorContrario],
                    opcionSeleccionada: .on,
                    opcionActual: $ap.modoBarraEstado
                )
                RectangleFormView<ModoBarraEstado>(
                    titulo: "Desactivar",
                    icono: "eye.slash.fill",
                    coloresIcono: [ap.temaActual.colorContrario],
                    opcionSeleccionada: .off,
                    opcionActual: $ap.modoBarraEstado
                )
                RectangleFormView<ModoBarraEstado>(
                    titulo: "Automático",
                    icono: "wand.and.stars",
                    coloresIcono: [.blue.opacity(0.5)],
                    opcionSeleccionada: .auto,
                    opcionActual: $ap.modoBarraEstado
                )
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
        }
    }
}

enum ModoBarraEstado: String {
    case on, off, auto
}
