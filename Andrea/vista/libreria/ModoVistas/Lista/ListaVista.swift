
import SwiftUI

struct ListaVista: View {
    
    @EnvironmentObject var menuEstado: MenuEstado
    
    @ObservedObject var vm: ModeloColeccion
    var namespace: Namespace.ID
    
    @State private var visibleIndices: [VisibleIndex] = []
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var elementoArrastrando: ElementoSistemaArchivos? = nil
    @State private var scrollEnabled: Bool = true

    var body: some View {
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
                LazyVStack(spacing: 20) {
                    ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                        ElementoVista(vm: vm, elemento: elemento, scrollIndex: index) {
                            // Miniatura + título en fila
                            if let placeholder = elemento as? ElementoPlaceholder {
                                PlaceholderLista(placeholder: placeholder, coleccionVM: vm)
                            } else if let archivo = elemento as? Archivo {
                                ListaArchivo(archivo: archivo, coleccionVM: vm)
                            } else if let coleccion = elemento as? Coleccion {
                                ListaColeccion(coleccion: coleccion)
                            }
                        }
                        .matchedGeometryEffect(id: elemento.id, in: namespace)
                        .id(index)
                        .modifier(ArrastreManual(elementoArrastrando: $elementoArrastrando,viewModel: vm,elemento: elemento,index: index))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20/2)
                .animation(.easeInOut(duration: 0.3), value: vm.altura)
                .background(
                    GeometryReader { _ in Color.clear }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollIndexPreferenceKey.self) { newValue in
                visibleIndices = newValue

                guard !vm.isPerformingAutoScroll else { return }

                debounceWorkItem?.cancel()
                let workItem = DispatchWorkItem {
                    if let top = newValue
                        .filter({ $0.minY >= 0 })
                        .min(by: { $0.minY < $1.minY }) {

                        vm.actualizarScroll(top.index)
                    } else {
                        print("🔴 No hay índice visible tras detener scroll.")
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
                value: $vm.altura,
                minValue: 100,
                maxValue: 350,
                step: 35,
                scrollEnabled: $scrollEnabled,
                coleccion: vm.coleccion,
                modoVista: vm.modoVista,
                atributo: "altura"
            )

        }
    }
}

