
import SwiftUI
import Charts

// Vista de prueba
struct InformacionProgresoGrafico: View {
    
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
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
            
            GraficoProgreso(estadisticas: estadisticas)
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
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    var body: some View {
        // Transformar tus sesiones a progreso
        let data: [ReadingProgress] = estadisticas.sesionesLectura.map { sesion in
            let actual = estadisticas.progresoRealEnFecha(sesion.inicio)   // 🔹 función en tu modelo
            let ideal  = estadisticas.progresoIdealEnFecha(sesion.inicio)  // 🔹 función en tu modelo
            return ReadingProgress(date: sesion.inicio, actual: actual, ideal: ideal)
        }
        
        Chart {
            // Línea progreso real
            ForEach(data) { item in
                LineMark(
                    x: .value("Fecha", item.date),
                    y: .value("Progreso", min(max(item.actual, 0), 100)), // 👈 limitar valores
                    series: .value("Tipo", "Actual")
                )
            }
            .foregroundStyle(.green)
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            // Línea progreso ideal
            ForEach(data) { item in
                LineMark(
                    x: .value("Fecha", item.date),
                    y: .value("Progreso", min(max(item.ideal, 0), 100)), // 👈 limitar valores
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
        .chartYScale(domain: 0...100)   // 🔹 siempre de 0 a 100
        .chartXScale(domain: [
            data.first?.date ?? Date(),
            data.last?.date ?? Date()
        ]) // 🔹 ajusta el rango X
        .frame(height: 200)
    }
}

