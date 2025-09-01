
import SwiftUI
import Charts

struct LeyendaGraficoProgreso: View {
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 7) {
                Rectangle()
                    .fill(.green)
                    .frame(width: 25, height: 2)
                Text("Progreso")
                    .font(.system(size: 14))
            }
            
            HStack(spacing: 10) {
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
                    .font(.system(size: 14))
            }
        }
        .padding(.horizontal)
    }
}


struct ReadingProgress: Identifiable {
    let id = UUID()
    let date: Date
    let actual: Double   // Progreso real en %
    let ideal: Double    // Progreso ideal en %
}

struct GraficoProgresoLectura: View {
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    var body: some View {
        // Transformar sesiones a progreso
        let data: [ReadingProgress] = {
            var result = estadisticas.sesionesLectura.map { sesion in
                let actual = estadisticas.progresoRealEnFecha(sesion.inicio)
                let ideal  = estadisticas.progresoIdealEnFecha(sesion.inicio)
                return ReadingProgress(date: sesion.inicio, actual: actual, ideal: ideal)
            }
            
            // Si solo hay una sesión, añadimos el punto final
            if estadisticas.sesionesLectura.count == 1,
               let sesion = estadisticas.sesionesLectura.first,
               let fin = sesion.fin {
                
                let actualFin = estadisticas.progresoRealEnFecha(fin)
                let idealFin  = estadisticas.progresoIdealEnFecha(fin)
                result.append(ReadingProgress(date: fin, actual: actualFin, ideal: 100))
            }
            return result
        }()
        
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
        .chartYScale(domain: 0...100)   // Y siempre de 0 a 100 %
        .chartXScale(domain: [
            data.first?.date ?? Date(),
            data.last?.date ?? Date()
        ])
        // Eje X: tiempo
        .chartXAxis {
            AxisMarks(values: estadisticas.sesionesLectura.map { $0.inicio }) { value in
                if let date = value.as(Date.self) {
                    let prevDate: Date? = value.index > 0
                        ? estadisticas.sesionesLectura[value.index - 1].inicio
                        : nil
                    
                    let isNewHour = esNuevaHora(actual: date, respectoA: prevDate)
                    let isNewDay  = prevDate.map { !Calendar.current.isDate($0, inSameDayAs: date) } ?? true
                    
                    // 👉 Solo mostramos ticks/lineas si cambia la hora
                    if isNewHour {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        AxisTick(stroke: StrokeStyle(lineWidth: 1, dash: [4,2]))
                            .foregroundStyle(.gray)
                        
                        AxisValueLabel {
                            VStack(spacing: 2) {
                                // Hora:minuto en cada cambio de hora
                                Text(date, format: .dateTime.hour().minute())
                                    .font(.caption2)
                                
                                // Día cuando es cambio de día
                                if isNewDay {
                                    Text(date, format: .dateTime.day().month())
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            HStack(spacing: 3) {
                Text("Tiempo")
                    .font(.system(size: 16))
                Text("(día:h)")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }
        }
        // Eje Y: progreso %
        .chartYAxis {
            AxisMarks(position: .leading) { value in
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
        .chartYAxisLabel(position: .leading, alignment: .center) {
            HStack(spacing: 3) {
                Text("Progreso")
                .font(.system(size: 16))
                
                Text("(%)")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }
            .rotationEffect(.degrees(180))
        }
        
        .frame(height: 220)
    }
}


struct GraficoProgreso1: View {
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
                            if isNewHour {
                                Text(date, format: .dateTime.hour())
                                    .font(.caption2)
                            }
                            
                            if isNewDay {
                                Text(date, format: .dateTime.month().day())
                            }
                        }
                    }
                    if isNewDay {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                    } else if isNewHour {
                        AxisGridLine()
                        AxisTick()
                    }
                }
            }
        }
        .chartXAxisLabel(position: .leading, alignment: .center) {
            HStack(spacing: 3) {
                Text("Tiempo")
                    .font(.system(size: 16))
                
                Text("(día:h)")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }
            .rotationEffect(.degrees(180))
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
        .chartYAxisLabel(position: .bottom, alignment: .center) {
            HStack(spacing: 15) {
                HStack {
                    Rectangle()
                        .fill(.green)
                        .frame(width: 25, height: 2)
                    Text("Progreso")
                        .font(.system(size: 16))
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
                        .font(.system(size: 16))
                }
            }
            .padding(.horizontal)
        }
        .chartYScale(domain: 0...100)   // 🔹 siempre de 0 a 100
        .chartXScale(domain: [
            data.first?.date ?? Date(),
            data.last?.date ?? Date()
        ]) // 🔹 ajusta el rango X
        .frame(height: 220)
    }
}

