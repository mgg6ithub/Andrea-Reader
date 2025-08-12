import SwiftUI

struct ProgresoCuadricula: View, Equatable {
    let progreso: Int
    let coleccionColor: Color
    let totalWidth: CGFloat     // ancho disponible para la barra
    let padding: CGFloat

    static func == (lhs: ProgresoCuadricula, rhs: ProgresoCuadricula) -> Bool {
        lhs.progreso == rhs.progreso &&
        lhs.coleccionColor == rhs.coleccionColor &&
        lhs.totalWidth == rhs.totalWidth
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
                .fill(progreso > 0 ? Color.gray.opacity(0.7) : Color.gray.opacity(0.3))
                .frame(width: totalWidth, height: 3)

            // Barra rellena
            RoundedRectangle(cornerRadius: 3)
                .fill(coleccionColor)
                .frame(width: totalWidth * CGFloat(progreso) / 100.0, height: 3)
        }
        .frame(height: 3)
        .padding(.horizontal, padding)
    }
}



