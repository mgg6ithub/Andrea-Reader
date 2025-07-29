import SwiftUI

struct CuadriculaColeccion: View {
    @ObservedObject var coleccion: Coleccion
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button(action: {
                coleccion.meterColeccion()
            }) {
                VStack(spacing: 0) {
                    ZStack {
                        if coleccion.tipoMiniatura == .carpeta {
                            Image("CARPETA-ATRAS")
                                .resizable()
                                .frame(width: 150, height: 145)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(coleccion.color, coleccion.color.darken(by: 0.2))
                                .zIndex(1)
                        } else if coleccion.tipoMiniatura == .tray {
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
                    .frame(height: 150)
                    .onAppear {
                        if coleccion.tipoMiniatura == .tray && coleccion.miniaturasBandeja.isEmpty {
                            coleccion.precargarMiniaturas()
                        }
                    }
                    .onChange(of: coleccion.tipoMiniatura) {
                        if coleccion.tipoMiniatura == .tray && coleccion.miniaturasBandeja.isEmpty {
                            coleccion.precargarMiniaturas()
                        }
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


