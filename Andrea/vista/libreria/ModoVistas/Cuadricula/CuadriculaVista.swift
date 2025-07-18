import SwiftUI

struct GridMetrics {
  var columns: Int
  var containerWidth: CGFloat

  var itemSize: CGSize {
    let spacing: CGFloat = 20
    let totalSpacing = spacing * CGFloat(columns - 1)
    let w = (containerWidth - totalSpacing) / CGFloat(columns)
    let h = w * (310 / 180)
    return CGSize(width: w, height: h)
  }
}

struct CuadriculaVista: View {

    @ObservedObject var vm: ColeccionViewModel
    let namespace: Namespace.ID
    @State private var currentMagnification: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0
    @State private var scrollEnabled: Bool = true
    @State private var elementoArrastrando: ElementoSistemaArchivos? = nil
    @State private var scrollOffset: CGFloat = 0

    @State private var metrics = GridMetrics(columns: 4, containerWidth: 0)
    @State private var didAutoScroll = false
    
    var body: some View {
        GeometryReader { outerGeometry in

            Color.clear
                .onAppear {
                  metrics = GridMetrics(columns: vm.columnas, containerWidth: outerGeometry.size.width)
                }
                .onChange(of: vm.columnas) { newCols in
                  metrics.columns = newCols
                }
                .onChange(of: outerGeometry.size.width) { newWidth in
                  metrics.containerWidth = newWidth
                }
            
                let size = metrics.itemSize

                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.fixed(size.width), spacing: 20), count: metrics.columns),
                            spacing: 20
                        ) {
                            ForEach(vm.elementos.indices, id: \.self) { index in

                                let elemento = vm.elementos[index]

                                ElementoVista(vm: vm, elemento: elemento) {
                                    if let placeholder = elemento as? ElementoPlaceholder {
                                        PlaceholderCuadricula(placeholder: placeholder, width: size.width, height: size.height)
                                    } else if let archivo = elemento as? Archivo {
                                        CuadriculaArchivo(archivo: archivo, coleccionVM: vm, width: size.width, height: size.height)
                                    } else if let coleccion = elemento as? Coleccion {
                                        CuadriculaColeccion(coleccion: coleccion)
                                    }
                                }
                                .id(index)
                                .onAppear {
                                    if !vm.isPerformingAutoScroll && vm.scrollPosition != index {
                                        vm.actualizarScroll(index)
                                    }
                                }
                                .modifier(ArrastreManual(
                                    elementoArrastrando: $elementoArrastrando,
                                    viewModel: vm,
                                    elemento: elemento,
                                    index: index
                                ))
                            }
                        }

                    } //FIN SCROLLVIEW
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
                        including: .all
                    )
                    .onChange(of: vm.isPerformingAutoScroll) {
                        if !didAutoScroll {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                withAnimation(.none) {
                                    self.didAutoScroll = true
                                    proxy.scrollTo(vm.scrollPosition, anchor: .top)
                                    vm.isPerformingAutoScroll = false
                                  }
                            }
                        }
                    }
            }
        }
    }
}


