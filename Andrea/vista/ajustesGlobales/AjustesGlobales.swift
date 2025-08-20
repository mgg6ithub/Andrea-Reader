
import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

extension AppEstado {
    static var preview: AppEstado {
//        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
//        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
//        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
        ap.temaActual = .dark
        ap.sistemaArchivos = .tradicional
        ap.ajusteColorSeleccionado = .colorPersonalizado
        ap.colorPersonalizadoActual = .blue
        ap.shadows = true
        return ap
    }
}

extension MenuEstado {
    static var preview: MenuEstado {
        let me = MenuEstado()
        me.modoBarraEstado = .on
        me.statusBarTopInsetBaseline = 0
        me.iconoMenuLateral = true
        me.iconoFlechaAtras = false
        me.iconoSeleccionMultiple = true
        me.iconoNotificaciones = true
        me.dobleColor = false
        me.colorGris = false
        me.colorAutomatico = true
        me.iconSize = 24
        me.fuente = .light
        me.fondoMenu = true
        me.colorFondoMenu = .transparente
        return me
    }
}


struct AjustesGlobales: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado

    // --- VARIABLES ESTADO ---
    @State private var isPressed: Bool = false
    @State private var selectedSection: String? = nil
    @State private var isUserInteracting = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var sectionOffsets: [String: CGFloat] = [:]
    @State private var haHechoScroll: Bool = false
    @State private var scrollInicial: CGFloat? = nil
    
    // --- VARIABLES CALCULADAS ---
    var sections: [String] { menuEstado.sections }
    private let cpd: ConstantesPorDefecto = ConstantesPorDefecto()
    private var const: Constantes { ap.constantes }
    private var tema: EnumTemas { ap.temaResuelto }
    
    var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Text("Ajustes de la aplicación")
                    .font(.system(size: ap.constantes.titleSize * 1.7, weight: .bold))
                    .foregroundColor(tema.tituloColor)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, cpd.padding15)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                if ap.resolucionLogica == .small {
                    IndicesHorizontal(sections: sections, selectedSection: $selectedSection, scrollProxy: $scrollProxy)
                        .padding(.bottom, 10)
                }
                
                if haHechoScroll {
                    ZStack {
                        Text("Tu aplicación, a tu manera.")
                            .font(.system(size: ap.constantes.subTitleSize * 0.7))
                            .foregroundColor(tema.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .offset(y: -9)
                        
                        Rectangle()
                            .fill(ap.temaResuelto.lineaColor)
                            .frame(height: 2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                GeometryReader { hStackGeo in
                    if ap.resolucionLogica == .medium || ap.resolucionLogica == .big {
                        HStack(spacing: 0) { //Cambiar por VStack si resolucionLogica es .small y el menu de los indices por el horizontal para ponerlo encima
                            IndicesVertical(isPressed: $isPressed, selectedSection: $selectedSection, isUserInteracting: $isUserInteracting, scrollProxy: $scrollProxy, sections: sections)
                            ContenidoAjustes(sections: sections, selectedSection: $selectedSection, paddingHorizontal: cpd.padding15, sectionOffsets: $sectionOffsets, isUserInteracting: $isUserInteracting, scrollProxy: $scrollProxy, haHechoScroll: $haHechoScroll, scrollInicial: $scrollInicial)
                        }//gin hstack spacing 0
                        .frame(height: hStackGeo.size.height)
                    } else if ap.resolucionLogica == .small {
                        ContenidoAjustes(sections: sections, selectedSection: $selectedSection, paddingHorizontal: cpd.padding15, sectionOffsets: $sectionOffsets, isUserInteracting: $isUserInteracting, scrollProxy: $scrollProxy, haHechoScroll: $haHechoScroll, scrollInicial: $scrollInicial)
                    }
                } //fin geometry hStackGeo
                
            } //FIN VSTACK GENERAL
            .onAppear {
                selectedSection = ap.seccionSeleccionada
            }
            .padding(.horizontal, const.padding25) // 25
            .frame(
                maxHeight: .infinity,
                alignment: .center
            )
            .background(ap.temaResuelto.backgroundGradient)
            .animation(.easeInOut, value: tema)
    }
}

struct TituloInformacion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let titulo: String
    let isSection: Bool
    
    private var tema: EnumTemas { ap.temaResuelto }
    var const: Constantes { ap.constantes }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.bubble")
                .foregroundColor(tema.colorContrario)
                .font(.system(size: const.iconSize * 0.55,
                                  weight: isSection ? .bold : .regular))
            Text(titulo)
                .capaDescripcion(
                    s: const.descripcionAjustes,
                    c: tema.colorContrario,
                    pH: 0,
                    pW: 0,
                    b: true
                )
                .underline(isSection, color: ap.colorActual)
        }
        .padding(.bottom, 6)
    }
}

struct DividerPersonalizado: View {
    
    @EnvironmentObject var ap: AppEstado
    var paddingHorizontal: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(ap.temaResuelto.lineaColor)
            .frame(height: 1.1)
            .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2)
            .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
    }
}

struct DividerDentroSeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    var pH: CGFloat
    var pV: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(ap.temaResuelto.lineaColor)
            .frame(height: 0.5)
            .padding(.horizontal, pH)
            .padding(.vertical, pV)
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
