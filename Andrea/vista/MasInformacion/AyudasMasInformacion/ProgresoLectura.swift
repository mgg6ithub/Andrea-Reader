

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

struct Botones: View {
    
    @Binding var cambio: Bool
    
    var body: some View {
        HStack{
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    cambio = true
                }
            }) {
                HStack(spacing: 4) {
                    Text("vel")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(cambio ? .white : .secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(cambio ? Color.gray : Color.clear)
                )
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    cambio = false
                }
            }) {
                HStack(spacing: 4) {
                    Text("pro")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(cambio ? .secondary : .white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(cambio ? Color.clear : Color.gray)
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct ProgresoLectura: View {
    
    @ObservedObject var archivo: Archivo
    
    @State private var cambio: Bool = true
    
    private var sss: EstadisticasYProgresoLectura { archivo.estadisticas }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Progreso lectura")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.top, 10)
                    Spacer()
                    Botones(cambio: $cambio)
                        .padding(.trailing, 20)
                }
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        ProgresoCircular(progreso: sss.progreso, progresoDouble: sss.progresoDouble, color: .green)
                        
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
                                Text("\(sss.paginaActual + 1)")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green.opacity(0.65))
                                Text("páginas")
                                    .font(.system(size: 12.5))
                                    .foregroundColor(.primary)
                                    .offset(y: -3.5)
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
                                Text("\(sss.paginasRestantes)")
                                    .font(.system(size: 20))
                                    .foregroundColor(.secondary.opacity(0.65))
                                Text("páginas")
                                    .font(.system(size: 12.5))
                                    .foregroundColor(.primary)
                                    .offset(y: -3.5)
                            }
                            
                        }
                    }
                    
                    //GRAFICO
                    if cambio {
                        ReadingSpeedChart(estadisticas: sss)
                    } else if !cambio {
                        Testtest()
//                            .offset(y: 22)
                    }
                }
                
            }
            .padding(.leading, 20)
            

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


