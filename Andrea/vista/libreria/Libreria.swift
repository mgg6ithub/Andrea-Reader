import SwiftUI

struct Libreria: View {
    
    @ObservedObject var vm: ModeloColeccion
    @EnvironmentObject var appEstado: AppEstado

    var body: some View {
        switch vm.modoVista {
        case .cuadricula:
            CuadriculaVista(vm: vm)

        case .lista:
            ListaVista(vm: vm)

        default:
            AnyView(Text("Vista desconocida"))
        }
    }
    
}
