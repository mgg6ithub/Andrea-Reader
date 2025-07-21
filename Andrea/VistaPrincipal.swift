import SwiftUI

struct VistaPrincipal: View {
    
    @State private var animacionesInicialesActivadas = false
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State private var ultimaID: UUID? = nil
    
    private var viewMode: EnumModoVista { menuEstado.modoVistaColeccion }
    
    var body: some View {
        NavigationStack {
            ZStack {
                appEstado.temaActual.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    MenuVista()
                        .padding(.vertical, 8)
                    
                    
                    HistorialColecciones()
                        .frame(height: 50)
                        .padding(.bottom, 8)
                    
                    Spacer()
                    
                    Libreria(vm: pc.getColeccionActual())
                    
                }
                .padding(.horizontal, ConstantesPorDefecto().horizontalPadding)
                
                //MARK: --- AQUI AGREGAMOS LA COLECCION ---
                
            }
            .foregroundColor(appEstado.temaActual.textColor)
            .animation(.easeInOut, value: appEstado.temaActual)
        }
    }
}


struct Libreria: View {
    
    @ObservedObject var vm: ColeccionViewModel
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
