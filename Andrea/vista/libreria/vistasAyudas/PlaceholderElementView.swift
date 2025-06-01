
import SwiftUI

struct PlaceholderElementView: View {
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 12) {
            // Imagen de portada simulada
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 100, height: 140)
                .shimmering()

            // Título simulado
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 90, height: 14)
                .shimmering()

            // Metadatos simulados
            HStack(spacing: 6) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 24, height: 10)
                        .shimmering()
                }
            }
        }
        .padding()
        .frame(width: 150, height: 220)
        .background(Color(.systemGray6))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0...0.2))) {
                isVisible = true
            }
        }
    }
}


struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let gradient = LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            Color.white.opacity(0.4),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                    Rectangle()
                        .fill(gradient)
                        .frame(width: geometry.size.width * 1.5)
                        .offset(x: geometry.size.width * phase)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    phase = 2.0
                }
            }
    }
}



