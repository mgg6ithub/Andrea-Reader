import SwiftUI

struct CuadriculaVista: View {

    @ObservedObject var vm: ColeccionViewModel

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 165), spacing: 20)]) {
                        ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(element: elemento) {
                                // tu contenido condicional aquí
                                if let _ = elemento as? ElementoPlaceholder {
                                    PlaceholderElementView()
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, colorColeccion: vm.coleccion.directoryColor)
                                }
                            }
                            .id(index) // importante: asegúrate de que este `.id` sea consistente con scrollTo
                            .onAppear {

                                // Guarda posición de scroll si no estás autoscrolleando
                                if !vm.isPerformingAutoScroll {
                                    vm.scrollPosition = index
                                }
                                
                            }
                        }
                    }
                }
                .onChange(of: vm.isPerformingAutoScroll) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo(vm.coleccion.scrollPosition)
                            vm.isPerformingAutoScroll = false
                        }
                    }
                }
            }
        }
    }

}



