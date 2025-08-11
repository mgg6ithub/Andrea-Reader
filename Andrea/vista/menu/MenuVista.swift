import SwiftUI

struct MenuVista: View {

    @State private var menuCentroWidth: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            ZStack {
                HStack {
                    MenuIzquierda()
                        .padding(0)
                    Spacer()
                    MenuDerecha()
                }
                .padding(0)
                
                GeometryReader { geo in
                    MenuCentro(coleccionActualVM: PilaColecciones.pilaColecciones.getColeccionActual())
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

