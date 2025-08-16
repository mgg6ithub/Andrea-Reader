
import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
        .environmentObject(MenuEstado())
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


struct Punto: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    // --- CONSTANTES ---
    var anchoIndicePuntos: CGFloat = 77.5
    var anchoTexto: CGFloat = 72.5
    
    // --- PARAMETROS ---
    let index: Int
    let section: String
    @Binding var selectedSection: String?
    @Binding var isPressed: Bool
    let distPoints: CGFloat
    
    // --- VARIABLES CALCULADAS ---
    var sections: [String] { menuEstado.sections }
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: ConstantesPorDefecto().paddingCorto - 2) {
                Text(menuEstado.sectionTitle(section))
                    .font(.system(size: ap.constantes.smallTitleSize))
                    .foregroundColor(selectedSection == section ? ap.temaActual.textColor : ap.temaActual.secondaryText)
                    .frame(width: (anchoTexto * ap.constantes.scaleFactor) - 10, alignment: .leading)
                
                Circle()
                    .fill(selectedSection == section ? ap.colorActual : .gray)
                    .shadow(
                        color: selectedSection == section ? ap.colorActual : .gray,
                        radius: ((selectedSection == section ? 6 : 0))
                    )
                    .frame(width: 15, height: 15)
                    .overlay( //ANIMACION AVANZADA AL HACER CLICK
                        RoundedRectangle(cornerRadius: 10)
                            .stroke((selectedSection == section && isPressed) ? ap.colorActual : Color.clear, lineWidth: 4)
                                    .animation(.easeInOut(duration: 0.3), value: isPressed)
                            )
                    .shadow(color: (selectedSection == section && isPressed) ? ap.colorActual.opacity(0.3) : .clear, radius: (selectedSection == section && isPressed) ? 10 : 0, x: 0, y: (selectedSection == section && isPressed) ? 5 : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isPressed)
                    .frame(alignment: .trailing)
            }
            
            if index < sections.count - 1 {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 2, height: distPoints, alignment: .trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(maxWidth: (anchoIndicePuntos * ap.constantes.scaleFactor) - 1.5)
        
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
