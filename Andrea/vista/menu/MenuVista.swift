import SwiftUI

struct MenuVista: View {
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    @State private var menuCentroWidth: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
//                    let desactivarFondo =
//                        (ap.sistemaArchivos == .tradicional && !me.iconoMenuLateral && !me.iconoFlechaAtras) ||
//                        (ap.sistemaArchivos == .tradicional && !me.iconoMenuLateral && pc.getColeccionActual().coleccion.nombre == "HOME")
                    
                    MenuIzquierda()
                        .fondoBoton1(pH: 3, pV: 3, isActive: false, color: .gray.opacity(0.6))
                        .padding(0)
                    Spacer()
                    MenuDerecha()
                        .fondoBoton1(pH: 3, pV: 3, isActive: false, color: .gray.opacity(0.6))
                }
                .padding(0)
                
                GeometryReader { geo in
                    MenuCentro(coleccionActualVM: pc.getColeccionActual())
                        .fondoBoton1(pH: 3, pV: 3, isActive: false, color: .gray.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            menuCentroWidth = geo.size.width
                        }
                        .offset(y: 1.0)
                }
            }
        }
        .frame(height: 25)
    }
}
