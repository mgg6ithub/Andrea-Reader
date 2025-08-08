
import SwiftUI

struct NotificacionLog: Identifiable, Equatable {
    let id = UUID()
    let mensaje: String
    let icono: String
    let color: Color
}

struct NotificacionLogVista: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let logMensaje: String
    let icono: String
    let color: Color
    
    var fechaHoraFormateada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.gradient.opacity(0.15))
        
            HStack {
                ZStack {
                    Image(icono)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(color, .gray.opacity(0.6))
                }
                .frame(width: 30)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    
                    Text(logMensaje)
                        .font(.headline)
                        .lineLimit(logMensaje.count > 40 ? 2 : 1)
                        .minimumScaleFactor(0.7)
                    
                    Text("\(fechaHoraFormateada)")
                        .font(.caption)
                        .foregroundColor(ap.temaActual.secondaryText)
                }
                
            }
            .padding(.horizontal, 15)
        }
    }
}
