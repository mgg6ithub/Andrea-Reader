import SwiftUI

struct Libreria: View {

    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @Namespace private var animationNamespace
    @State private var show = false // Para controlar la animación
    
    var scala: CGFloat { ap.constantes.scaleFactor }

    var body: some View {
        ZStack {
            if vm.elementos.isEmpty {
                if vm.coleccion.nombre == "HOME" {
                    VStack(alignment: .center) {
                        Spacer()
                        VStack(spacing: 0) {
                            Image("estanteria9")
                                .resizable()
                                .frame(width: 300 * scala, height: 350 * scala)
                            
                            Text("Biblioteca \"Andrea\" vacía.")
                                .font(.headline)
                                .padding(.top, 20)
                            
                        }
                        Spacer()
                    }
                    .aparicionStiffness(show: $show)
                } else {
                    VStack(alignment: .center) {
                        Spacer()

                        VStack(spacing: 10) {
                            Image("caja-vacia")
                                .resizable()
                                .frame(width: 235 * scala, height: 235 * scala)
                                .aspectRatio(contentMode: .fit)

                            Text("Colección vacia, sin elementos.")
                                .font(.headline)
                        }

                        Spacer()
                    }
                    .aparicionStiffness(show: $show)
                }
            } else {
                switch vm.modoVista {
                case .cuadricula:
                    CuadriculaVista(vm: vm, namespace: animationNamespace)
                        .transition(.opacity.combined(with: .scale))

                case .lista:
                    ListaVista(vm: vm, namespace: animationNamespace)
                        .transition(.opacity.combined(with: .scale))

                default:
                    AnyView(Text("Vista desconocida"))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: vm.modoVista)
    }
}

