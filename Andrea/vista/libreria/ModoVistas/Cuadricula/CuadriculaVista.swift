import SwiftUI

struct CuadriculaVista: View {

    @ObservedObject var vm: ColeccionViewModel
    let namespace: Namespace.ID
//    @State private var cols: Int { vm.columnas }
    @State private var currentMagnification: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0
    @State private var scrollEnabled: Bool = true

    var body: some View {
        GeometryReader { outerGeometry in
            
            let spacing: CGFloat = 20
            let columnsCount = vm.columnas // o lo puedes pasar como parámetro si quieres que sea dinámico
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let itemWidth = (outerGeometry.size.width - totalSpacing) / CGFloat(columnsCount)
            
            let aspectRatio: CGFloat = 310 / 180
            let itemHeight = itemWidth * aspectRatio
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: columnsCount),
                        spacing: spacing
                    ) {
                        ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(vm: vm, elemento: elemento) {
                                if let _ = elemento as? ElementoPlaceholder {
                                    PlaceholderElementView(index: index, width: itemWidth, height: itemHeight)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, coleccionVM: vm, width: itemWidth, height: itemHeight)
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                }
                            }
                            .id(index) // importante: asegúrate de que este `.id` sea consistente con scrollTo
                            .onAppear {
                                if !vm.isPerformingAutoScroll {
                                    vm.actualizarScroll(index)
                                }

                            }

                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: vm.columnas)
                }
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scrollEnabled = false
                            currentMagnification = value
                        }
                        .onEnded { value in
                            let delta = value / lastMagnification

                            if delta > 1.1, vm.columnas < 8 {
                                vm.columnas -= 1
                            } else if delta < 0.9, vm.columnas > 1 {
                                vm.columnas += 1
                            }
                            
                            PersistenciaDatos().guardarAtributoVista(coleccion: vm.coleccion, modo: vm.modoVista, atributo: "columnas", valor: vm.columnas)
                            
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



