
import SwiftUI

extension View {
    func capaAnimacion(
        animaciones: Bool,
        delay: Double = 0,
        isVisible: Binding<Bool>,
        scale: Binding<CGFloat>,
        offset: Binding<CGFloat>
    ) -> some View {
        self
            .onAppear {
                if animaciones {
                    withAnimation(.easeInOut(duration: 0.35).delay(delay)) {
                        isVisible.wrappedValue = true
                        scale.wrappedValue = 1.0
                        offset.wrappedValue = 0
                    }
                } else {
                    isVisible.wrappedValue = true
                    scale.wrappedValue = 1.0
                    offset.wrappedValue = 0
                }
            }
            .onDisappear {
                if animaciones {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isVisible.wrappedValue = false
                        scale.wrappedValue = 0.9
                        offset.wrappedValue = -10
                    }
                } else {
                    isVisible.wrappedValue = false
                    scale.wrappedValue = 0.9
                    offset.wrappedValue = -10
                }
            }
    }
}


struct ChevronAnimado: View {
    var isActive: Bool
    var delay: Double

    @EnvironmentObject var appEstado: AppEstado
    @State private var isVisible: Bool = false
    @State private var scale: CGFloat = 0.8
    @State private var offset: CGFloat = -10

    var body: some View {
        Image(systemName: "chevron.forward")
            .font(.system(size: isActive ? 16 : 10))
            .foregroundColor(.gray.opacity(isActive ? 1.0 : 0.8))
            .scaleEffect(scale)
            .offset(x: offset)
            .opacity(isVisible ? 1.0 : 0.0)
            .capaAnimacion(animaciones: appEstado.animaciones,delay: delay,isVisible: $isVisible,scale: $scale,offset: $offset)
    }
}

struct AnimatableFontModifier: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular

    // Este property hace que SwiftUI anime el cambio de `size`
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
    @State private var isVisible: Bool = false
    @State private var scale: CGFloat = 0.8
    @State private var offset: CGFloat = 20

    var body: some View {
        content()
            .animatableFont(size: textoSize, weight: isActive ? .semibold : .regular)
            .foregroundColor(colorPrimario)
            .fixedSize()
            .layoutPriority(1)
            .scaleEffect(scale)
            .offset(x: offset)
            .opacity(isVisible ? 1.0 : 0.0)
            .fondoBoton(pH: pH, pV: 7, isActive: isActive, color: color, borde: isActive)
            .capaAnimacion(animaciones: appEstado.animaciones,delay: animationDelay,isVisible: $isVisible,scale: $scale,offset: $offset)
    }
}


// Estilo de botón personalizado para mejor interacción
struct ColeccionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
