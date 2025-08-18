

import SwiftUI

extension View {
    
    func fondoRectangular(esOscuro: Bool, shadow: Bool) -> some View {
        self.padding(15) // margen interno
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
            )
            .shadow(
                color: esOscuro ? .black.opacity(0.6) : .black.opacity(0.225),
                radius: shadow ? 10 : 0, x: 0, y: shadow ? 5 : 0
            )
            .padding(.bottom, 15)
    }
    
}

extension View {
    func capaTituloPrincipal(s: CGFloat, c: Color, pH: CGFloat, pW: CGFloat) -> some View {
        self.bold()
            .font(.system(size: s * 1.4))
            .foregroundColor(c)
            .padding(.bottom, pH + 5) // 25
            .padding(.trailing, pW)
    }
}

extension View {
    func capaDescripcion(
        s: CGFloat,
        c: Color,
        pH: CGFloat,
        pW: CGFloat,
        b: Bool? = nil
    ) -> some View {
        self.font(.system(size: s * 1.08))
            .foregroundColor(c)
            .padding(.bottom, pH)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight((b ?? false) ? .bold : .regular) // 👈 condicional
    }
}


struct CirculoActivoVista: View {
    
    let isSection: Bool
    let nombre: String
    let titleSize: CGFloat
    let color: Color
    
