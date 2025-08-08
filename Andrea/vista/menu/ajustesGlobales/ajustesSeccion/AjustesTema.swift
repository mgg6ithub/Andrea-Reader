
import SwiftUI

struct AjustesTema: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    // --- PARAMETROS ---
    var isSection: Bool
    
    // --- VARIABLES ESTADO ---
    @State private var isThemeExpanded: Bool = false
    
    // --- VARIABLES CALCULADAS ---
    var const: Constantes { ap.constantes }
    private let cpd = ConstantesPorDefecto()
    
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * const.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * const.scaleFactor} // 20
    private var paddingCorto: CGFloat { cpd.paddingCorto }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
                
            Text("Tema principal") //TITULO
                .font(.headline)
                .foregroundColor(ap.temaActual.colorContrario)
                .padding(.bottom, paddingVertical + 5) // 25
                .padding(.trailing, paddingHorizontal)
            
            Text("Los temas son combinaciones de colores que se aplican globalmente a toda la interfaz. Los temas claro y oscuro son los mas usados.")
                .font(.subheadline)
                .foregroundColor(ap.temaActual.secondaryText)
                .frame(width: .infinity, alignment: .leading)
                .padding(.bottom, paddingVertical) // 20
            
            HStack {
                
                CirculoActivo(isSection: isSection)
                
                Text("Selecciona un tema para establecerlo como principal.")
                    .font(.caption2)
                    .foregroundColor(ap.temaActual.secondaryText)
                    .frame(alignment: .leading)
                
                Spacer()
            }
            .padding(.bottom, paddingCorto)
                
            // Contenedor del rectángulo
            ZStack {
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.2))
                    .frame(
                        height: const.altoRectanguloFondo
                    )
                    .shadow(color: ap.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: ap.shadows ? 10 : 0, x: 0, y: ap.shadows ? 5 : 0)
                
                HStack(spacing: 0) {
                    
                    RectangleFormView<EnumTemas>(
                        titulo: "Claro",
                        icono: "sun.max.fill",
                        coloresIcono: [Color.yellow],
                        opcionSeleccionada: .light,
                        opcionActual: $ap.temaActual
                    )
                    
                    RectangleFormView<EnumTemas>(
                        titulo: "Oscuro",
                        icono: "moon.fill",
                        coloresIcono: [Color.blue],
                        opcionSeleccionada: .dark,
                        opcionActual: $ap.temaActual
                    )
                    
                    RectangleFormView<EnumTemas>(
                        titulo: "Dia/Noche",
                        icono: "custom.dayNight",
                        coloresIcono: [Color.white, Color.white],
                        opcionSeleccionada: .dayNight,
                        opcionActual: $ap.temaActual,
                        isCustomImage: true
                    )
                }
            } //fin zstack tema
            .padding(.bottom, paddingVertical)
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                   
                    if ap.animaciones {
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
                            .font(.system(size: const.subTitleSize))
                            .foregroundColor(ap.temaActual.colorContrario)
                            .bold()
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: const.iconSize * 0.65))
                            .foregroundColor(ap.temaActual.colorContrario)
                            .bold()
                            .rotationEffect(.degrees(isThemeExpanded ? 90 : 0))
                            .animation(ap.animaciones ? .interpolatingSpring(stiffness: 400, damping: 25) : .none, value: isThemeExpanded)
                        
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
                            .frame(height: const.altoRectanguloPeke * 0.9)
                            .shadow(color: ap.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: ap.shadows ? 10 : 0, x: 0, y: ap.shadows ? 5 : 0)
                        
                        //MAS TEMAS CON ANIMACIÓN INDIVIDUAL
                        HStack(spacing: 0) {
                            MasTemas(tema: .green, color1: .teal, color2: .green, opcionSeleccionada: .green, opcionActual: $ap.temaActual)
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    ap.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.1) :
                                        .none,
                                    value: isThemeExpanded
                                )
                            
                            MasTemas(tema: .red, color1: .red.opacity(0.6), color2: .red.opacity(0.9), opcionSeleccionada: .red, opcionActual: $ap.temaActual)
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    ap.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.2) :
                                        .none,
                                    value: isThemeExpanded
                                )
                            
                            // Azul claro a azul oscuro
                            MasTemas(tema: .blue, color1: .blue.opacity(0.5), color2: .blue.opacity(0.8), opcionSeleccionada: .blue, opcionActual: $ap.temaActual)
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    ap.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.3) :
                                        .none,
                                    value: isThemeExpanded
                                )
                            
                            // Naranja claro a naranja oscuro
                            MasTemas(tema: .orange, color1: .orange.opacity(0.4), color2: .orange.opacity(0.7), opcionSeleccionada: .orange, opcionActual: $ap.temaActual)
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    ap.animaciones ?
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
                        ap.animaciones ?
                            .interpolatingSpring(stiffness: 250, damping: 25) :
                            .none,
                        value: isThemeExpanded
                    )
                }
            }
            
        } //fin vstack tema
        .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
        .padding(.top, 10)
    }
}
