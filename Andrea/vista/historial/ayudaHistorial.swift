import SwiftUI

// MARK: - Extensión de animación simplificada
// MARK: - EXTENSIÓN ANIMACIÓN APARICIÓN SIMPLE
extension View {
    func aparicionSuave(show: Binding<Bool>, delay: Double = 0.0) -> some View {
        self
            .scaleEffect(show.wrappedValue ? 1.0 : 0.98) // cambio muy sutil
            .opacity(show.wrappedValue ? 1.0 : 0.0)      // fundido
            .animation(
                .easeInOut(duration: 0.15).delay(delay), // animación rápida y suave
                value: show.wrappedValue
            )
            .onAppear {
                show.wrappedValue = true
            }
            .onDisappear {
                show.wrappedValue = false
            }
    }
}


struct ChevronAnimado: View {
    var isActive: Bool
    var delay: Double

    @EnvironmentObject var appEstado: AppEstado
    @State private var show: Bool = false

    var body: some View {
        Image(systemName: "chevron.forward")
            .font(.system(size: isActive ? 16 : 10))
            .foregroundColor(.gray.opacity(isActive ? 1.0 : 0.8))
            .aparicionSuave(show: $show)
    }
}

struct AnimatableFontModifier: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight))
    }
}

extension View {
    func animatableFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(AnimatableFontModifier(size: size, weight: weight))
    }
}

extension View {
    @ViewBuilder
    func fondoHistorial(
        estilo: EnumEstiloHistorialColecciones,
        pH: CGFloat,
        pV: CGFloat = 7,
        isActive: Bool,
        color: Color,
        borde: Bool = true
    ) -> some View {
        switch estilo {
        case .basico:
            self.fondoBoton1(pH: pH, pV: pV, isActive: isActive, color: color)
        case .degradado:
            self.fondoBoton(pH: pH, pV: pV, isActive: isActive, color: color, borde: borde)
        }
    }
}

struct ColeccionRectanguloAvanzado<Content: View>: View {
    @EnvironmentObject var ap: AppEstado
    
    let textoSize: CGFloat
    let colorPrimario: Color
    let nombre: String
    let color: Color
    let isActive: Bool
    let pH: CGFloat
    let animationDelay: Double
    let content: () -> Content
    
    @State private var show: Bool = false

    var body: some View {
        content()
            .animatableFont(size: textoSize, weight: isActive ? .semibold : .regular)
            .foregroundColor(colorPrimario)
            .fixedSize()
            .layoutPriority(1)
            .fondoHistorial(estilo: ap.historialEstilo, pH: pH, isActive: isActive, color: color)
//            .if(isActive) { view in
//                view.aparicionStiffness(show: $show)
//            }
    }
}



// Estilo de botón personalizado para mejor interacción
struct ColeccionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
