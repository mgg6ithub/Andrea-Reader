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



