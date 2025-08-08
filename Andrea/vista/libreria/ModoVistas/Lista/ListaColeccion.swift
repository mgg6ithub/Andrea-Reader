//
//  ListaColeccion.swift
//  Andrea
//
//  Created by mgg on 15/7/25.
//

import SwiftUI

struct ListaColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var coleccion: Coleccion
    @ObservedObject var coleccionVM: ModeloColeccion
    
    var body: some View {
        HStack(spacing: 0) {
            
            ZStack {
                if coleccion.tipoMiniatura == .carpeta {
                    Image("CARPETA-ATRAS")
                        .resizable()
                        .frame(width: 150, height: 145)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(coleccion.color, coleccion.color.darken(by: 0.2))
                        .zIndex(1)
                } else if coleccion.tipoMiniatura == .abanico {
                    // Miniaturas apiladas en vertical, parcialmente visibles
                    ForEach(Array(coleccion.miniaturasBandeja.enumerated()), id: \.offset) { index, img in
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 120)
                            .clipped()
                            .cornerRadius(5)
                            .shadow(radius: 2)
                            .offset(x: 0, y: CGFloat(10 - index * 22)) // apiladas de atrás hacia delante
                            .scaleEffect(1.0 - CGFloat(index) * 0.03)
                            .zIndex(Double(index))
                    }
                    
                    // Imagen de bandeja en primer plano
                    Image("bandeja")
                        .resizable()
                        .frame(width: 150, height: 100)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(coleccion.color, coleccion.color.darken(by: 0.2))
                        .fontWeight(.thin)
                        .offset(y: 15) // baja la bandeja un poco para "cubrir" las miniaturas
                        .zIndex(Double(coleccion.miniaturasBandeja.count) + 1)
                }
            }
            
            HStack(spacing: 0) {
                Spacer()
                
                Text(coleccion.nombre)
                    .font(.title)
                    .bold()
                    .frame(alignment: .center)
                
                Spacer()
            }
            
        }
        .frame(height: coleccionVM.altura)
        .background(ap.temaActual.cardColor)
        .cornerRadius(8, corners: [.topLeft, .bottomLeft])
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
