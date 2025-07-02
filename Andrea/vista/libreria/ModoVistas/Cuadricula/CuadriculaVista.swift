import SwiftUI

struct CuadriculaVista: View {
    
    @EnvironmentObject var sa: SistemaArchivos
    @EnvironmentObject var pc: PilaColecciones
    
    var coleccionActual: Coleccion { pc.getColeccionActual() }
    
    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 165), spacing: 20)]) {
                        ForEach(Array(sa.listaElementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(element: elemento) {
                                if let placeholder = elemento as? ElementoPlaceholder {
                                    PlaceholderElementView()
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, colorColeccion: coleccionActual.directoryColor)
                                }
                            }
                            .onAppear {
                                coleccionActual.scrollPosition = index
                                print("GUARDADO en '\(coleccionActual.name)': \(index)")
                                
                            }
                        }
                    }
                }
                .onChange(of: coleccionActual) { _ in
                    if let targetID = coleccionActual.scrollPosition {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            scrollProxy.scrollTo(targetID, anchor: .top)
                            print("SCROLLING to \(targetID) in '\(coleccionActual.name)'")
                        }
                    }
                }
            }
        }
    }
}

