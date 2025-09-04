import SwiftUI
import Charts

//#Preview {
//    ReadingSpeedChart()
//}

struct LeyendaGraficoVelocidad: View {
    
    let vMax: Double
    
    var body: some View {
        Text("Velocidad máxima: \(vMax)")
            .font(.system(size: 14))
    }
}

extension SesionDeLectura {
    var toReadingSpeedData: ReadingSpeedData {
        ReadingSpeedData(date: inicio, speed: velocidadLectura)
    }
}

struct ReadingSpeedData: Identifiable {
    let id = UUID()
    let date: Date
    let speed: Double
}

func esNuevaHora(actual date: Date, respectoA previousDate: Date?) -> Bool {
    guard let prev = previousDate else { return true } // el primero siempre es "nuevo"
    let actualHour = Calendar.current.component(.hour, from: date)
    let prevHour   = Calendar.current.component(.hour, from: prev)
    return actualHour != prevHour
}

struct GraficoVelocidadLectura: View {
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @Binding var verTodo: Bool
    
    var body: some View {
        let data = estadisticas.sesionesLectura.map { $0.toReadingSpeedData }
        
        // Encontrar el punto con el valor más alto
        let maxSpeedItem = data.max(by: { $0.speed < $1.speed })
        
        // Fechas para ticks cada hora
        let fechas = estadisticas.sesionesLectura.map { $0.inicio }
        let inicio = fechas.first ?? Date()
        let fin = fechas.last ?? Date()
        let ticksCadaHora = stride(from: inicio, through: fin, by: 3600).map { $0 }
        
        Chart {
            // Área con degradado
            ForEach(data) { item in
                AreaMark(
                    x: .value("Fecha", item.date),
                    y: .value("Velocidad", item.speed)
                )
                .interpolationMethod(.monotone)
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
            
            // Línea principal
            ForEach(data) { item in
                LineMark(
                    x: .value("Fecha", item.date),
                    y: .value("Velocidad", item.speed)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(.green)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            
            // Punto destacado en el valor más alto
            if let maxItem = maxSpeedItem {
                PointMark(
                    x: .value("Fecha", maxItem.date),
                    y: .value("Velocidad", maxItem.speed)
                )
                .foregroundStyle(.green)
                .symbolSize(80)
            }
        }
        .zIndex(0)
        .chartXAxis {
            if verTodo {
                // Modo detallado → ticks cada hora
                AxisMarks(values: ticksCadaHora) { value in
                    if let date = value.as(Date.self) {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                            .foregroundStyle(.gray.opacity(0.5))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.3))
                        
                        AxisValueLabel {
                            VStack(spacing: 2) {
                                Text(date, format: .dateTime.hour().minute()) // ej: 18:00
                                    .font(.caption2)
                                Text(date, format: .dateTime.day().month())   // ej: 3 Sep
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            } else {
                // Vista resumida → 5 ticks automáticos
                AxisMarks(values: .automatic(desiredCount: 5))
            }
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            HStack(spacing: 3) {
                Text("Tiempo")
                    .font(.system(size: 16))
                Text(verTodo ? "(día:h:m)" : "(día:h)")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }
        }
        // Scroll horizontal solo en modo detallado
        .if(verTodo) { v in
            v.chartScrollableAxes(.horizontal)
             .chartXScale(domain: [inicio, fin])
        }
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartYAxisLabel(position: .leading, alignment: .center) {
            HStack(spacing: 3) {
                Text("Velocidad")
                    .font(.system(size: 16))
                Text("(ppm)")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }
            .rotationEffect(.degrees(180))
        }
        .frame(height: 220)
    }
}

