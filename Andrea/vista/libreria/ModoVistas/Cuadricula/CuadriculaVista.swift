import SwiftUI

struct CuadriculaVista: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    @ObservedObject var vm: ModeloColeccion
    var namespace: Namespace.ID
    
    @State private var visibleIndices: [VisibleIndex] = []
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var elementoArrastrando: ElementoSistemaArchivos? = nil
    @State private var scrollEnabled: Bool = true

    var body: some View {
        GeometryReader { geo in
            
//            VStack(spacing: 0) {
                
//                if hasScrolled {
//                    Rectangle()
//                        .fill(Color.gray)
//                        .frame(height: 1)
//                        .transition(.opacity)
//                }


               let outerPadding: CGFloat = 20      // ← cuanto quieras de margen a cada lado
               let spacing: CGFloat = 20           // ← spacing interno entre celdas
               let columnsCount = vm.columnas
               
               // ANCHO REAL DISPONIBLE para la grid, descontando los márgenes exteriores
               let contentWidth = geo.size.width - outerPadding * 2
               
               // total de los gaps internos
               let totalSpacing = spacing * CGFloat(columnsCount - 1)
               
               // calculamos el width de cada celda sobre el contentWidth
               let itemWidth = (contentWidth - totalSpacing) / CGFloat(columnsCount)
               let aspectRatio: CGFloat = 310/180
               let itemHeight = itemWidth * aspectRatio

                ScrollViewReader { proxy in
                    
                    Color.clear
                        .frame(height: 0)
                        .onAppear {
                            guard vm.isPerformingAutoScroll else { return }
                            DispatchQueue.main.async {
                                proxy.scrollTo(vm.scrollPosition, anchor: .top)
                                vm.isPerformingAutoScroll = false
                            }
                        }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(
                            columns: Array(
                                repeating: GridItem(.fixed(itemWidth), spacing: spacing),
                                count: columnsCount
                            ),
                            spacing: spacing
                        ) {
                            ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                                ElementoVista(vm: vm, elemento: elemento, scrollIndex: index, cambiarMiniatura: { nuevoTipo in
                                    print("Antes del cambio ", elemento.tipoMiniatura)
                                    elemento.tipoMiniatura = nuevoTipo
                                    print("Despues del cambio ", elemento.tipoMiniatura)
                                }) {
                                    if let placeholder = elemento as? ElementoPlaceholder {
                                        PlaceholderCuadricula(placeholder: placeholder, width: itemWidth, height: itemHeight)
                                    } else if let archivo = elemento as? Archivo {
                                        CuadriculaArchivo(archivo: archivo, coleccionVM: vm, width: itemWidth, height: itemHeight)
                                            .shadow(color: appEstado.temaActual == .dark ? Color.black.opacity(0.6) : Color.black.opacity(0.2), radius: 7, x: 0, y: 3)
                                            .contentShape(ContentShapeKinds.contextMenuPreview, RoundedRectangle(cornerRadius: 15))
                                    } else if let coleccion = elemento as? Coleccion {
                                        CuadriculaColeccion(coleccion: coleccion)
                                    }
                                }
                                .matchedGeometryEffect(id: elemento.id, in: namespace)
                                .id(index)  // importante para scrollTo
                                .modifier(ArrastreManual(elementoArrastrando: $elementoArrastrando,viewModel: vm,elemento: elemento,index: index))
                            }
                        }
                        .padding(.horizontal, outerPadding)
                        .padding(.vertical, spacing/2)
                        .animation(.easeInOut(duration: 0.3), value: vm.columnas)
                        .background(
                            GeometryReader { _ in Color.clear }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollIndexPreferenceKey.self) { newValue in
                        visibleIndices = newValue

                        // ✅ Detectar si el ítem top está debajo del inicio visible
//                        if let top = newValue.min(by: { $0.minY < $1.minY }) {
//                            hasScrolled = top.minY < -1  // <- margen de tolerancia por seguridad
//                        } else {
//                            hasScrolled = false
//                        }

                        // Resto de lógica (debounce, scrollPos)...
                        guard !vm.isPerformingAutoScroll else { return }

                        debounceWorkItem?.cancel()
                        let workItem = DispatchWorkItem {
                            if let top = newValue
                                .filter({ $0.minY >= 0 })
                                .min(by: { $0.minY < $1.minY }) {
                                vm.actualizarScroll(top.index)
                            }
                        }
                        debounceWorkItem = workItem
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
                    }
                    .onChange(of: vm.elementos) {
                        guard vm.isPerformingAutoScroll else { return }
                        if vm.elementos.count > 0 {
                            DispatchQueue.main.async {
                                proxy.scrollTo(vm.scrollPosition, anchor: .top)
                                vm.isPerformingAutoScroll = false
                            }
                        }
                    }
                    .onChange(of: vm.modoVista) {
                        vm.isPerformingAutoScroll = true
                        DispatchQueue.main.async {
                            proxy.scrollTo(vm.scrollPosition, anchor: .top)
                        }
                    }

                    .modificarSizeExtension(
                        value: $vm.columnas,
                        minValue: 2,
                        maxValue: 6,
                        step: 1,
                        scrollEnabled: $scrollEnabled,
                        coleccion: vm.coleccion,
                        modoVista: vm.modoVista,
                        atributo: "columnas"
                    )
                }
//            } //vstack porsiacaso

        }
    }
    
}
