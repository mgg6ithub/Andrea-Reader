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
                    let desactivarFondo =
                        (ap.sistemaArchivos == .tradicional && !me.iconoMenuLateral && !me.iconoFlechaAtras) ||
                        (ap.sistemaArchivos == .tradicional && !me.iconoMenuLateral && pc.getColeccionActual().coleccion.nombre == "HOME")
                    
                    MenuIzquierda()
                        .fondoBoton1(pH: 3, pV: 3, isActive: false, color: desactivarFondo ? .gray.opacity(0) : .gray.opacity(0.6))
                        .padding(0)
                    Spacer()
                    MenuDerecha()
                        .fondoBoton1(pH: 3, pV: 3, isActive: false, color: .gray.opacity(0.6))
                }
                .padding(0)
                
                GeometryReader { geo in
                    MenuCentro(coleccionActualVM: pc.getColeccionActual())
                        .fondoBoton1(pH: 3, pV: 3, isActive: false, color: .gray.opacity(0.6), trailingP: -3.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .onAppear {
                            menuCentroWidth = geo.size.width
                        }
                }
            }
        }
        .frame(height: 40)
    }
}
