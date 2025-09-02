
import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

struct IndicesHorizontal: View {
    
    @EnvironmentObject var menuEstado: MenuEstado
    
    var sections: [String]
    
    @Binding var selectedSection: String?
    @Binding var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sections, id: \.self) { section in
                        Button(action: {
                            selectedSection = section
                            withAnimation(.interpolatingSpring(stiffness: 70, damping: 12)) {
                                if section == sections.first {
                                    scrollProxy?.scrollTo("top", anchor: .top)
                                } else {
                                    scrollProxy?.scrollTo(section, anchor: .top)
                                }
                            }
                        }) {
                            Text(menuEstado.sectionTitle(section))
                                .font(.system(size: 14))
                                .foregroundColor(selectedSection == section ? .blue : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedSection == section ? Color.blue.opacity(0.2) : Color.clear)
                                )
                                .bold(selectedSection == section)
                        }
                    }
                }
                .padding(.horizontal)
            }
    }
    
}

struct RailAnchorsKey: PreferenceKey {
    static var defaultValue: [Int: Anchor<CGPoint>] = [:]
    static func reduce(value: inout [Int: Anchor<CGPoint>], nextValue: () -> [Int: Anchor<CGPoint>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}


struct IndicesVertical: View {
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    @Binding var isPressed: Bool
    @Binding var selectedSection: String?
    @Binding var isUserInteracting: Bool
    @Binding var scrollProxy: ScrollViewProxy?
    
    var sections: [String]
    
    // Tamaños base
    private let railWidthBase: CGFloat = 28
    private let labelWidth: CGFloat   = 140
    private let dotBase: CGFloat      = 15
    
    // Límites mínimos (más agresivos para garantizar encaje)
    private let minDot: CGFloat       = 8
    private let minSpacing: CGFloat   = 3
    
    var body: some View {
        GeometryReader { geo in
            // ← Solo lets dentro del ViewBuilder
            let m = computeMetrics(totalH: geo.size.height, count: sections.count)
            let dot = m.dot
            let spacing = m.spacing
            let _ = dot + spacing
            let topPad = m.topPad
            let fontScale = m.fontScale
            
            ZStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(zip(sections.indices, sections)), id: \.1) { index, section in
                        let isLast = index == sections.count - 1
                        Button {
                            isPressed = true
                            withAnimation(.interpolatingSpring(stiffness: 70, damping: 12)) {
                                selectedSection = sections[index]
                                ap.seccionSeleccionada = sections[index]
                                isUserInteracting = true
                                if section == sections.first {
                                    scrollProxy?.scrollTo("top", anchor: .top)
                                } else {
                                    scrollProxy?.scrollTo(section, anchor: .top)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isUserInteracting = false
                            }
                        } label: {
                            Punto(
                                index: index,
                                section: section,
                                selectedSection: $selectedSection,
                                isPressed: $isPressed,
                                // 👇 Altura correcta: sin spacing en la última
                                rowHeight: isLast ? dot : (dot + spacing),
                                dotDiameter: dot,
                                fontScale: fontScale
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, topPad)
                .padding(.bottom, topPad)
                .frame(maxHeight: .infinity, alignment: .top)
                .frame(width: railWidthBase + 12 + labelWidth)
                // Línea entre puntos usando anchors reales
                // Línea entre puntos usando anchors reales (con recorte en los círculos)
                .overlayPreferenceValue(RailAnchorsKey.self) { anchors in
                    GeometryReader { proxy in
                        let firstIdx = 0
                        let lastIdx  = max(sections.count - 1, 0)
                        if let a1 = anchors[firstIdx], let a2 = anchors[lastIdx] {
                            let p1 = proxy[a1]
                            let p2 = proxy[a2]
                            
                            Path { path in
                                path.move(to: p1)
                                path.addLine(to: p2)
                            }
                            .stroke(ap.temaResuelto.lineaColor, lineWidth: 1.1)
                            .mask(   // 👇 recorta donde hay círculos
                                ZStack {
                                    // Fondo blanco = línea visible
                                    Rectangle().fill(Color.white)
                                    
                                    // Círculos negros = "agujeros" en la línea
                                    ForEach(Array(anchors.keys), id: \.self) { i in
                                        if let anchor = anchors[i] {
                                            let p = proxy[anchor]
                                            Circle()
                                                .frame(width: dot + 3, height: dot + 3)
                                                .position(p)
                                                .blendMode(.destinationOut)
                                        }
                                    }
                                }
                            )
                            .compositingGroup()
                        }
                    }
                    .allowsHitTesting(false)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: 28 + 12 + 60) // rail + gap + label
        .padding(.bottom, 50)
    }
    
    // Cálculo adaptativo fuera del ViewBuilder
    private func computeMetrics(totalH: CGFloat, count: Int)
    -> (dot: CGFloat, spacing: CGFloat, contentH: CGFloat, topPad: CGFloat, fontScale: CGFloat) {
        
        let n = CGFloat(max(count, 1))
        guard n > 1 else {
            // con 1 sección: dot ocupa y centramos
            let dot = min(dotBase, totalH)
            let topPad = max(0, (totalH - dot) / 2)
            let fontScale = max(0.8, min(1.0, dot / dotBase))
            return (dot, 0, dot, topPad, fontScale)
        }
        
        // 1) Intento con dot base y spacing calculado
        var dot = dotBase
        var spacing = max(minSpacing, (totalH - (n * dot)) / (n - 1))
        var contentH = (n * dot) + ((n - 1) * spacing)
        
        // 2) Si no cabe, fija spacing mínimo y calcula dot
        if contentH > totalH {
            spacing = minSpacing
            dot = max(minDot, (totalH - (n - 1) * spacing) / n)
            contentH = (n * dot) + ((n - 1) * spacing)
        }
        
        // 3) Si aún no cabe (por muy poco), compresión proporcional final
        if contentH > totalH {
            // Altura mínima de referencia
            let minContent = (n * minDot) + ((n - 1) * minSpacing)
            if minContent > totalH {
                // Comprimir ambos proporcionalmente para encajar EXACTO
                let s = totalH / minContent
                dot     = minDot * s
                spacing = minSpacing * s
                contentH = totalH
            } else {
                // Poner dot en mínimo y ajustar spacing para cerrar hueco
                dot = minDot
                spacing = (totalH - n * dot) / (n - 1)
                contentH = (n * dot) + ((n - 1) * spacing)
            }
        }
        
        let topPad = max(0, (totalH - contentH) / 2)
        let fontScale = max(0.75, min(1.0, dot / dotBase))  // reduce fuente si comprimimos
        return (dot, spacing, contentH, topPad, fontScale)
    }
}



struct Punto: View {
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado

    var railWidth: CGFloat = 28
    var labelWidth: CGFloat = 90

    let index: Int
    let section: String
    @Binding var selectedSection: String?
    @Binding var isPressed: Bool
    let rowHeight: CGFloat
    let dotDiameter: CGFloat
    let fontScale: CGFloat   // ⬅️ nuevo
    
    private var tema: EnumTemas { ap.temaResuelto }

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(selectedSection == section ? ap.colorActual : tema.lineaColor)
                    .frame(width: dotDiameter, height: dotDiameter)
                    .shadow(color: selectedSection == section ? ap.colorActual : tema.lineaColor,
                            radius: selectedSection == section ? 6 : 0)
                    .overlay(
                        Circle()
                            .stroke((selectedSection == section && isPressed) ? ap.colorActual : .clear,
                                    lineWidth: 3.5)
                            .animation(.easeInOut(duration: 0.3), value: isPressed)
                    )
            }
            .frame(width: railWidth, alignment: .center)
            .anchorPreference(key: RailAnchorsKey.self, value: .center) { [index: $0] }

            // Título a la derecha
            // En Punto
            Text(menuEstado.sectionTitle(section))
                .bold(selectedSection == section)
                .font(.system(size: ap.constantes.smallTitleSize * fontScale * 1.4))
                .foregroundColor(selectedSection == section ? ap.temaResuelto.textColor : ap.temaResuelto.secondaryText)
                .frame(width: labelWidth, alignment: .leading)   // ancho fijo
                .lineLimit(nil)                                  // permite varias líneas
                .multilineTextAlignment(.leading)                // alinea a la izquierda

            Spacer(minLength: 0)
        }
        .frame(height: rowHeight)
    }
}





