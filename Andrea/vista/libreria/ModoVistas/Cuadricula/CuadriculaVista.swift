//
//  LibreriaEjemplo.swift
//  Andrea
//
//  Created by mgg on 1/6/25.
//

import SwiftUI

struct CuadriculaVista: View {
    
    @EnvironmentObject var sa: SistemaArchivos
    
    let colorColeccion: Color = PilaColecciones.getPilaColeccionesSingleton.getColeccionActual().directoryColor
    
    var body: some View {
        
        GeometryReader { outerGeometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.adaptive(minimum: 165)), count: Int(outerGeometry.size.width / 165)),
                        spacing: 20
                    ) {
                        ForEach(sa.listaElementos.indices, id: \.self) { index in
                            let elemento = sa.listaElementos[index]

                            AnyView(
                                elemento is ElementoPlaceholder
                                ? AnyView(PlaceholderElementView())
                                : AnyView(
                                    ElementoVista(element: elemento) {
                                        if let coleccion = elemento as? Coleccion {
                                            CuadriculaColeccion(coleccion: coleccion)
                                        } else {
                                            if let archivo = elemento as? Archivo {
                                                CuadriculaArchivo(archivo: archivo, colorColeccion: colorColeccion)
                                            }
                                        }
                                    }
                                )
                            )
                        }


                    }
                }
            }
        }
        
    }
    
}
