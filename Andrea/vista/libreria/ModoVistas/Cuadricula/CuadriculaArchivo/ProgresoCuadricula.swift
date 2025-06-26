import SwiftUI

struct ProgresoCuadricula: View {
    
    let archivo: Archivo
    let colorColeccion: Color
    
    var progreso: Int { archivo.fileProgressPercentage }
    var progresoEntero: Double { archivo.fileProgressPercentageEntero }
    
    var body: some View {
        VStack(spacing: 6) {
//            HStack {
//                Spacer()
//                
//                Color.clear
//                    .animatedProgressText1(progreso)
//                    .foregroundColor(colorColeccion)
//                    .font(.system(size: ConstantesPorDefecto().subTitleSize))
//                    .bold()
//            }
//            .padding(.trailing, 10)
            
            HStack(alignment: .center) {
                ZStack(alignment: .leading) {
                    // Fondo de la barra de progreso
                    RoundedRectangle(cornerRadius: 3)
                        .fill(progreso > 0 ? Color.gray.opacity(0.7) : Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .padding(.horizontal, 10)
                    
                    // Barra de progreso real
                    ProgressView(value: progresoEntero)
                        .progressViewStyle(LinearProgressViewStyle(tint: colorColeccion))
                        .frame(height: 4)
                        .padding(.horizontal, 10)
                        .animation(.linear(duration: 2), value: progreso)
                        .compositingGroup()
                }
            }
            .padding(.bottom, 10)
        }
        .compositingGroup()
    }
}

