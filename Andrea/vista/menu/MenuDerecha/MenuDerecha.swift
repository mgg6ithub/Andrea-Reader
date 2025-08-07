

import SwiftUI


struct MenuDerecha: View {
    
    @EnvironmentObject var appEstado: AppEstado
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            ZStack {
                Button(action: {
                    
                }) {
                    PopOutCollectionsView() { isExpandable in
                        Image("menu-historial")
                            .font(.system(size: appEstado.constantes.iconSize * 1.03))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(appEstado.constantes.iconColor.gradient)
                            .contentTransition(.symbolEffect(.replace))
                            .fontWeight(appEstado.constantes.iconWeight)
                            .padding(.trailing, 2.5)
                    } content: { isExpandable, cerrarMenu in
                        MenuHistorial()
                    }
                }
            }
            
        }
        .frame(maxWidth: 70)
        
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
