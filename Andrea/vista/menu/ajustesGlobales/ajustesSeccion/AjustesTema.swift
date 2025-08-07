
import SwiftUI

//struct AndreaAppView_Preview1: PreviewProvider {
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
//
//        return AndreaAppView()
//            .environmentObject(ap)
//            .environmentObject(me)
//            .environmentObject(pc)
//    }
//}


struct AjustesTema: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    
    //VARIABLES PARA EL TEMA
    @State private var isThemeExpanded: Bool = false
    
    var isSection: Bool
    
    //FIJAS
    
    //Subtitulo
    private let cpd = ConstantesPorDefecto()
    private var subTitle: CGFloat { appEstado.constantes.subTitleSize }
    
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * appEstado.constantes.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * appEstado.constantes.scaleFactor} // 20
    private var altoRectanguloFondo: CGFloat {menuEstado.altoRectanguloFondo * appEstado.constantes.scaleFactor}
    
    private var altoRectanguloPeke: CGFloat {
        if appEstado.constantes.resLog == .small {
            altoRectanguloFondo * 0.9
        } else {
            altoRectanguloFondo * 0.85
        }
    }
    
    private var paddingCorto: CGFloat { cpd.paddingCorto }
    
    //VARIABLES
    private var iconSize: CGFloat  { appEstado.constantes.iconSize }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
                
            Text("Tema principal") //TITULO
                .font(.headline)
                .foregroundColor(appEstado.temaActual.colorContrario)
                .padding(.bottom, paddingVertical + 5) // 25
                .padding(.trailing, paddingHorizontal)
            
            Text("Los temas son combinaciones de colores que se aplican globalmente a toda la interfaz. Los temas claro y oscuro son los mas usados.")
                .font(.subheadline)
                .foregroundColor(appEstado.temaActual.secondaryText)
                .frame(width: .infinity, alignment: .leading)
                .padding(.bottom, paddingVertical) // 20
            
            HStack {
                
                CirculoActivo(isSection: isSection)
                
                Text("Selecciona un tema para establecerlo como principal.")
                    .font(.caption2)
                    .foregroundColor(appEstado.temaActual.secondaryText)
                    .frame(alignment: .leading)
                
                Spacer()
            }
            .padding(.bottom, paddingCorto)
                
            // Contenedor del rectángulo
            ZStack {
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.2))
                    .frame(
                        height: altoRectanguloFondo
                    )
                    .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
                
                HStack(spacing: 0) {
                    
                    RectangleFormView<EnumTemas>(
                        titulo: "Claro",
                        icono: "sun.max.fill",
                        coloresIcono: [Color.yellow],
                        opcionSeleccionada: .light,
                        opcionActual: $appEstado.temaActual
                    )
                    
                    RectangleFormView<EnumTemas>(
                        titulo: "Oscuro",
                        icono: "moon.fill",
                        coloresIcono: [Color.blue],
                        opcionSeleccionada: .dark,
                        opcionActual: $appEstado.temaActual
                    )
                    
                    RectangleFormView<EnumTemas>(
                        titulo: "Dia/Noche",
                        icono: "custom.dayNight",
                        coloresIcono: [Color.white, Color.white],
                        opcionSeleccionada: .dayNight,
                        opcionActual: $appEstado.temaActual,
                        isCustomImage: true
                    )
                }
            } //fin zstack tema
            .padding(.bottom, paddingVertical)
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                   
                    if appEstado.animaciones {
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                            self.isThemeExpanded.toggle()
                        }
                    }
                    else {
                        self.isThemeExpanded.toggle()
                    }
                    
                }) {
                    HStack(spacing: paddingCorto) {
                        Text("Más temas")
                            .font(.system(size: subTitle))
                            .foregroundColor(appEstado.temaActual.colorContrario)
                            .bold()
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: iconSize * 0.65))
                            .foregroundColor(appEstado.temaActual.colorContrario)
                            .bold()
                            .rotationEffect(.degrees(isThemeExpanded ? 90 : 0))
                            .animation(appEstado.animaciones ? .interpolatingSpring(stiffness: 400, damping: 25) : .none, value: isThemeExpanded)
                        
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, paddingCorto)
                
                // 🎨 ANIMACIÓN MEJORADA DEL CONTENEDOR
                if isThemeExpanded {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: altoRectanguloPeke)
                            .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
                        
                        //MAS TEMAS CON ANIMACIÓN INDIVIDUAL
                        HStack(spacing: 0) {
                            MasTemas(tema: .green, color1: .teal, color2: .green)
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    appEstado.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.1) :
                                        .none,
                                    value: isThemeExpanded
                                )
                            
                            MasTemas(tema: .red, color1: .red.opacity(0.6), color2: .red.opacity(0.9))
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    appEstado.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.2) :
                                        .none,
                                    value: isThemeExpanded
                                )
                            
                            // Azul claro a azul oscuro
                            MasTemas(tema: .blue, color1: .blue.opacity(0.5), color2: .blue.opacity(0.8))
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    appEstado.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.3) :
                                        .none,
                                    value: isThemeExpanded
                                )
                            
                            // Naranja claro a naranja oscuro
                            MasTemas(tema: .orange, color1: .orange.opacity(0.4), color2: .orange.opacity(0.7))
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    appEstado.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.4) :
                                        .none,
                                    value: isThemeExpanded
                                )
                        }
                    }
                    .padding(.bottom, paddingVertical)
                    .scaleEffect(isThemeExpanded ? 1 : 0.95)
                    .opacity(isThemeExpanded ? 1 : 0)
                    .offset(y: isThemeExpanded ? 0 : -5)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity).combined(with: .offset(y: -5)),
                        removal: .scale(scale: 0.95).combined(with: .opacity).combined(with: .offset(y: -5))
                    ))
                    .animation(
                        appEstado.animaciones ?
                            .interpolatingSpring(stiffness: 250, damping: 25) :
                            .none,
                        value: isThemeExpanded
                    )
                }
            }
            
        } //fin vstack tema
        .padding(.horizontal, appEstado.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
        .padding(.top, 10)
    }
}
