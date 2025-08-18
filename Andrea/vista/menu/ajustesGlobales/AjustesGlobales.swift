
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
    
    var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Text("Ajustes generales")
                    .font(.system(size: ap.constantes.titleSize * 1.7, weight: .bold))
                    .foregroundColor(ap.temaActual.colorContrario)
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
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 2.5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
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
            .padding(.horizontal, const.padding25) // 25
            .frame(
                maxHeight: .infinity,
                alignment: .center
            )
            .background(ap.temaActual.backgroundColor)
            .animation(.easeInOut, value: ap.temaActual)
    }
    
}


struct DividerPersonalizado: View {
    
    @EnvironmentObject var ap: AppEstado
    var paddingHorizontal: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(height: 1.1)
            .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2)
            .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
    }
}


//// MARK: - Punto
//struct Punto: View {
//    @EnvironmentObject var ap: AppEstado
//    @EnvironmentObject var menuEstado: MenuEstado
//
//    // Anchos de la columna izquierda
//    // railWidth es la columna del “rail” (línea + puntos)
//    // labelWidth es la columna donde va el título de la sección
//    var railWidth: CGFloat = 28
//    var labelWidth: CGFloat = 140
//
//    // Parámetros
//    let index: Int
//    let section: String
//    @Binding var selectedSection: String?
//    @Binding var isPressed: Bool
//    let rowHeight: CGFloat     // altura por fila (calculada en IndicesVertical)
//    let dotDiameter: CGFloat   // diámetro del punto
//
//    var body: some View {
//        HStack(spacing: 12) {
//            // Columna rail (el punto se centra en el rail)
//            ZStack {
//                // El trazo vertical lo pinta IndicesVertical de fondo;
//                // aquí solo el punto
//                Circle()
//                    .fill(selectedSection == section ? ap.colorActual : .gray)
//                    .frame(width: dotDiameter, height: dotDiameter)
//                    .shadow(color: selectedSection == section ? ap.colorActual : .gray, radius: selectedSection == section ? 6 : 0)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke((selectedSection == section && isPressed) ? ap.colorActual : .clear, lineWidth: 4)
//                            .animation(.easeInOut(duration: 0.3), value: isPressed)
//                    )
//            }
//            .frame(width: railWidth, alignment: .center) // punto centrado en el rail
//
//            // Título a la DERECHA del punto
//            Text(menuEstado.sectionTitle(section))
//                .font(.system(size: ap.constantes.smallTitleSize))
//                .foregroundColor(selectedSection == section ? ap.temaActual.textColor : ap.temaActual.secondaryText)
//                .frame(width: labelWidth, alignment: .leading)
//
//            Spacer(minLength: 0)
//        }
//        .frame(height: rowHeight)
//    }
//}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
