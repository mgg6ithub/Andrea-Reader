

import SwiftUI

struct InformacionCuadricula: View, Equatable {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var coleccionVM: ModeloColeccion
    let nombre: String
    let tipo: String
    let tamanioMB: String
    let totalPaginas: Int?
    let progreso: Int
    let coleccionColor: Color
    let maxWidth: CGFloat
    
    private var tema: EnumTemas { ap.temaResuelto }

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
                    .foregroundColor(tema.colorContrario)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.85)
                    .lineLimit(2)

//                Spacer()
//            }

            HStack(spacing: 0) {
                if progreso > 0 {
                    HStack(spacing: 0) {
                        Group {
                            Text("%")
                                .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.55))
                                .bold()
                                .foregroundColor(coleccionVM.color)
                                .zIndex(3)
                            
                            Text("\(progreso)")
                                .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.85))
                                .bold()
                                .foregroundColor(coleccionVM.color)
                                .zIndex(3)
                        }
//                        .animation(.easeInOut(duration: 0.45), value: coleccionVM.coleccion.color)
                        .animacionDesvanecer(coleccionVM.coleccion.color)
                    }
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Text(tipo)
                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.8))
                        .foregroundColor(tema.secondaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()

                    Text("\(tamanioMB)")
                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.8))
                        .foregroundColor(tema.secondaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()

                    Text("\(totalPaginas.map { "\($0) pages" } ?? "—")")
                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.8))
                        .foregroundColor(tema.secondaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            
            ProgresoCuadricula(
                progreso: progreso,
                coleccionColor: coleccionVM.color,
                totalWidth: .infinity,
                padding: 0
            )
            .frame(maxHeight: 24)
            .padding(.bottom, 10)
            
        }
        .padding(8)
    }
}

