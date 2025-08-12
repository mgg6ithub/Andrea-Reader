

import SwiftUI

struct InformacionCuadricula: View, Equatable {
    
    @EnvironmentObject var appEstado: AppEstado
    
    let nombre: String
    let tipo: String
    let tamanioMB: String
    let totalPaginas: Int?
    let progreso: Int
    let coleccionColor: Color
    let maxWidth: CGFloat

    static func == (lhs: InformacionCuadricula, rhs: InformacionCuadricula) -> Bool {
        lhs.nombre == rhs.nombre &&
        lhs.tipo == rhs.tipo &&
        lhs.tamanioMB == rhs.tamanioMB &&
        lhs.totalPaginas == rhs.totalPaginas &&
        lhs.progreso == rhs.progreso &&
        lhs.coleccionColor == rhs.coleccionColor &&
        lhs.maxWidth == rhs.maxWidth
    }

    var body: some View {
        VStack(spacing: 4) {
//            HStack(spacing: 0) {
                Text(nombre)
                    .bold()
                    .id(nombre) // fuerza la transición
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity.combined(with: .scale)) // o .slide, .move(edge:), etc.
                    .animation(.easeInOut(duration: 0.3), value: nombre)
                    .font(.system(size: ConstantesPorDefecto().titleSize))
                    .foregroundColor(appEstado.temaActual.textColor)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.85)
                    .lineLimit(2)

//                Spacer()
//            }

            HStack(spacing: 0) {
                if progreso > 0 {
                    HStack(spacing: 0) {
                        Text("%")
                            .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.55))
                            .bold()
                            .foregroundColor(.blue)
                            .zIndex(3)
                        
                        Text("\(progreso)")
                            .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.85))
                            .bold()
                            .foregroundColor(.blue)
                            .zIndex(3)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Text(tipo)
                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.8))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("\(tamanioMB)")
                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.8))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("\(totalPaginas.map { "\($0) pages" } ?? "—")")
                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.8))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            
            ProgresoCuadricula(
                progreso: progreso,
                coleccionColor: .blue,
                totalWidth: .infinity,
                padding: 0
            )
            .frame(maxHeight: 24)
            .padding(.bottom, 10)
            
        }
        .padding(8)
    }
}

