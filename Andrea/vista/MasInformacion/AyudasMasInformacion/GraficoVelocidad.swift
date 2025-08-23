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

struct ReadingSpeedChart: View {
    // Datos de ejemplo
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @State private var verTodo: Bool = false
    
    var body: some View {
        let data = estadisticas.sesionesLectura.map { $0.toReadingSpeedData }
        
        // Encontrar el punto con el valor más alto
        let maxSpeedItem = data.max(by: { $0.speed < $1.speed })
        
        ZStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    verTodo.toggle()
                }
            }) {
                Text("Ver todo")
            }.fondoRectangular(esOscuro: false, shadow: true)
            .zIndex(1)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(15)
            
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
                        
                        AxisValueLabel {
                            VStack(alignment: .leading) {
                                switch hour {
                                case 0, 12:
                                    Text("\(date.formatted(.dateTime.hour()))h")
                                default:
                                    Text("\(date.formatted(.dateTime.hour(.defaultDigits(amPM: .omitted))))h")
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
            .if(verTodo) { v in
                v.chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: 60*60*12) // ejemplo: un día en segundos
//                    .chartXScale(domain: [
//                        estadisticas.sesionesLectura.first!.inicio,
//                        Calendar.current.date(byAdding: .hour, value: 1, to: estadisticas.sesionesLectura.last!.inicio)!
//                    ])
            }
            .chartYAxis {
                AxisMarks(position: .trailing) {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .frame(height: 200)
            .padding()
        }
    }
}
