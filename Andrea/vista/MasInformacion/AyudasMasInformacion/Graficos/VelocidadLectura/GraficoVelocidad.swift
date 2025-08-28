import SwiftUI
import Charts

//#Preview {
//    ReadingSpeedChart()
//}

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
    // Datos de ejemplo
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @Binding var verTodo: Bool
    
    var body: some View {
        let data = estadisticas.sesionesLectura.map { $0.toReadingSpeedData }
        
//        Button(action: {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                verTodo.toggle()
//            }
//        }) {
//            Text("Ver todo")
//                .font(.footnote)
//        }
//        .zIndex(1)
//        .padding(5) // margen interno
//        .background(
//            RoundedRectangle(cornerRadius: 5)
//                .fill(Color.gray.opacity(0.2))
//        )
//        .padding(.trailing, 15)
        
        // Encontrar el punto con el valor más alto
        let maxSpeedItem = data.max(by: { $0.speed < $1.speed })
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
            
            // Línea principal
            ForEach(data) { item in
                LineMark(
                    x: .value("Fecha", item.date),
                    y: .value("Velocidad", item.speed)
                )
                .interpolationMethod(.monotone) // 👈 misma interpolación
                .foregroundStyle(.green)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            
            // Punto destacado en el valor más alto
            if let maxItem = maxSpeedItem {
                // Sombra del punto (punto más grande y con opacidad)
                PointMark(
                    x: .value("Fecha", maxItem.date),
                    y: .value("Velocidad", maxItem.speed)
                )
                .foregroundStyle(.green.opacity(0.3))
                .symbolSize(120) // Tamaño más grande para la sombra
                
                // Punto principal
                PointMark(
                    x: .value("Fecha", maxItem.date),
                    y: .value("Velocidad", maxItem.speed)
                )
                .foregroundStyle(.green)
                .symbolSize(80)
                
                // Punto interior (opcional, para más detalle)
                PointMark(
                    x: .value("Fecha", maxItem.date),
                    y: .value("Velocidad", maxItem.speed)
                )
                .foregroundStyle(.white)
                .symbolSize(30)
            }
        }
        .zIndex(0)
        .chartXAxis {
            AxisMarks(values: estadisticas.sesionesLectura.map { $0.inicio }) { value in
                if let date = value.as(Date.self) {
                    let hour = Calendar.current.component(.hour, from: date)
                    let isNewDay = value.index == 0 || {
                        if value.index > 0 {
                            let previousDate = estadisticas.sesionesLectura[value.index - 1].inicio
                            return !Calendar.current.isDate(date, inSameDayAs: previousDate)
                        }
                        return false
                    }()
                    
                    let prevDate: Date? = value.index > 0
                        ? estadisticas.sesionesLectura[value.index - 1].inicio
                        : nil
                    
                    let isNewHour = esNuevaHora(actual: date, respectoA: prevDate)
                    
                    AxisValueLabel {
                        VStack(alignment: .leading) {
                            if verTodo {
                                HStack(spacing: 1) {
                                    Text(date, format: .dateTime.hour().minute()) // 👈 "10:05"
                                    .font(.caption2)
                                }
                            }
                            
                            if !verTodo {
                                if isNewHour {
                                    Text("\(date)h", format: .dateTime.hour())
                                        .font(.caption2)
                                }
                            }
                            
                            if isNewDay {
                                Text(date, format: .dateTime.month().day())
                            }
                        }
                    }
                    
                    if isNewDay {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                    } else {
                        AxisGridLine()
                        AxisTick()
                    }
                }
            }
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Tiempo")
        }
        .if(verTodo) { v in
            v.chartScrollableAxes(.horizontal)
             .chartXScale(domain: [
                 estadisticas.sesionesLectura.first?.inicio ?? Date(),
                 estadisticas.sesionesLectura.last?.inicio ?? Date()
             ])
        }
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartYAxisLabel(position: .leading, alignment: .center) {
            Text("Velocidad")
                .rotationEffect(.degrees(180))
        }
        .frame(height: 220)
    }
}
