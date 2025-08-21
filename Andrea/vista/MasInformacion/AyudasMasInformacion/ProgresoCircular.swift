

import SwiftUI

struct ProgresoCircular: View {
    var valor: Double // 0.0 a 1.0
    var color: Color

    @State private var animatedValor: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.2)
                .foregroundColor(.secondary)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(animatedValor))
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: valor)
                .onAppear {
                    withAnimation {
                        animatedValor = valor
                    }
                }
            
            HStack(alignment: .bottom, spacing: 1.5) {
                Text("%")
                    .font(.system(size: 15))
                    .offset(y: -4)
                    .opacity(0.7)
                Text("\(Int(valor * 100))")
                        .font(.system(size: 25))
            }
        }
        .frame(width: 90, height: 90)
    }
}
