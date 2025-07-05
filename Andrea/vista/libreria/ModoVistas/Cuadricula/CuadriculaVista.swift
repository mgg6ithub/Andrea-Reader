import SwiftUI

struct CuadriculaVista: View {

    @ObservedObject var vm: ColeccionViewModel
    @State private var haHechoScroll = false      // solo 1 vez
    @State private var apariciones: Int = 0

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 165), spacing: 20)]) {
                        ForEach(Array(vm.elementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(element: elemento) {
                                // tu contenido condicional aquí
                                if let _ = elemento as? ElementoPlaceholder {
//                                    ZStack {
                                        PlaceholderElementView()
//                                                .zIndex(0)
//
//                                            VStack {
//                                                Spacer()
//                                                HStack {
//                                                    Spacer()
//                                                    Text("\(index)") // <— así lo evitas el error
//                                                        .foregroundColor(.red)
//                                                        .padding(4)
//                                                        .background(Color.white.opacity(0.8))
//                                                        .clipShape(Circle())
//                                                    Spacer()
//                                                }
//                                                Spacer()
//                                            }
//                                            .zIndex(1)
//                                    }
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, colorColeccion: vm.coleccion.directoryColor)
                                }
                            }
                            .id(index) // importante: asegúrate de que este `.id` sea consistente con scrollTo
                            .onAppear {
//                                print("⚫️ Vista \(index) apareció, actualizando posición")
                                if !vm.isPerformingAutoScroll {
                                    vm.actualizarScroll(index)
                                }

                            }

                        }
                    }
                }
                .onChange(of: vm.isPerformingAutoScroll) { auto in
                    
                    if auto {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            print("Haciendo scroll a ", vm.scrollPosition)
                            proxy.scrollTo(vm.scrollPosition, anchor: .top)
                            vm.isPerformingAutoScroll = false
                        }
                    }
                    
                }
//                .onAppear {
//                    print("Aparecer la coleccion ", vm.scrollPosition)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        print("Haciendo scroll a ", vm.scrollPosition)
//                        proxy.scrollTo(vm.scrollPosition, anchor: .top)
//                        vm.isPerformingAutoScroll = false
//                    }
//                    
//                }

            }
        }
    }

}



