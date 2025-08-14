

import SwiftUI


struct MenuDerecha: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var hne: NotificacionesEstado
    @EnvironmentObject var pc: PilaColecciones
    
    private var const: Constantes { appEstado.constantes }
    private var iconColor: Color { appEstado.temaActual.menuIconos }
    private var iconW: Font.Weight { const.iconWeight }
    
    var body: some View {
        
        HStack {
            ZStack {
                PopOutCollectionsView() { isExpandable in
                    Image("menu-historial")
                        .font(.system(size: const.iconSize * 1.03))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(appEstado.colorActual, iconColor)
                        .contentTransition(.symbolEffect(.replace))
                        .fontWeight(iconW)
                        .padding(.trailing, 2.5)
                        .symbolEffect(.bounce, value: hne.nuevaNotificacion)
                } content: { isExpandable, cerrarMenu in
                    MenuHistorial()
                }
            }
            .padding(0)
        }
        .padding(0)
    }
    
}
