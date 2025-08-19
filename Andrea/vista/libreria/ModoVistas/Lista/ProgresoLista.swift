
import SwiftUI

struct ProgresoLista: View {
    
    let archivo: Archivo
    @ObservedObject var coleccionVM: ModeloColeccion
    
    var progreso: Int { archivo.progreso }
    var progresoEntero: Double { archivo.progresoEntero }
    
    var body: some View {
        HStack(spacing: 10) {
            
            Color.clear
                .animatedProgressText1(progreso)
                .foregroundColor(coleccionVM.color.opacity(0.6))
                .font(.system(size: ConstantesPorDefecto().subTitleSize))
                .bold()
            
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(progreso > 0 ? Color.gray.opacity(0.9) : Color.gray.opacity(0.4))
                    .frame(height: 4)
                    .padding(.horizontal, 10)
                
                ProgressView(value: 0.8)
                    .progressViewStyle(LinearProgressViewStyle(tint: coleccionVM.color)) // Cambia el color si es necesario
                    .frame(height: 5)
                    .frame(maxWidth: .infinity) // Ajusta el ancho explícitamente
                    .padding(.trailing, 10)
            } //FIN ZSTACK PROGRESSVIEW
            
        }
        
    }
}
