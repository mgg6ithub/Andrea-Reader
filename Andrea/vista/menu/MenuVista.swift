import SwiftUI

struct MenuVista: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @State private var isSettingsPressed = false
    
    var dynamicIconColor: Color {
        appEstado.temaActual.iconColor
    }
    
    @State private var isExpanded = false // Animación de la línea del menú
    @State private var menuCentroWidth: CGFloat = 0 // Ancho dinámico del menú central
    
    private var horizontalPadding: CGFloat = ConstantesPorDefecto().horizontalPadding
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            ZStack {
            
                HStack {
                    
                    MenuIzquierda()
//                        .padding(.horizontal, horizontalPadding)
                                           
                    Spacer()
                    
                    MenuDerecha()
//                        .padding(.horizontal, horizontalPadding)
                                            
                }
                
                GeometryReader { geo in
                    MenuCentro()
                        .frame(maxWidth: .infinity) // Ocupa todo el ancho disponible
//                        .padding(.horizontal, horizontalPadding)
                        
                        .onAppear {
                            menuCentroWidth = geo.size.width
                        }
                        .offset(y: -1.0)
                }
            }
//            .offset(y: 2.5)
//            .frame(maxWidth: .infinity, alignment: .center)
            
//            HStack {
//                Spacer()
//                Rectangle()
//                    .fill(Color(UIColor.systemGray4))
//                    .frame(width: isExpanded ? menuCentroWidth + 40 : 0, height: 1) // Ajusta el ancho de la línea
//                    .animation(appEstado.isFirstTimeLaunch ? .easeInOut(duration: 2.0) : .none, value: isExpanded)
//                Spacer()
//            }
//            .onAppear {
//                if appEstado.isFirstTimeLaunch {
//                    isExpanded = true // Activa la animación
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Tras animación, desactiva el flag
//                        appEstado.isFirstTimeLaunch = false
//                    }
//                } else {
//                    isExpanded = true // Muestra directamente la línea con ancho completo
//                }
//            }
//            Divider()
        }
//        .border(.red)
        .frame(height: 25)
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { self.appEstado.menuCargado = true }
//        }
//        .padding(.horizontal, 25)
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

