import SwiftUI

struct CuadriculaVista: View {
    
    @EnvironmentObject var sa: SistemaArchivos

    @State private var scrollProxy: ScrollViewProxy? = nil
    
    private let pc: PilaColecciones = PilaColecciones.getPilaColeccionesSingleton

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 165), spacing: 20)]) {
                        ForEach(Array(sa.listaElementos.enumerated()), id: \.element.id) { index, elemento in
                            ElementoVista(element: elemento) {
                                // tu contenido condicional aquí
                                if let _ = elemento as? ElementoPlaceholder {
                                    ZStack {
                                        PlaceholderElementView()
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Text("#\(index)")
                                                    .foregroundColor(.red)
                                                    .padding(4)
                                                    .background(Color.black.opacity(0.6))
                                                    .cornerRadius(5)
                                                Spacer()
                                            }
                                            Spacer()
                                        }
                                    }
                                } else if let coleccion = elemento as? Coleccion {
                                    CuadriculaColeccion(coleccion: coleccion)
                                } else if let archivo = elemento as? Archivo {
                                    CuadriculaArchivo(archivo: archivo, colorColeccion: pc.getColeccionActual().directoryColor)
                                }
                            }
                            .id(index)
                            .onAppear {
                                print("Guardando \(sa.coleccionActual.name) -> \(index)")
                                sa.coleccionActual.scrollPosition = index
                            }
                        }
                    }
                }
                .onChange(of: sa.coleccionActual) { newColeccion in
                    
                    print("Cambiando a ", sa.coleccionActual.name)
                    print("Indice de la coleccion de la vista: ", sa.coleccionActual.scrollPosition)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        proxy.scrollTo(sa.coleccionActual.scrollPosition ?? 0, anchor: .top) // Por ejemplo, scroll hasta el índice 50
                    }
                    
                }
            }
        }
    }

}



