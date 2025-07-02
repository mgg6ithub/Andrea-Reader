import SwiftUI

struct CuadriculaVista: View {
    
    @EnvironmentObject var sa: SistemaArchivos

    @State private var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 165), spacing: 20)]) {
                        ForEach(Array(sa.listaElementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(element: elemento) {
                                // tu contenido condicional aquí
                                if let _ = elemento as? ElementoPlaceholder {
                                    PlaceholderElementView()
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, colorColeccion: PilaColecciones.getPilaColeccionesSingleton.getColeccionActual().directoryColor)
                                }
                            }
                            .id(elemento.id)
                            .onAppear {
                                sa.coleccionActual.scrollPosition = index
                            }
                        }
                    }
                }
                .onAppear {
                    hacerScrollSiEsPosible(proxy: proxy)
                }
                .onChange(of: sa.coleccionActual) { newColeccion in
                    
                    print("Cambiando a ", sa.coleccionActual.name)
                    hacerScrollSiEsPosible(proxy: proxy)
                }
            }
        }
    }

    private func hacerScrollSiEsPosible(proxy: ScrollViewProxy) {
        guard let index = sa.coleccionActual.scrollPosition,
              index < sa.listaElementos.count else { return }

        let targetID = sa.listaElementos[index].id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            proxy.scrollTo(targetID, anchor: .top)
            print("Scroll automático a índice \(index) y id \(targetID) en colección \(sa.coleccionActual.name)")
        }
    }

    
}



