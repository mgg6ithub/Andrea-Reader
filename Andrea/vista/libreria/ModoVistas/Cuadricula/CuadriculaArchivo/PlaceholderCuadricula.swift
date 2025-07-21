
import SwiftUI

struct PlaceholderCuadricula: View {
    @State private var isVisible = false

    let placeholder: ElementoPlaceholder
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {

            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipShape(RoundedCorner(radius: 18, corners: [.topLeft, .topRight]))
                .frame(width: width)

            // Parte inferior: título + metadatos
            VStack {
                // Simulación del nombre del archivo
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 16)

                // Simulación de metadatos
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 25, height: 14)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 25, height: 14)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 25, height: 14)
                }
            }
            .frame(height: 30)
            .padding(8)
        }
        .frame(width: width, height: height)
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
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



