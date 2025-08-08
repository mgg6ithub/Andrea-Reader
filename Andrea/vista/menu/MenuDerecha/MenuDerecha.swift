

import SwiftUI


struct MenuDerecha: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var hne: NotificacionesEstado
    
    var body: some View {
        
        HStack {
            Spacer()
            ZStack {
                Button(action: {
                    
                }) {
                    PopOutCollectionsView() { isExpandable in
                        Image("menu-historial")
                            .font(.system(size: appEstado.constantes.iconSize * 1.03))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(appEstado.constantes.iconColor.gradient)
                            .contentTransition(.symbolEffect(.replace))
                            .fontWeight(appEstado.constantes.iconWeight)
                            .padding(.trailing, 2.5)
                            .symbolEffect(.bounce, value: hne.nuevaNotificacion)
                    } content: { isExpandable, cerrarMenu in
                        MenuHistorial()
                    }
                }
            }
            
        }
        .frame(maxWidth: 70)
        
    }
    
}
