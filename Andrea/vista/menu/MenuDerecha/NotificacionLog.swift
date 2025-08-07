

import SwiftUI

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
//        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
////        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
////        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let me = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.preview
//
//        return AndreaAppView()
//            .environmentObject(ap)
//            .environmentObject(me)
//            .environmentObject(pc)
//    }
//}

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
//                .padding(.horizontal, 15)
        
            HStack {
                ZStack {
                    Image(icono)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(color, ap.temaActual.colorContrario)
                }
                .frame(width: 30)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    
                    Text(logMensaje)
                        .font(.system(size: ap.constantes.subTitleSize * 0.85))
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
