

import SwiftUI

#Preview {
    ProgresoCircular(titulo: "progreso", progreso: 34, progresoDouble: 0.34, color: .green)
}

struct ProgresoCircular: View {
    
    var titulo: String
    var progreso: Int // 0–100
    var progresoDouble: Double // 0.0–1.0
    var color: Color
    
    var anchuraLinea: CGFloat = 8
    var radio: CGFloat = 90
    
    @State private var animatedValor: Double = 0
    
    var body: some View {
        ZStack {
            // Fondo tenue
            Circle()
                .stroke(lineWidth: anchuraLinea)
                .opacity(0.85)
                .foregroundColor(color.opacity(0.15))
            
            // Círculo animado
            Circle()
                .trim(from: 0.0, to: CGFloat(animatedValor))
                .stroke(color, style: StrokeStyle(lineWidth: anchuraLinea, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 0)
            
            // Texto central animado
            VStack(spacing: 2) {
                Color.clear
                    .animatedProgressText1(Int(animatedValor * 100)) // 👈 pasamos Double
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(color)
                
                Text(titulo)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: radio, height: radio)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1)) {
                animatedValor = progresoDouble
            }
        }
        .onChange(of: progresoDouble) { old, newVal in
            withAnimation(.easeInOut(duration: 1.1)) {
                animatedValor = newVal
            }
        }
    }
}



struct TiempoCircular: View {
    var tiempoTotalProgreso: Int
    var tiempoTotalProgresoDouble: Double
    var color: Color
    
    @State private var animatedValor: Double = 0
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.2)
                .foregroundColor(.secondary)
            
            Circle()
                .trim(from: 0.0, to: animatedValor)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: tiempoTotalProgresoDouble)
                .onAppear {
                    withAnimation { animatedValor = tiempoTotalProgresoDouble } // arranca inicial
                }
//                .onChange(of: progreso) { newValue in
//                    withAnimation(.easeInOut(duration: 1.1)) {
//                        animatedValor = newValue
//                    }
//                }

            
            HStack(alignment: .bottom, spacing: 1.5) {
                Text("%")
                    .font(.system(size: 15))
                    .offset(y: -4)
                    .opacity(0.7)
                Color.clear
                    .animatedProgressText1(Int(tiempoTotalProgreso))
                    .font(.system(size: 25))
            }
        }
//        .onAppear {
//            print("Tiempo circular")
//            print("TIEMPO TOTAL: ", tiempoTotal)
//            print("TIEMPO res: ", tiempoRestante)
//            print("P: ", progreso)
//        }
        .frame(width: 120, height: 120)
    }
}


//struct ProgresoCircularColeccion: View {
//    
//    var titulo: String
//    var progreso: Int // 0–100
//    var progresoDouble: Double // 0.0–1.0
//    var color: Color
//
//    @State private var animatedValor: Double = 0
//    
//    var body: some View {
//        ZStack {
//            // Fondo tenue
//            Circle()
//                .stroke(lineWidth: 12)
//                .opacity(0.85)
//                .foregroundColor(color.opacity(0.15))
//            
//            // Círculo animado
//            Circle()
//                .trim(from: 0.0, to: CGFloat(animatedValor))
//                .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
//                .rotationEffect(.degrees(-90))
//                .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 0)
//            
//            // Texto central animado
//            VStack(spacing: 2) {
//                Color.clear
//                    .animatedProgressText1(Int(animatedValor * 100)) // 👈 pasamos Double
//                    .font(.system(size: 24, weight: .semibold, design: .rounded))
//                    .monospacedDigit()
//                    .foregroundColor(color)
//                
//                Text(titulo)
//                    .font(.system(size: 10, weight: .medium))
//                    .foregroundColor(.secondary)
//            }
//        }
//        .frame(width: 120, height: 120)
//        .onAppear {
//            withAnimation(.easeInOut(duration: 1.1)) {
//                animatedValor = progresoDouble
//            }
//        }
//        .onChange(of: progresoDouble) { old, newVal in
//            withAnimation(.easeInOut(duration: 1.1)) {
//                animatedValor = newVal
//            }
//        }
//    }
//}
