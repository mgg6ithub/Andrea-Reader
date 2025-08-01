import SwiftUI

struct Libreria: View {

    @ObservedObject var vm: ModeloColeccion
    @Namespace private var animationNamespace
    @State private var showEmptyState = false // Para controlar la animación

    var body: some View {
        ZStack {
            if vm.elementos.isEmpty {
                
                if vm.coleccion.nombre == "HOME" {
                    VStack(alignment: .center) {
                        Spacer()
                        VStack(spacing: 0) {
                            Image("esta")
                                .resizable()
                                .frame(width: 350, height: 550)
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(showEmptyState ? 1 : 0.8)
                                .opacity(showEmptyState ? 1 : 0)
                                .offset(y: showEmptyState ? 0 : 20)
                                .animation(.interpolatingSpring(stiffness: 100, damping: 10).delay(0.1), value: showEmptyState)
                            
                        }
                        Spacer()
                    }
                    .onAppear {
                        showEmptyState = true
                    }
                    .onDisappear {
                        showEmptyState = false
                    }
                } else {
                    VStack(alignment: .center) {
                        Spacer()

                        VStack(spacing: 10) {
                            Image("caja-vacia")
                                .resizable()
                                .frame(width: 235, height: 235)
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(showEmptyState ? 1 : 0.8)
                                .opacity(showEmptyState ? 1 : 0)
                                .offset(y: showEmptyState ? 0 : 20)
                                .animation(.interpolatingSpring(stiffness: 100, damping: 10).delay(0.1), value: showEmptyState)

                            Text("Colección vacia, sin elementos.")
                                .font(.headline)
                                .opacity(showEmptyState ? 1 : 0)
                                .animation(.easeOut.delay(0.4), value: showEmptyState)
                        }

                        Spacer()
                    }
                    .onAppear {
                        showEmptyState = true
                    }
                    .onDisappear {
                        showEmptyState = false
                    }
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

