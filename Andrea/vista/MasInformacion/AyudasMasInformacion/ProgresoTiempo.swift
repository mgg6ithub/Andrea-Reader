import SwiftUI
import Charts

#Preview {
//    ProgresoTiempo(archivo: Archivo.preview)
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
                    
                    ProgresoCircular(progreso: archivo.estadisticas.progresoTiempoTotal, progresoDouble: archivo.estadisticas.progresoTiempoTotalDouble, color: .blue)
                    
                    VStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(.blue.opacity(0.65))
                                .frame(width: 4, height: 12)
                            Text("Tiempo de lectura")
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                        }
                        
                        TiempoFormateado(tiempo: archivo.estadisticas.tiempoTotal, color: .blue.opacity(0.65))
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
                        
                        TiempoFormateado(tiempo: archivo.estadisticas.tiempoRestante, color: .secondary.opacity(0.65))
                    }

                }
                
            }
            .padding(.leading, 20)
            
            
            PageTimeChart()
        }
    }
}


struct PageTimeData: Identifiable {
    let id = UUID()
    let page: Int
    let percentage: Double
}

struct PageTimeChart: View {
    let data: [PageTimeData] = [
        PageTimeData(page: 1, percentage: 4.2),
        PageTimeData(page: 2, percentage: 3.8),
        PageTimeData(page: 3, percentage: 6.5),
        PageTimeData(page: 4, percentage: 6.2),
        PageTimeData(page: 5, percentage: 7.1),
        PageTimeData(page: 6, percentage: 6.9),
        PageTimeData(page: 7, percentage: 7.5),
        PageTimeData(page: 8, percentage: 7.4),
        PageTimeData(page: 9, percentage: 6.8),
        PageTimeData(page: 10, percentage: 5.9),
        PageTimeData(page: 11, percentage: 6.1),
        PageTimeData(page: 12, percentage: 6.0),
        PageTimeData(page: 13, percentage: 6.7),
        PageTimeData(page: 14, percentage: 5.2)
    ]
    
    var average: Double {
        data.map(\.percentage).reduce(0, +) / Double(data.count)
    }
    
    // IDs de los 4 elementos más altos
    var topFourPages: Set<UUID> {
        let sorted = data.sorted { $0.percentage > $1.percentage }
        return Set(sorted.prefix(4).map { $0.id })
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
//            Text("Pagina visitada mas tiempo 8")
//                .font(.headline)
//                .padding(.horizontal)
            
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Página", String(item.page)),
                        y: .value("Tiempo", item.percentage),
                        width: 28
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.5),
                                Color.blue.opacity(0.05)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(2)
                    .annotation(position: .top) {
                        // Línea arriba de cada barra
                        Rectangle()
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: 28, height: 3)
                            .offset(y: 6)
                    }
                    // 👇 Aquí el truco: solo mostrar texto si está en el top 4
                    .annotation(position: .top) {
                        if topFourPages.contains(item.id) {
                            Text("\(String(format: "%.1f", item.percentage))")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .offset(y: -8) // lo sube un poco sobre la barra
                        }
                    }
                }

                // Línea de promedio
                RuleMark(y: .value("Promedio", average))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(.black)
                    .annotation(position: .overlay) {
                        HStack {
                            Spacer()
                            Text("Avg \(String(format: "%.1f", average))%")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.black)
                                .cornerRadius(4)
                                .foregroundColor(.white)
                                .padding(.trailing, 4) // 👈 pequeño margen dentro
                        }
                    }
            }

            .chartXAxis {
                AxisMarks(values: data.map { String($0.page) }) { value in
                    AxisGridLine(stroke: .init(lineWidth: 0))
                    AxisValueLabel {
                        if let page = value.as(String.self) {
                            Text(page)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0)) // sin grilla visible
                }
            }
            .frame(height: 220)
            .padding(.horizontal, 40)
        }
    }
}





