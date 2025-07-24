import SwiftUI

struct CuadriculaVista: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    @ObservedObject var vm: ColeccionViewModel
    
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
                            print("🔥 Ejecutando scrollTo con proxy:", vm.scrollPosition)
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


struct ScrollIndexPreferenceKey: PreferenceKey {
    static var defaultValue: [VisibleIndex] = []
    static func reduce(value: inout [VisibleIndex], nextValue: () -> [VisibleIndex]) {
        let new = nextValue()
        value.append(contentsOf: new)
    }

}

struct VisibleIndex: Equatable {
    let index: Int
    let minY: CGFloat
}

struct ModificarSize<Value: Numeric & Comparable>: ViewModifier {
    @Binding var value: Value
    var minValue: Value
    var maxValue: Value
    var step: Value
    @Binding var scrollEnabled: Bool

    // Parámetros para persistir
    var coleccion: Coleccion
    var modoVista: EnumModoVista
    var atributo: String

    @State private var lastMagnification: CGFloat = 1.0
    @State private var currentMagnification: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { val in
                        scrollEnabled = false
                        currentMagnification = val
                    }
                    .onEnded { val in
                        let delta = val / lastMagnification

                        let currentDouble = toDouble(value)
                        let stepDouble = toDouble(step)
                        let minDouble = toDouble(minValue)
                        let maxDouble = toDouble(maxValue)

                        var newValue = currentDouble

                        switch modoVista {
                        case .cuadricula:
                            if delta > 1.1, currentDouble - stepDouble >= minDouble {
                                // Zoom in (acercar) => menos columnas
                                newValue = currentDouble - stepDouble
                            } else if delta < 0.9, currentDouble + stepDouble <= maxDouble {
                                // Zoom out (alejar) => más columnas
                                newValue = currentDouble + stepDouble
                            }
                        default:
                            if delta > 1.1, currentDouble + stepDouble <= maxDouble {
                                // Zoom in (acercar) => más tamaño
                                newValue = currentDouble + stepDouble
                            } else if delta < 0.9, currentDouble - stepDouble >= minDouble {
                                // Zoom out (alejar) => menos tamaño
                                newValue = currentDouble - stepDouble
                            }
                        }

                        if let convertedBack = fromDouble(newValue) {
                            value = convertedBack
                        }

                        PersistenciaDatos().guardarAtributoVista(
                            coleccion: coleccion,
                            modo: modoVista,
                            atributo: atributo,
                            valor: value
                        )

                        lastMagnification = 1.0
                        currentMagnification = 1.0

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            scrollEnabled = true
                        }
                    }
            )
    }

    // Helpers para convertir Numeric genérico a Double
    func toDouble<T: Numeric>(_ val: T) -> Double {
        if let v = val as? Double { return v }
        if let v = val as? CGFloat { return Double(v) }
        if let v = val as? Int { return Double(v) }
        // Agrega más conversiones si quieres
        return 0
    }

    func fromDouble(_ val: Double) -> Value? {
        if Value.self == Double.self {
            return val as? Value
        }
        if Value.self == CGFloat.self {
            return CGFloat(val) as? Value
        }
        if Value.self == Int.self {
            return Int(val) as? Value
        }
        return nil
    }
}

extension View {
    func modificarSizeExtension<Value: Numeric & Comparable>(
        value: Binding<Value>,
        minValue: Value,
        maxValue: Value,
        step: Value,
        scrollEnabled: Binding<Bool>,
        coleccion: Coleccion,
        modoVista: EnumModoVista,
        atributo: String
    ) -> some View {
        self.modifier(
            ModificarSize(
                value: value,
                minValue: minValue,
                maxValue: maxValue,
                step: step,
                scrollEnabled: scrollEnabled,
                coleccion: coleccion,
                modoVista: modoVista,
                atributo: atributo
            )
        )
    }
}
