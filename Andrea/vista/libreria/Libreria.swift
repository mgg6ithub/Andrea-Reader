import SwiftUI

struct Libreria: View {
    
    @ObservedObject var vm: ModeloColeccion
    @Namespace private var animationNamespace

    var body: some View {
        ZStack {
            if vm.elementos.isEmpty {
                if vm.coleccion.nombre == "HOME" {
                    ImagenLibreriaVacia(imagen: "estanteria-vacia2", texto: "Biblioteca \"Andrea\" vacía.", anchura: 315, altura: 350)
                } else {
                    ImagenLibreriaVacia(imagen: "caja-vacia", texto: "Colección vacia, sin elementos.", anchura: 235, altura: 235)
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

struct ImagenLibreriaVacia: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let imagen: String
    let texto: String
    let anchura: CGFloat
    let altura: CGFloat
    
    var scala: CGFloat { ap.constantes.scaleFactor }
    
    @State private var show = false // Para controlar la animación
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(spacing: 0) {
                Image(imagen)
                    .resizable()
                    .frame(width: anchura * scala, height: altura * scala)
                
                Text(texto)
                    .font(.headline)
                
            }
            Spacer()
        }
        .aparicionStiffness(show: $show)
    }
}

