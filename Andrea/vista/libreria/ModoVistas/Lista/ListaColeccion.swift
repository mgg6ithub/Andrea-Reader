

import SwiftUI

struct ListaColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var coleccion: Coleccion
    @ObservedObject var coleccionVM: ModeloColeccion
    
    var body: some View {
        
        HStack(spacing: 10) {
            ZStack {
                if coleccion.tipoMiniatura == .carpeta {
                    Image("CARPETA-ATRAS")
                        .resizable()
                        .frame(width: 150, height: coleccionVM.altura)
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
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    // ---- Información básica ----
                    HStack(spacing: 6) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(coleccion.color.gradient.opacity(0.3))
                                .frame(width: 30, height: 30)
                                .shadow(color: coleccion.color.opacity(0.25), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "folder.fill")
                                .foregroundColor(coleccion.color)
                                .frame(width: 25, height: 25)
                        }
                        
                        Text(coleccion.nombre)
                            .textoAdaptativo(t: ap.constantes.titleSize, a: 0.6, l: 2, b: true, alig: .leading, mW: .infinity, fAlig: .leading)
                    }
                    
                    HStack(spacing: 20) {
                        Text("3.25 GB")
                            .textoAdaptativo(t: ap.constantes.subTitleSize, a: 0.6, l: 1, b: false, c: .secondary, alig: .leading, s: true)
                        Text("\(coleccion.totalArchivos) elementos")
                            .textoAdaptativo(t: ap.constantes.subTitleSize, a: 0.6, l: 1, b: false, c: .secondary, alig: .leading, s: true)
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
                .padding(25)
            }
            .frame(height: coleccionVM.altura)
            .background(ap.temaActual.cardColor)
            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}
