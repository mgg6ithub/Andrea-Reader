//
//  CuadriculaColeccion.swift
//  Andrea
//
//  Created by mgg on 24/6/25.
//

import SwiftUI

struct CuadriculaColeccion: View {
    
    let coleccion: Coleccion
    
    @State private var isExpanded = false
    @State private var isVisible = false
    
    var body: some View {
        
        Button(action: {
            coleccion.meterColeccion()
        }) {
            VStack {
                ZStack {
                    Image("CARPETA-ATRAS")
                        .resizable()
                        .frame(width: 120, height: 125)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.cyan, Color.blue)
                        .zIndex(1)
                    
                    Image(isExpanded ? "CARPETA-ALANTE-ABIERTA" : "CARPETA-DELANTE")
                        .resizable()
//                        .frame(width: isExpanded ? 125 : 120, height: 72.5)
                        .foregroundColor(Color.cyan)
                        .zIndex(2)
//                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                }
                
                Text(coleccion.name)
                    .font(.title)
                    .frame(alignment: .center)
                
            }
        }
//        .scaleEffect(isVisible ? 1 : 0.95)
//        .opacity(isVisible ? 1 : 0)
//        .onAppear {
//            isVisible = true
//        }
//        .onDisappear {
//            isVisible = false
//        }
        
    }
    
}
