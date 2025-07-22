import SwiftUI

struct CuadriculaVista: View {
    @ObservedObject var vm: ColeccionViewModel
    
    @State private var visibleIndices: [VisibleIndex] = []
    @State private var debounceWorkItem: DispatchWorkItem?

    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 20
            let columnsCount = 6
            let totalSpacing = spacing * CGFloat(columnsCount - 1)
            let itemWidth = (geo.size.width - totalSpacing) / CGFloat(columnsCount)
            let aspectRatio: CGFloat = 310 / 180
            let itemHeight = itemWidth * aspectRatio

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.fixed(itemWidth), spacing: spacing),
                            count: columnsCount
                        ),
                        spacing: spacing
                    ) {
                        ForEach(Array(vm.elementos.enumerated()), id: \.offset) { index, elemento in
                            ElementoVista(vm: vm, elemento: elemento, scrollIndex: index) {
                                if let placeholder = elemento as? ElementoPlaceholder {
                                    PlaceholderCuadricula(placeholder: placeholder, width: itemWidth, height: itemHeight)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, coleccionVM: vm, width: itemWidth, height: itemHeight)
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                }
                            }
                            .id(index)  // importante para scrollTo
                        }
                    }
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

                            print("🟢 Scroll detenido. Índice visible superior:", top.index)
                            vm.actualizarScroll(top.index)
                        } else {
                            print("🔴 No hay índice visible tras detener scroll.")
                        }
                    }
                    debounceWorkItem = workItem
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
                }
//                .onPreferenceChange(ScrollIndexPreferenceKey.self) { newValue in
//                    visibleIndices = newValue
//
//                    guard !vm.isPerformingAutoScroll else { return }
//
//                    debounceWorkItem?.cancel()
//                    let scrollViewHeight = geo.size.height // <- este es el alto visible del ScrollView
//                    let centerY = scrollViewHeight / 2
//
//                    let workItem = DispatchWorkItem {
//                        // Busca el índice cuyo centro esté más cerca del centro del scrollView
//                        if let centered = newValue
//                            .filter({ $0.minY >= -itemHeight && $0.minY <= scrollViewHeight }) // visibles o casi visibles
//                            .min(by: {
//                                let centerA = $0.minY + itemHeight / 2
//                                let centerB = $1.minY + itemHeight / 2
//                                return abs(centerA - centerY) < abs(centerB - centerY)
//                            }) {
//                            
//                            print("🎯 Elemento más centrado:", centered.index)
//                            vm.actualizarScroll(centered.index)
//                        } else {
//                            print("⚠️ No hay elemento centrado visible")
//                        }
//                    }
//
//                    debounceWorkItem = workItem
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
//                }
                .onChange(of: vm.elementos) { newElementos in
                    guard vm.isPerformingAutoScroll else { return }
                    if newElementos.count > 0 {
                        DispatchQueue.main.async {
                            proxy.scrollTo(vm.scrollPosition, anchor: .top)
                            vm.isPerformingAutoScroll = false
                        }
                    }
                }





            }

        }
    }
}


struct ScrollIndexPreferenceKey: PreferenceKey {
    static var defaultValue: [VisibleIndex] = []
    static func reduce(value: inout [VisibleIndex], nextValue: () -> [VisibleIndex]) {
        let new = nextValue()
//        print("📦 Se reportan índices visibles: \(new.map(\.index))")
        value.append(contentsOf: new)
    }

}

struct VisibleIndex: Equatable {
    let index: Int
    let minY: CGFloat
}