    var body: some View {
        HStack {
            CirculoActivo(isSection: isSection, color: color)
            
            Text(nombre)
                .font(.system(size: titleSize))
                .foregroundColor(.gray)
                .frame(alignment: .leading)
            Spacer()
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

struct ContenidoAjustes: View {

    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado

    // --- PARÁMETROS ---
    var sections: [String]
    @Binding var selectedSection: String?
    let paddingHorizontal: CGFloat
    @Binding var sectionOffsets: [String: CGFloat]
    @Binding var isUserInteracting: Bool
    @Binding var scrollProxy: ScrollViewProxy?
    @Binding var haHechoScroll: Bool
    @Binding var scrollInicial: CGFloat?

    // --- ESTADO ---
    @State private var show = false
    @State private var isScrollInitialized = false

    // Guardamos el rango visible (minY...maxY) de cada sección en coordenadas globales
    @State private var sectionRanges: [String: ClosedRange<CGFloat>] = [:]

    // --- CÁLCULOS ---
    private var const: Constantes { ap.constantes }
    var constanteResizable: CGFloat {
        ap.resolucionLogica == .small ? ap.constantes.scaleFactor * 0.8 : ap.constantes.scaleFactor
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    // Cabecera
                    HStack(spacing: 0) {
                        if ap.resolucionLogica != .small {
                            Image("libro-ajustes")
                                .resizable()
                                .frame(width: 160 * constanteResizable, height: 160 * constanteResizable)
                                .aspectRatio(contentMode: .fit)
                                .aparicionStiffness(show: $show)
                        }

                        Text("Aplica ajustes globales, personalizando la apariencia y funcionalidad de la aplicación. Ajusta el tema, los colores y modifica las opciones según tus preferencias.")
                            .font(.system(size: ap.constantes.titleSize))
                            .foregroundColor(ap.temaResuelto.colorContrario)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 10)
                            .padding(.bottom, 10)
                    }
                    .padding(.leading, ap.resolucionLogica == .small ? 0 : const.padding25)
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        scrollInicial = geo.frame(in: .global).minY
                                        haHechoScroll = false
                                        isScrollInitialized = true
                                    }
                                }
                                .onChange(of: geo.frame(in: .global).minY) { newValue in
                                    handleScrollChange(newY: newValue)
                                }
                        }
                    )
                    .onDisappear { isScrollInitialized = false }

                    // Cuerpo de secciones
                    ForEach(sections, id: \.self) { section in
                        VStack(alignment: .trailing, spacing: 0) {
                            // (ancla invisible, si lo necesitas)
                            GeometryReader { geo in
                                Color.clear
                            }
                            .frame(height: 0)

                            Group {
                                switch section {
                                case "TemaPrincipal":
                                    AjustesTema(isSection: selectedSection == section)
                                    DividerPersonalizado(paddingHorizontal: 0).padding(.vertical, 30)

                                case "ColorPrincipal":
                                    AjustesColor(isSection: selectedSection == section)
                                    DividerPersonalizado(paddingHorizontal: 0).padding(.vertical, 30)

                                case "SistemaArchivos":
                                    AjustesSistemaColecciones(isSection: selectedSection == section)
                                    DividerPersonalizado(paddingHorizontal: 0).padding(.vertical, 30)

                                case "Rendimiento":
                                    Rendimiento(isSection: selectedSection == section)
                                    DividerPersonalizado(paddingHorizontal: 0).padding(.vertical, 30)

                                case "AjustesMenu":
                                    AjustesMenu(isSection: selectedSection == section)
                                    DividerPersonalizado(paddingHorizontal: 0).padding(.vertical, 30)

                                case "AjustesHistorial":
                                    AjustesHistorial(isSection: selectedSection == section)
                                    DividerPersonalizado(paddingHorizontal: 0).padding(.vertical, 30)

                                case "AjustesLibreria":
                                    AjustesLibreria(isSection: selectedSection == section)
                                    DividerPersonalizado(paddingHorizontal: 0).padding(.vertical, 30)
                                    
                                case "AjustesVisualizacion":
                                    AjustesLibreria(isSection: selectedSection == section)

                                default:
                                    EmptyView()
                                }
                            }
                            .id(section)
                        }
                        .padding(.leading, ap.resolucionLogica == .small ? 0 : const.padding35)
                        .background(
                            GeometryReader { geo in
                                // Trackeamos el rango visible de la sección en global
                                let frame = geo.frame(in: .global)
                                Color.clear
                                    .onChange(of: frame.minY) { _ in
                                        sectionOffsets[section] = frame.minY          // compatibilidad con tu diccionario actual
                                        sectionRanges[section] = frame.minY...frame.maxY
                                        if !isUserInteracting { updateActiveSection() }

                                        // Si estás muy arriba, forzamos la primera
                                        if !isUserInteracting, frame.minY > 100 {
                                            selectedSection = sections.first
                                        }
                                    }
                                    .onAppear {
                                        sectionOffsets[section] = frame.minY
                                        sectionRanges[section] = frame.minY...frame.maxY
                                    }
                            }
                        )
                    }
                }
            }
            .scrollTargetLayout()
            .scrollIndicators(.hidden)
            .frame(maxHeight: .infinity)
            .onAppear {
                self.scrollProxy = proxy
                if selectedSection == nil { selectedSection = sections.first }
            }
        }
    }

    // MARK: - Lógica de scroll cabecera
    private func handleScrollChange(newY: CGFloat) {
        guard isScrollInitialized, let inicial = scrollInicial else { return }
        let diferencia = inicial - newY
        let tolerancia: CGFloat = 20
        let hayScrollHaciaAbajo = diferencia > tolerancia
        if hayScrollHaciaAbajo != haHechoScroll {
            haHechoScroll = hayScrollHaciaAbajo
        }
    }

    // MARK: - Lógica de activación por rango + histeresis
    private func updateActiveSection() {
        guard !isUserInteracting else { return }

        let centerY = UIScreen.main.bounds.height / 2
        let margin: CGFloat = 60 // histeresis

        // 1) Si el centro sigue dentro del rango ampliado de la actual, no cambiar
        if let current = selectedSection,
           let range = sectionRanges[current],
           expanded(range, by: margin).contains(centerY) {
            return
        }

        // 2) Si el centro cae dentro de alguna sección, usar esa
        if let inRange = sectionRanges.first(where: { $0.value.contains(centerY) })?.key {
            if selectedSection != inRange { selectedSection = inRange }
            return
        }

        // 3) Si no cae dentro de ninguna (entre secciones), elegir la más cercana al centro
        if let closest = sectionRanges.min(by: {
            distance(centerY, to: $0.value) < distance(centerY, to: $1.value)
        })?.key {
            if selectedSection != closest { selectedSection = closest }
        }
    }

    // Distancia de un punto a un rango (0 si está dentro)
    private func distance(_ y: CGFloat, to r: ClosedRange<CGFloat>) -> CGFloat {
        if y < r.lowerBound { return r.lowerBound - y }
        if y > r.upperBound { return y - r.upperBound }
        return 0
    }

    // Rango expandido (histeresis)
    private func expanded(_ r: ClosedRange<CGFloat>, by m: CGFloat) -> ClosedRange<CGFloat> {
        (r.lowerBound - m)...(r.upperBound + m)
    }
}

