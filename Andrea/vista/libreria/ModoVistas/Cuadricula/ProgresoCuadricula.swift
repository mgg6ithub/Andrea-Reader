import SwiftUI

struct ProgresoCuadricula: View, Equatable {
    
    @Binding var progresoMostrado: Int
    let coleccionColor: Color
    let totalWidth: CGFloat     // ancho disponible para la barra
    let padding: CGFloat

    static func == (lhs: ProgresoCuadricula, rhs: ProgresoCuadricula) -> Bool {
        lhs.progresoMostrado == rhs.progresoMostrado &&
        lhs.coleccionColor == rhs.coleccionColor &&
        lhs.totalWidth == rhs.totalWidth
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
                .fill(progresoMostrado > 0 ? Color.gray.opacity(0.7) : Color.gray.opacity(0.3))
                .frame(width: totalWidth, height: 3)

            // Barra rellena
            RoundedRectangle(cornerRadius: 3)
                .fill(coleccionColor)
                .frame(width: totalWidth * CGFloat(progresoMostrado) / 100.0, height: 3)
                .animacionDesvanecer(coleccionColor)
        }
        .frame(height: 3)
        .padding(.horizontal, padding)
    }
}

struct ProgresoContorno: View {
    @Binding var progreso: Int        // 0…100
    var color: Color
    var lineWidth: CGFloat = 3
    var cornerRadius: CGFloat = 15
    /// -90 = arriba-centro; ~ -135 = arriba-izquierda
    var startAngle: Double = -135

    private var t: CGFloat { CGFloat(max(0, min(100, progreso))) / 100 }

    var body: some View {
        ZStack {
            // Guía gris (inside)
//            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
//                .inset(by: lineWidth / 2)
//                .stroke(Color.gray.opacity(0.25), lineWidth: lineWidth)

            // Progreso (inside + recortado)
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .inset(by: lineWidth / 2)
                .trim(from: 0, to: t)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       lineJoin: .round)
                )
                .rotationEffect(.degrees(180))
                .animation(.easeOut(duration: 0.6), value: progreso)
        }
        .compositingGroup()
        // .drawingGroup() // <- opcional si quieres suavizado extra (offscreen)
        .allowsHitTesting(false)
    }
}






