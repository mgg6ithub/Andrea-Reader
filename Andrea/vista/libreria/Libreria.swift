import SwiftUI

struct Libreria: View {

    @ObservedObject var vm: ModeloColeccion
    @Namespace private var animationNamespace

    var body: some View {
        
        ZStack {
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
        .animation(.easeInOut(duration: 0.3), value: vm.modoVista)
        
    }
    
}
