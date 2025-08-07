
import SwiftUI
import Foundation

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
////        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
////        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
//        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
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

struct MenuHistorial: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    private var hPadding: CGFloat { ConstantesPorDefecto().horizontalPadding }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("custom-reloj")
                    .font(.system(size: ap.constantes.iconSize * 0.5))
                
                HStack(spacing: 3) {
                    Text("Indexado desde \"mi ipad\" hace")
                        .font(.system(size: ap.constantes.subTitleSize * 0.85))
                    
                    Text("2.13 s")
                        .font(.system(size: ap.constantes.subTitleSize * 0.85))
                        .bold()
                }
            }
            .padding(.leading, 15)
            .padding(.top, 15)
            .padding(.trailing, 15)
            
            VStack(alignment: .center, spacing: 15) {
                ForEach(me.historialNotiticaciones) { noti in
                    NotificacionLogVista(logMensaje: noti.mensaje, icono: noti.icono, color: noti.color)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    me.historialNotiticaciones.removeAll { $0.id == noti.id }
                                }
                            } label: {
                                Label("Borrar", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.vertical, 20)
            
        }
    }

    
}
