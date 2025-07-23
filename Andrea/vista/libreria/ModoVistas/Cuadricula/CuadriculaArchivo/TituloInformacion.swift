

import SwiftUI

struct TituloInformacion: View, Equatable {
    
    @EnvironmentObject var appEstado: AppEstado
    
    let nombre: String
    let tipo: String
    let tamanioMB: Int
    let paginas: Int
    let progreso: Int
    let coleccionColor: Color
    let maxWidth: CGFloat

    static func == (lhs: TituloInformacion, rhs: TituloInformacion) -> Bool {
        lhs.nombre == rhs.nombre &&
        lhs.tipo == rhs.tipo &&
        lhs.tamanioMB == rhs.tamanioMB &&
        lhs.paginas == rhs.paginas &&
        lhs.progreso == rhs.progreso &&
        lhs.coleccionColor == rhs.coleccionColor &&
        lhs.maxWidth == rhs.maxWidth
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                Text(nombre)
                    .font(.system(size: ConstantesPorDefecto().titleSize * 0.5))
                    .foregroundColor(appEstado.temaActual.textColor)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .frame(maxWidth: maxWidth * 0.7)

                Spacer()

                Text("%\(progreso)")
                    .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.5))
                    .bold()
                    .foregroundColor(coleccionColor)
                    .frame(maxWidth: maxWidth * 0.3, alignment: .trailing)
            }

            HStack {
                Text(tipo)
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer()

                Text("\(tamanioMB) MB")
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer()

                Text("\(paginas) pages")
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(8)
    }
}

