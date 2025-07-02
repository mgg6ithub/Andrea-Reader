import SwiftUI

struct CuadriculaVista: View {
    @EnvironmentObject var sa: SistemaArchivos
    @EnvironmentObject var pc: PilaColecciones

    var coleccionActual: Coleccion { pc.getColeccionActual() }

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
                                    CuadriculaArchivo(archivo: archivo, colorColeccion: coleccionActual.directoryColor)
                                }
                            }
                            .id(elemento.id)
                            .onAppear {
                                coleccionActual.scrollPosition = index
                            }
                        }
                    }
                }
                .onAppear {
                    // Guardamos el proxy para usarlo luego
                    scrollProxy = proxy

                    // Lanzamos el refresco de la colección actual (la que está en pc)
                    sa.refreshIndex(coleccionActual: coleccionActual.url) {
                        // Cuando termine el refresh, hacemos scroll
                        hacerScrollSiEsPosible(proxy: proxy)
                    }
                }
                .onChange(of: pc.colecciones) { _ in
                    // Cuando cambia la colección, refrescamos la lista y hacemos scroll
                    sa.refreshIndex(coleccionActual: coleccionActual.url) {
                        if let proxy = scrollProxy {
                            hacerScrollSiEsPosible(proxy: proxy)
                        }
                    }
                }
            }
        }
    }

    private func hacerScrollSiEsPosible(proxy: ScrollViewProxy) {
        guard let index = coleccionActual.scrollPosition,
              index < sa.listaElementos.count else { return }

        let targetID = sa.listaElementos[index].id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            proxy.scrollTo(targetID, anchor: .top)
            print("Scroll automático a índice \(index) y id \(targetID) en colección \(coleccionActual.name)")
        }
    }
}



