
import SwiftUI
import Charts

// Vista de prueba
struct InformacionProgresoGrafico: View {
    var body: some View {
        VStack(alignment: .center) {
            
            VStack {
                Text("Progreso actual vs ideal")
                
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
                }
                .padding(.horizontal)
            }
            .frame(height: 50)
            
            GraficoProgreso()
        }
    }
}


struct ReadingProgress: Identifiable {
    let id = UUID()
    let date: Date
    let actual: Double   // Progreso real en %
    let ideal: Double    // Progreso ideal en %
}

struct GraficoProgreso: View {
    let data: [ReadingProgress] = [
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 21))!, actual: 0,  ideal: 0),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 22))!, actual: 30, ideal: 15),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 23))!, actual: 10, ideal: 30),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 24))!, actual: 45, ideal: 45),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 25))!, actual: 70, ideal: 60),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 26))!, actual: 80, ideal: 75),
        ReadingProgress(date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 27))!, actual: 95, ideal: 95),
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
        .frame(height: 200)
    }
}
