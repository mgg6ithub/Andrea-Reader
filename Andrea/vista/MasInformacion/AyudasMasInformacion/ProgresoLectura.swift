

import SwiftUI
import Charts

#Preview {
    PreviewMasInformacion()
}

private struct PreviewMasInformacion: View {
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

struct ProgresoLectura: View {
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Progreso lectura")
                    .font(.system(size: 18))
                    .bold()
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    ProgresoCircularTest(valor: 0.34, color: .green)
                    
                    VStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(.green.opacity(0.65))
                                .frame(width: 4, height: 12)
                            Text("Completado")
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                        }
                        
                        HStack(alignment: .bottom, spacing: 1.5) {
                            Text("15")
                                .font(.system(size: 20))
                                .foregroundColor(.green.opacity(0.65))
                            Text("Páginas")
                                .font(.system(size: 12.5))
                                .foregroundColor(.primary)
                                .offset(y: -2)
                        }
                        
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
                            Text("33")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary.opacity(0.65))
                            Text("Páginas")
                                .font(.system(size: 12.5))
                                .foregroundColor(.primary)
                                .offset(y: -2)
                        }
                        
                    }
                }
                
            }
            .padding(.leading, 20)
            
            //GRAFICO
            Testtest()
                .offset(y: 22)
        }
    }
}

struct ReadingProgress: Identifiable {
    let id = UUID()
    let date: Date
    let actual: Double   // Progreso real en %
    let ideal: Double    // Progreso ideal en %
}

struct GraficoTest: View {
    let data: [ReadingProgress] = [
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 21))!, actual: 0,  ideal: 0),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 22))!, actual: 20, ideal: 25),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 23))!, actual: 35, ideal: 50),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 24))!, actual: 55, ideal: 75),
    ]
    
    var body: some View {
        Chart {
            // Línea progreso real (roja continua)
            ForEach(data) { item in
                LineMark(
                    x: .value("Fecha", item.date),
                    y: .value("Progreso", item.actual),
                    series: .value("Tipo", "Actual")
                )
            }
            .foregroundStyle(.green)
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            // Línea progreso ideal (gris discontinua)
            ForEach(data) { item in
                LineMark(
                    x: .value("Fecha", item.date),
                    y: .value("Progreso", item.ideal),
                    series: .value("Tipo", "Ideal")
                )
            }
            .foregroundStyle(.gray)
            .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 4]))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(date, format: .dateTime.month(.abbreviated).day())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }

        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let intValue = value.as(Double.self) {
                        Text("\(Int(intValue))%")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        // Invertir el eje Y para que 0% esté arriba como en tu imagen
        .chartYScale(domain: 0...100)
        .scaleEffect(y: -1) // Voltear verticalmente
        .frame(height: 200)
        .padding()
        .scaleEffect(y: -1) // Voltear de nuevo para que el texto quede normal
    }
}

// Vista de prueba
struct Testtest: View {
    var body: some View {
        VStack {
//            Text("Comparison")
//                .font(.title2)
//                .foregroundColor(.gray)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
            
            HStack(spacing: 15) {
                HStack {
                    Rectangle()
                        .fill(.green)
                        .frame(width: 25, height: 2)
                    Text("Progreso")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                
                HStack {
                    HStack(spacing: 2) {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 3, height: 2)
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 1, height: 2)
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 3, height: 2)
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 1, height: 2)
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 3, height: 2)
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 1, height: 2)
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 3, height: 2)
                    }
                    .frame(width: 20, height: 2)
                    
                    Text("Progreso ideal")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            GraficoTest()
        }
    }
}


