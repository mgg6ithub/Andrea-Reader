//
//  LibreriaEjemplo.swift
//  Andrea
//
//  Created by mgg on 1/6/25.
//

import SwiftUI

struct LibreriaEjemplo: View {
    
    @EnvironmentObject var sa: SistemaArchivos
    
    var body: some View {
        
        GeometryReader { outerGeometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.adaptive(minimum: 150)), count: Int(outerGeometry.size.width / 150)),
                        spacing: 20
                    ) {
                        ForEach(sa.listaElementos.indices, id: \.self) { index in
                            let elemento = sa.listaElementos[index]

                            if elemento is ElementoPlaceholder {
                                PlaceholderElementView()
                            } else {
                                RealElementView(element: elemento)
                            }
                        }

                    }
                }
            }
        }
        
    }
    
}
