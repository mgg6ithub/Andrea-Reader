
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

struct AjustesBarraEstado: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    var const: Constantes { ap.constantes }
    private let cpd = ConstantesPorDefecto()
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * const.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * const.scaleFactor} // 20
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    
    var isSection: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            CirculoActivoVista(isSection: isSection, nombre: "Barra de estado", titleSize: const.subTitleSize, color: ap.colorActual)
            
            HStack(spacing: paddingHorizontal) {
                BotonBE(titulo: "Activar", icono: "eye.fill", coloresIcono: [.black], opcionSeleccionada: .on, opcionActual: $me.modoBarraEstado)
                Spacer()
                BotonBE(titulo: "Desactivar", icono: "eye.slash.fill", coloresIcono: [.black], opcionSeleccionada: .off, opcionActual: $me.modoBarraEstado)
                Spacer()
                BotonBE(titulo: "Automático", icono: "wand.and.stars", coloresIcono: [.blue], opcionSeleccionada: .auto, opcionActual: $me.modoBarraEstado)
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            Text("Franja superior del dispositivo que muestra la hora, señal, Wi-Fi y batería. Muéstrala, ocúltala o deja que el sistema elija.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: 10, pW: 0)
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

enum EnumBarraEstado: String {
    case on, off, auto
}


struct BotonBE<T: Equatable>: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var titulo: String
    var icono: String
    var coloresIcono: [Color]
    var opcionSeleccionada: T
    @Binding var opcionActual: T
    var fuente: Font.Weight? = nil
    
    var isSelected: Bool { return opcionActual == opcionSeleccionada }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.15)) { opcionActual = opcionSeleccionada }
        }) {
            VStack(alignment: .center, spacing: 6) {
                
                Text(titulo)
                    .font(.footnote)
                    .foregroundColor(ap.temaResuelto.colorContrario)
                
                Image(systemName: icono)
                    .font(.system(size: 22, weight: fuente ?? .medium))
//                    .foregroundStyle(LinearGradient(colors: coloresIcono, startPoint: .top, endPoint: .bottom))
                    .frame(width: 30, height: 30)
                    .foregroundColor(ap.temaResuelto.secondaryText)
            }
            .if(!isSelected) { v in
                v.opacity(0.4)
            }
        }
        .buttonStyle(.plain)
    }
}
