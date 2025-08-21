import SwiftUI

#Preview {
    PreviewMasInformacion2()
}

private struct PreviewMasInformacion2: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInformacion(
            pantallaCompleta: $pantallaCompleta,
            vm: ModeloColeccion(),
            elemento: Archivo.preview
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}


struct ProgresoTiempo: View {
    
    @ObservedObject var archivo: Archivo
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Tiempo total ")
                    .font(.system(size: 18))
                    .bold()
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    ProgresoCircularTest(progreso: Int(archivo.tiempoTotal) / 100, progresoEntero: Double(archivo.tiempoTotal) / 100, color: .blue)
                    
                    VStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(.blue.opacity(0.65))
                                .frame(width: 4, height: 12)
                            Text("Tiempo de lectura")
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                        }
                        
                        HStack(alignment: .bottom, spacing: 1.5) {
                            Text("\(Int(archivo.tiempoTotal))")
                                .font(.system(size: 20))
                                .foregroundColor(.blue.opacity(0.65))
                            Text("Min")
                                .font(.system(size: 12.5))
                                .foregroundColor(.primary)
                                .offset(y: -2)
                        }
                        .offset(x: -16)
                        
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(.secondary.opacity(0.65))
                                .frame(width: 4, height: 12)
                            Text("Todavía faltan")
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                        }
                        
                        HStack(alignment: .bottom, spacing: 1.5) {
                            Text("17")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary.opacity(0.65))
                            Text("Min")
                                .font(.system(size: 12.5))
                                .foregroundColor(.primary)
                                .offset(y: -2)
                        }
                        
                    }
                }
                
            }
            .padding(.leading, 20)
            
            
            PageTimeChart()
                .offset(y: 30)
        }
    }
}

import Charts

struct PageTimeData: Identifiable {
    let id = UUID()
    let page: Int
    let timeMinutes: Double
}

struct PageTimeChart: View {
    let data: [PageTimeData] = [
        PageTimeData(page: 1, timeMinutes: 4.2),
        PageTimeData(page: 2, timeMinutes: 3.8),
        PageTimeData(page: 3, timeMinutes: 5.1),
        PageTimeData(page: 4, timeMinutes: 7.2),
        PageTimeData(page: 5, timeMinutes: 6.8),
        PageTimeData(page: 6, timeMinutes: 8.5),
        PageTimeData(page: 7, timeMinutes: 5.9),
        PageTimeData(page: 8, timeMinutes: 9.2),
        PageTimeData(page: 9, timeMinutes: 8.8),
        PageTimeData(page: 10, timeMinutes: 7.1),
        PageTimeData(page: 11, timeMinutes: 6.4),
        PageTimeData(page: 12, timeMinutes: 5.8),
        PageTimeData(page: 13, timeMinutes: 6.2),
        PageTimeData(page: 14, timeMinutes: 4.9)
    ]
    
    var averageTime: Double {
        let total = data.reduce(0) { $0 + $1.timeMinutes }
        return total / Double(data.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("Página visitada más tiempo 8")
//                .font(.headline)
//                .foregroundColor(.primary)
//                .padding(.horizontal)
            
            Chart(data) { item in
                BarMark(
                    x: .value("Página", item.page),
                    y: .value("Tiempo", item.timeMinutes)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.8),
                            Color.blue.opacity(0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(2)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: 1)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0))
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, lineCap: .round))
                        .foregroundStyle(.gray.opacity(0.3))
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text("\(Int(doubleValue))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    AxisTick(stroke: StrokeStyle(lineWidth: 0))
                }
            }
            .chartYScale(domain: 0...10)
            .overlay(
                // Línea de promedio
                Rectangle()
                    .fill(.gray)
                    .frame(width: 300, height: 1.5)
                    .overlay(
                        HStack(spacing: 0) {
                            ForEach(0..<20, id: \.self) { _ in
                                Rectangle()
                                    .fill(.gray)
                                    .frame(width: 4, height: 1)
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 2, height: 1)
                            }
                        }
                    )
                    .position(x: 250, y: CGFloat(260 - (averageTime * 21))) // Ajustar posición según el promedio
                    .overlay(
                        HStack {
                            Text("Avg \(String(format: "%.1f", averageTime))%")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.gray)
                                )
                            Spacer()
                        }
                        .position(x: 200, y: CGFloat(260 - (averageTime * 21)))
                    )
            )
            .frame(width: 435, height: 210)
//            .padding(.horizontal)
            
            // Etiqueta del eje X
            HStack {
                Spacer()
                Text("Páginas")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.trailing, 40)
            }
        }
    }
}

// Vista de prueba
struct ContentView: View {
    var body: some View {
        VStack {
            PageTimeChart()
        }
        .padding()
    }
}
