import SwiftUI
import Charts

#Preview {
    ReadingSpeedChart()
}

struct ReadingSpeedData: Identifiable {
    let id = UUID()
    let date: Date
    let speed: Double // páginas por minuto, palabras por minuto, etc.
}

struct ReadingSpeedChart: View {
    // Datos de ejemplo
    let data: [ReadingSpeedData] = [
        ReadingSpeedData(date: Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1))!, speed: 1.2),
        ReadingSpeedData(date: Calendar.current.date(from: DateComponents(year: 2023, month: 2, day: 1))!, speed: 2.8),
        ReadingSpeedData(date: Calendar.current.date(from: DateComponents(year: 2023, month: 3, day: 1))!, speed: 2.9),
        ReadingSpeedData(date: Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 1))!, speed: 2.1),
        ReadingSpeedData(date: Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1))!, speed: 3.4),
        ReadingSpeedData(date: Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 1))!, speed: 3.5),
        ReadingSpeedData(date: Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 1))!, speed: 4.0),
    ]
    
    var body: some View {
        Chart {
            // Área con degradado
            ForEach(data) { item in
                AreaMark(
                    x: .value("Fecha", item.date),
                    y: .value("Velocidad", item.speed)
                )
                .interpolationMethod(.monotone) // 👈 igual que la línea
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.3),
                            Color.green.opacity(0.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            
            // Línea roja
            ForEach(data) { item in
                LineMark(
                    x: .value("Fecha", item.date),
                    y: .value("Velocidad", item.speed)
                )
                .interpolationMethod(.monotone) // 👈 misma interpolación
                .foregroundStyle(.green)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .month)) { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.abbreviated)) // Ej: Jan, Feb, Mar
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .frame(height: 200)
        .padding()
    }
}
