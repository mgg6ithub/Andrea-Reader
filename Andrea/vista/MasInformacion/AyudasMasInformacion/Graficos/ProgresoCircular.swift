

import SwiftUI

struct ProgresoCircular: View {
    
    var progreso: Int // 0.0 a 1.0
    var progresoDouble: Double
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
                .animation(.easeOut, value: progresoDouble)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.1)) {
                        animatedValor = progresoDouble
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
        .onAppear {
            print("Progreso circuclar")
            print("progreso: ", progreso)
            print("progreso entero: ", progresoDouble)
            print()
        }
        .frame(width: 90, height: 90)
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
                    animatedValor = tiempoTotalProgresoDouble // arranca inicial
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


