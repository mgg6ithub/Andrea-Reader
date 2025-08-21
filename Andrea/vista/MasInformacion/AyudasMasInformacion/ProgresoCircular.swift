

import SwiftUI

struct ProgresoCircularTest: View {
    
    var progreso: Int // 0.0 a 1.0
    var progresoEntero: Double
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
                .animation(.easeOut, value: progresoEntero)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.1)) {
                        animatedValor = progresoEntero
                    }
                }
            
            HStack(alignment: .bottom, spacing: 1.5) {
                Text("%")
                    .font(.system(size: 15))
                    .offset(y: -4)
                    .opacity(0.7)
                Color.clear
                    .animatedProgressText1(Int(progreso))
                    .font(.system(size: 25))
            }
        }
        .frame(width: 90, height: 90)
    }
    
}


struct ProgresoCircularTestTiempo: View {
    var tiempoTotal: TimeInterval
    var tiempoRestante: TimeInterval
    var color: Color
    
    @State private var animatedValor: Double = 0
    
    var body: some View {
        let progreso = (tiempoTotal > 0 && (tiempoTotal + tiempoRestante) > 0)
            ? min(tiempoTotal / (tiempoTotal + tiempoRestante), 1.0)
            : 0
        
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
                .onAppear {
                    animatedValor = progreso // arranca inicial
                }
                .onChange(of: progreso) { newValue in
                    withAnimation(.easeInOut(duration: 1.1)) {
                        animatedValor = newValue
                    }
                }

            
            VStack(spacing: 4) {
                // Texto dinámico
                Text(tiempoTotal.formattedTime())
                    .font(.system(size: 14, weight: .bold))
                    .multilineTextAlignment(.center)
                Text("\(Int(progreso * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            print("TIEMPO TOTAL: ", tiempoTotal)
            print("TIEMPO res: ", tiempoRestante)
            print("P: ", progreso)
        }
        .frame(width: 120, height: 120)
    }
}


