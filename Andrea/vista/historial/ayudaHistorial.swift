import SwiftUI

// MARK: - Extensión de animación simplificada
extension View {
    func aparicionSuave(
        animaciones: Bool,
        delay: Double = 0,
        isVisible: Binding<Bool>,
        scale: Binding<CGFloat>
    ) -> some View {
        self
            .onAppear {
                if animaciones {
                    withAnimation(.easeOut(duration: 0.8).delay(delay)) {
                        isVisible.wrappedValue = true
                        scale.wrappedValue = 1.0
                    }
                } else {
                    isVisible.wrappedValue = true
                    scale.wrappedValue = 1.0
                }
            }
            .onDisappear {
                if animaciones {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isVisible.wrappedValue = false
                        scale.wrappedValue = 0.92
                    }
                } else {
                    isVisible.wrappedValue = false
                    scale.wrappedValue = 0.92
                }
            }
    }
}

struct ChevronAnimado: View {
    var isActive: Bool
    var delay: Double

    @EnvironmentObject var appEstado: AppEstado
    @State private var show: Bool = false
    @State private var scale: CGFloat = 0.85

    var body: some View {
        Image(systemName: "chevron.forward")
            .font(.system(size: isActive ? 16 : 10))
            .foregroundColor(.gray.opacity(isActive ? 1.0 : 0.8))
            .aparicionStiffness(show: $show)
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

struct ColeccionRectanguloAvanzado<Content: View>: View {
    let textoSize: CGFloat
    let colorPrimario: Color
    let color: Color
    let isActive: Bool
    let pH: CGFloat
    let animationDelay: Double
    let content: () -> Content
    
    @EnvironmentObject var appEstado: AppEstado
    @State private var show: Bool = false
    @State private var scale: CGFloat = 0.88

    var body: some View {
        content()
            .animatableFont(size: textoSize, weight: isActive ? .semibold : .regular)
            .foregroundColor(colorPrimario)
            .fixedSize()
            .layoutPriority(1)
            .fondoBoton(pH: pH, pV: 7, isActive: isActive, color: color, borde: isActive)
            .aparicionStiffness(show: $show)
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
