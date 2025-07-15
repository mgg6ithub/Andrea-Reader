import SwiftUI

struct ProgresoCuadricula: View {
    
    let archivo: Archivo
    @ObservedObject var coleccionVM: ColeccionViewModel
    
//    var vm: ColeccionViewModel { PilaColecciones.getPilaColeccionesSingleton.getColeccionActual() }
    
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
                    ProgressView(value: 0.8)
                        .progressViewStyle(LinearProgressViewStyle(tint: coleccionVM.color ))
                        .frame(height: 4)
                        .padding(.horizontal, 10)
                        .animation(.linear(duration: 2), value: progreso)
                        .compositingGroup()
                }
                .animation(.easeInOut(duration: 0.7), value: coleccionVM.color)
            }
            .padding(.bottom, 10)
        }
        .compositingGroup()
    }
}

