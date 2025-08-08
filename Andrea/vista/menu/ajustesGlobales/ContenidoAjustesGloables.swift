

import SwiftUI

struct ContenidoAjustes: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    
    // --- PARAMETROS ---
    var sections: [String]
    @Binding var selectedSection: String?
    let paddingHorizontal: CGFloat
    @Binding var sectionOffsets: [String: CGFloat]
    @Binding var isUserInteracting: Bool
    @Binding var scrollProxy: ScrollViewProxy?
    @Binding var haHechoScroll: Bool
    @Binding var scrollInicial: CGFloat?

    // --- VARIABLES ESTADO ---
    @State private var show = false
    @State private var isScrollInitialized = false
    
    // --- VARIABLES CALCULADAS ---
    var constanteResizable: CGFloat {
        if ap.resolucionLogica == .small {
            return ap.constantes.scaleFactor * 0.8
        } else {
            return ap.constantes.scaleFactor
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack(spacing: 0) {
                        
                        Image("book4")
                            .resizable()
                            .frame(width: 160 * constanteResizable, height: 160 * constanteResizable)
                            .aspectRatio(contentMode: .fit)
                            .aparicionStiffness(show: $show)
                        
                        Text("Aplica ajustes globales, personalizando la apariencia y funcionalidad de la aplicación. Ajusta el tema, los colores y modifica las opciones según tus preferencias.")
                            .font(.system(size: ap.constantes.titleSize))
                            .multilineTextAlignment(.center)
                        
                    }
                    .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2)
                    // 🎨 ANIMACIÓN MODERNA DE SCROLL
                    .opacity(haHechoScroll ? 0.0 : 1.0)
                    .scaleEffect(haHechoScroll ? 0.95 : 1.0)
                    .offset(y: haHechoScroll ? -10 : 0)
                    .blur(radius: haHechoScroll ? 2 : 0)
                    .animation(.easeInOut(duration: 0.4), value: haHechoScroll)
                    .id("top")
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    // Delay mínimo para asegurar que la vista esté completamente cargada
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        scrollInicial = geo.frame(in: .global).minY
                                        haHechoScroll = false
                                        isScrollInitialized = true
                                    }
                                }
                                .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                                    handleScrollChange(newY: newValue)
                                }
                        }
                    )
                    .onDisappear {
                        isScrollInitialized = false
                    }
                    
                    ForEach(sections, id: \.self) { section in
                        VStack {
                            
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: ViewOffsetKey.self, value: geo.frame(in: .global).minY)
                            }
                            .frame(height: 0)
                            
                            Group {
                                switch section {
                                    case "TemaPrincipal":
                                        AjustesTema(isSection: selectedSection == section)
                                    
                                        DividerPersonalizado(paddingHorizontal: paddingHorizontal)
                                    
                                    case "SistemaArchivos":
                                            AjustesSistemaColecciones(isSection: selectedSection == section)
                                        
                                        DividerPersonalizado(paddingHorizontal: paddingHorizontal)
                                        
                                    case "Rendimiento":
                                        Rendimiento(isSection: selectedSection == section)
                                        
                                        DividerPersonalizado(paddingHorizontal: paddingHorizontal)
                                        
                                    case "AjustesMenu":
                                        AjustesMenu(isSection: selectedSection == section)
                                    
                                    case "AjustesHistorial":
                                        AjustesHistorial()
                                    
                                    default:
                                        EmptyView()
                                }
                            }
                            .id(section)
                        }
                        .background(GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                                    sectionOffsets[section] = newValue
                                    if !isUserInteracting {
                                        updateActiveSection()
                                    }
                                    
                                    if !isUserInteracting, newValue > 100 {
                                        selectedSection = sections.first
                                    }
                                }
                        })
                    }
                }
            }
            .scrollTargetLayout()
            .scrollIndicators(.hidden)
            .frame(maxHeight: .infinity)
            .onAppear {
                self.scrollProxy = proxy
                if selectedSection == nil {
                    selectedSection = sections.first
                }
            }
        }
    }
    
    // Función privada para manejar los cambios de scroll de forma más eficiente
    private func handleScrollChange(newY: CGFloat) {
        // Solo procesar si la inicialización está completa
        guard isScrollInitialized, let inicial = scrollInicial else {
            return
        }
        
        let diferencia = inicial - newY // Cambiamos el abs() para detectar la dirección
        let tolerancia: CGFloat = 20
        
        // Si el valor actual es mayor que el inicial + tolerancia, hay scroll hacia abajo
        let hayScrollHaciaAbajo = diferencia > tolerancia
        
        // Solo actualizamos si hay un cambio real de estado
        if hayScrollHaciaAbajo != haHechoScroll {
            haHechoScroll = hayScrollHaciaAbajo
        }
    }
    
    func updateActiveSection() {
        guard !isUserInteracting else { return }

        let screenCenter = UIScreen.main.bounds.height / 2

        let closest = sectionOffsets.min(by: {
            abs($0.value - screenCenter) < abs($1.value - screenCenter)
        })

        if let closestSection = closest?.key, selectedSection != closestSection {
            selectedSection = closestSection
        }
    }
}
