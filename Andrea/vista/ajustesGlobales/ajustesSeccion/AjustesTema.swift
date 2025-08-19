
import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

struct AjustesTema: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    // --- PARAMETROS ---
    var isSection: Bool
    
    // --- VARIABLES ESTADO ---
    @State private var isThemeExpanded: Bool = false
    
    private var isExtraThemeSelected: Bool {
        [.blue, .green, .red, .orange].contains(ap.temaActual)
    }

    private var shouldShowMoreThemes: Bool {
        isThemeExpanded || isExtraThemeSelected
    }
    
    // --- VARIABLES CALCULADAS ---
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Tema principal") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: tema.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Los temas son combinaciones de colores que se aplican globalmente a toda la interfaz. Los temas claro y oscuro son los mas usados.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            Text("Información del tema seleccionado")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.colorContrario, pH: 0, pW: 0, b: true)
                .padding(.bottom, 15)
            
            Text(ap.temaActual.descripcionTema)
                .capaDescripcion(s: const.descripcionAjustes * 0.8, c: tema.secondaryText, pH: 0, pW: 0)
                .padding(.bottom, 20)
            
            CirculoActivoVista(isSection: isSection, nombre: "Selecciona un tema", titleSize: const.descripcionAjustes, color: ap.colorActual)
                
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
                    titulo: "Sistema",
                    icono: "yy",
                    coloresIcono: [Color.white, Color.white],
                    opcionSeleccionada: .sistema,
                    opcionActual: $ap.temaActual,
                    isCustomImage: true,
                    esSistemaIcono: ap.dispositivoActual.iconoDispositivo
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
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
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
                    HStack(spacing: 5) {
                        Text("Más temas")
                            .font(.system(size: const.descripcionAjustes))
                            .foregroundColor(tema.colorContrario)
                            .bold()
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: const.iconSize * 0.45))
                            .foregroundColor(tema.colorContrario)
                            .bold()
                            .rotationEffect(.degrees(isThemeExpanded ? 90 : 0))
                            .animation(ap.animaciones ? .interpolatingSpring(stiffness: 400, damping: 25) : .none, value: isThemeExpanded)
                        
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, isThemeExpanded ? const.padding5 : 0)

                if isThemeExpanded {
                    ZStack(alignment: .leading) {
                        //MAS TEMAS CON ANIMACIÓN INDIVIDUAL
                        HStack(spacing: 0) {
                            MasTemas(tema: .green, color1: .teal, color2: .green, opcionSeleccionada: .green, opcionActual: $ap.temaActual)
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    ap.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.3) :
                                        .none,
                                    value: isThemeExpanded
                                )
                            
                            MasTemas(tema: .red, color1: .purple, color2: .red, opcionSeleccionada: .red, opcionActual: $ap.temaActual)
                                .scaleEffect(isThemeExpanded ? 1 : 0.8)
                                .opacity(isThemeExpanded ? 1 : 0)
                                .offset(y: isThemeExpanded ? 0 : 10)
                                .animation(
                                    ap.animaciones ?
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.6) :
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
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(0.9) :
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
                                        .interpolatingSpring(stiffness: 200, damping: 20).delay(1.2) :
                                        .none,
                                    value: isThemeExpanded
                                )
                        }
                    }            
                    .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
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
            
        }
    }
}
