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
        VStack(alignment: .center, spacing: 10) {
            
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
                }
            }
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
        }
        .frame(height: 25)
//        .padding(.horizontal, 25)
    }
}


