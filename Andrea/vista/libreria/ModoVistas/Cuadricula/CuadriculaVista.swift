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
                        columns: [GridItem(.adaptive(minimum: 165), spacing: 20)]
                    ) {
                        ForEach(sa.listaElementos, id: \.id) { elemento in

                            if let placeholder = elemento as? ElementoPlaceholder {
                                PlaceholderElementView()
                            } else if let coleccion = elemento as? Coleccion {
                                CuadriculaColeccion(coleccion: coleccion)
                            } else if let archivo = elemento as? Archivo {
                                CuadriculaArchivo(archivo: archivo, colorColeccion: colorColeccion)
                            }

                        }


                    }
                }
            }
        }
        
    }
    
}
