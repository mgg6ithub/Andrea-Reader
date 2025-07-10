import SwiftUI

struct CuadriculaVista: View {

    @ObservedObject var vm: ColeccionViewModel
    let namespace: Namespace.ID

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 165), spacing: 20)],
                              spacing: 20
                    ) {
                        ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(element: elemento) {
//                                Group { // <- un contenedor para aplicar la transición
                                    if let placeholder = elemento as? ElementoPlaceholder {
                                        PlaceholderElementView(index: index)
//                                            .matchedGeometryEffect(id: placeholder.id, in: namespace)
//                                            .transition(.opacity.combined(with: .scale))
                                    } else if let archivo = elemento as? Archivo {
                                        CuadriculaArchivo(archivo: archivo, coleccion: vm.coleccion)
//                                            .matchedGeometryEffect(id: archivo.id, in: namespace)
//                                            .transition(.opacity.combined(with: .scale))
                                    }
//                                }
                            }
                            .id(index) // importante: asegúrate de que este `.id` sea consistente con scrollTo
                            .onAppear {
                                if !vm.isPerformingAutoScroll {
                                    vm.actualizarScroll(index)
                                }

                            }

                        }
                    }
                }
                .onChange(of: vm.isPerformingAutoScroll) { auto in
                    
                    if auto {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(vm.scrollPosition, anchor: .top)
                            vm.isPerformingAutoScroll = false
                        }
                    }
                    
                }

            }
        }
    }

}



