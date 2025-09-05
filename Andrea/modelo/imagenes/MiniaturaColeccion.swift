import SwiftUI

struct MiniaturaColeccionView: View {
    @ObservedObject var coleccion: Coleccion
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack {
            if coleccion.tipoMiniatura == .carpeta {
                Image("CARPETA-ATRAS")
                    .resizable()
                    .frame(width: width, height: height)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        coleccion.color.gradient,
                        coleccion.color.darken(by: 0.2).gradient
                    )
                    .zIndex(1)
            } else if coleccion.tipoMiniatura == .abanico {
                let direccionAbanico = coleccion.direccionAbanico
                let baseXStep = width * 0.053
                let yStep     = height * 0.028
                let baseAngleStep: Double = 4
                let scaleStep: CGFloat = 0.02
                let xStep = direccionAbanico == .izquierda ? -baseXStep : baseXStep
                let angleStep = direccionAbanico == .izquierda ? -baseAngleStep : baseAngleStep
                let rotationAnchor: UnitPoint = direccionAbanico == .izquierda ? .topLeading : .topTrailing

                ForEach(Array(coleccion.miniaturasBandeja.enumerated()), id: \.offset) { index, img in
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: width * 0.8, height: height * 0.65)
                        .cornerRadius(4)
                        .shadow(radius: 1.5)
                        .scaleEffect(index == 0 ? 1.0 : 1.0 - CGFloat(index) * scaleStep)
                        .rotationEffect(
                            .degrees(index == 0 ? 0 : Double(index) * angleStep),
                            anchor: rotationAnchor
                        )
                        .offset(
                            x: index == 0 ? 0 : CGFloat(index) * xStep,
                            y: index == 0 ? 0 : -CGFloat(index) * yStep
                        )
                        .zIndex(index == 0
                                ? Double(coleccion.miniaturasBandeja.count + 1)
                                : Double(coleccion.miniaturasBandeja.count - index))
                }
            }
        }
        .onAppear {
            if coleccion.tipoMiniatura == .abanico && coleccion.miniaturasBandeja.isEmpty {
                coleccion.precargarMiniaturas()
            }
        }
        .onChange(of: coleccion.tipoMiniatura) {
            if coleccion.tipoMiniatura == .abanico && coleccion.miniaturasBandeja.isEmpty {
                coleccion.precargarMiniaturas()
            }
        }
    }
}

