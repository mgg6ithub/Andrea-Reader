//
//  CuadriculaColeccion.swift
//  Andrea
//
//  Created by mgg on 24/6/25.
//

import SwiftUI

struct CuadriculaColeccion: View {
    
    let coleccion: Coleccion
    
    var body: some View {
        
        Button(action: {
            coleccion.meterColeccion(coleccion: coleccion)
        }) {
            Text("Entrar")
                .font(.caption)
                .padding(.top, 2)
        }
        
    }
    
}
