
import SwiftUI

struct ListaVista: View {
    
    @ObservedObject var vm: ColeccionViewModel
    
    @State private var currentMagnification: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0
    @State private var scrollEnabled: Bool = true

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                        //                    HStack(spacing: 12) {
//                        let elemento = vm.elementos[index]
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
                        .id(index)
                        .onAppear {
                            if !vm.isPerformingAutoScroll && vm.scrollPosition != index {
                                vm.actualizarScroll(index)
                            }
                        }
                        
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: vm.altura)
            }
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        scrollEnabled = false
                        currentMagnification = value
                    }
                    .onEnded { value in
                        let delta = value / lastMagnification
                        
                        if delta > 1.1, vm.altura < 250 {
                            vm.altura += 30
                        } else if delta < 0.9, vm.altura > 100 {
                            vm.altura -= 30
                        }
                        
                        PersistenciaDatos().guardarAtributoVista(coleccion: vm.coleccion, modo: vm.modoVista, atributo: "altura", valor: vm.altura)
                        
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

