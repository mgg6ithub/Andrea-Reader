

import SwiftUI


struct MenuDerecha: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var hne: NotificacionesEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @ObservedObject var coleccionActualVM: ModeloColeccion
    var c2: Color
    var iconSize: CGFloat
    var iconFont: EnumFuenteIcono
    
    private var const: Constantes { ap.constantes }
    private var c1: Color {
        if me.dobleColor {
            return ap.colorActual
        } else if me.colorGris {
            return .gray
        } else {
            return ap.temaResuelto.menuIconos
        }
    }
    
    var body: some View {
        HStack {
            if me.iconoNotificaciones {
                ZStack {
                    PopOutCollectionsView() { isExpandable in
                        Image("notificaciones")
                            .font(.system(size: iconSize * 1.03))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(c1, c2)
                            .contentTransition(.symbolEffect(.replace))
                            .fontWeight(iconFont.weight)
                            .padding(.trailing, 2)
                            .symbolEffect(.bounce, value: hne.nuevaNotificacion)
                    } content: { isExpandable, cerrarMenu in
                        MenuHistorial()
                    }
                }
                .padding(0)
            }
            
            Button(action: {
                withAnimation { self.me.ajustesGlobalesPresionado.toggle() }
            }) {
                Image("custom-gear")
                    .capaIconos(iconSize: iconSize, c1: c1, c2: c2, fontW: iconFont.weight, ajuste: 1.05)
                    .offset(y: 2)
            }
            .sheet(isPresented: $me.ajustesGlobalesPresionado) {
                AjustesGlobales()
            }
            
        }
        .animacionDesvanecer(c1)
        .padding(0)
    }
    
}
