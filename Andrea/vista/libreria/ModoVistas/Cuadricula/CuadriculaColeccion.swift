//
//  CuadriculaColeccion.swift
//  Andrea
//
//  Created by mgg on 24/6/25.
//

import SwiftUI

struct CuadriculaColeccion: View {
    
    let coleccion: Coleccion
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Button(action: {
                coleccion.meterColeccion()
            }) {
                VStack {
                    ZStack {
                        Image("CARPETA-ATRAS")
                            .resizable()
                            .frame(width: 150, height: 145)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(coleccion.color, coleccion.color.darken(by: 0.2)) // 20% más oscuro
                            .zIndex(1)
                        
//                        Image("CARPETA-DELANTE")
//                            .resizable()
//                            .frame(width: 150, height: 92.5)
//                            .foregroundColor(coleccion.color)
//                            .zIndex(2)
                    }
                    
                    Text(coleccion.nombre)
                        .font(.title)
                        .frame(alignment: .center)
                    
                }
            }
        }
        .frame(width: width, height: height)
        
    }
    
}
