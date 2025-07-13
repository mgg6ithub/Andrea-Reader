import SwiftUI

struct CuadriculaVista: View {

    @ObservedObject var vm: ColeccionViewModel
    let namespace: Namespace.ID
    @State private var cols: Int = 4
    @State private var currentMagnification: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0
    @State private var scrollEnabled: Bool = true


    var body: some View {
        GeometryReader { outerGeometry in
            
            let spacing: CGFloat = 20
            let columnsCount = cols // o lo puedes pasar como parámetro si quieres que sea dinámico
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let itemWidth = (outerGeometry.size.width - totalSpacing) / CGFloat(columnsCount)
            
            let aspectRatio: CGFloat = 310 / 180
            let itemHeight = itemWidth * aspectRatio
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: columnsCount),
                        spacing: spacing
                    ) {
                        ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(element: elemento) {
//                                Group { // <- un contenedor para aplicar la transición
                                    if let placeholder = elemento as? ElementoPlaceholder {
                                        PlaceholderElementView(index: index, width: itemWidth, height: itemHeight)
//                                            .matchedGeometryEffect(id: placeholder.id, in: namespace)
//                                            .transition(.opacity.combined(with: .scale))
                                    } else if let archivo = elemento as? Archivo {
                                        CuadriculaArchivo(archivo: archivo, coleccion: vm.coleccion, width: itemWidth, height: itemHeight)
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
                    .animation(.easeInOut(duration: 0.35), value: cols)
                }
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scrollEnabled = false
                            currentMagnification = value
                        }
                        .onEnded { value in
                            let delta = value / lastMagnification

                            if delta > 1.1, cols < 8 {
                                cols += 1
                            } else if delta < 0.9, cols > 1 {
                                cols -= 1
                            }

                            lastMagnification = 1.0
                            currentMagnification = 1.0

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                scrollEnabled = true
                            }
                        },
                    including: .all // <- esto da prioridad real al gesto incluso sobre el scroll
                )

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



