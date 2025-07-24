import SwiftUI

struct MenuVista: View {

    @State private var menuCentroWidth: CGFloat = 0 // Ancho dinámico del menú central
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            ZStack {
                HStack {
                    MenuIzquierda()
                    Spacer()
                    MenuDerecha()
                }
                
                GeometryReader { geo in
                    MenuCentro()
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            menuCentroWidth = geo.size.width
                        }
                        .offset(y: 1.0)
                }
            }
        }
        .frame(height: 25)
    }
}

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
//        let appStatePreview = AppEstado()   // Reemplaza con inicialización adecuada
////        let appEstadoPreview = AppEstado() // Reemplaza con inicialización adecuada
////        let appEstadoPreview = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let appEstadoPreview = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
////        let appEstadoPreview = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let appEstadoPreview = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let appEstadoPreview = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let menuEstadoPreview = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.getPilaColeccionesSingleton
//
//        return AndreaAppView()
//            .environmentObject(appStatePreview)
//            .environmentObject(appEstadoPreview)
//            .environmentObject(menuEstadoPreview)
//            .environmentObject(pc)
//    }
//}

