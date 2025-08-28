

import SwiftUI
import Charts

struct PageTimeData: Identifiable {
    var id: Int { page }   // 👈 estable y único
    let page: Int
    let tiempo: Double
}

extension EstadisticasYProgresoLectura {
    /// Devuelve solo las páginas con mayor tiempo (ej. top N), ordenadas por número de página
    func topPaginasConMasTiempo(limit: Int) -> [PageTimeData] {
        let sortedByTiempo = tiemposPorPagina
            .map { (page, tiempo) in PageTimeData(page: page, tiempo: tiempo) }
            .sorted { $0.tiempo > $1.tiempo }   // orden descendente por tiempo
        
        let topN = Array(sortedByTiempo.prefix(limit))   // coger solo los N primeros
        
        return topN.sorted { $0.page < $1.page }  // ordenarlos por número de página
    }
}


struct GraficoTiempoPorPagina: View {
    
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    /// Datos ya transformados a `PageTimeData`
    var data: [PageTimeData] {
        estadisticas.topPaginasConMasTiempo(limit: 20)
    }
    
    var average: Double {
        guard !data.isEmpty else { return 0 }
        return data.map(\.tiempo).reduce(0, +) / Double(data.count)
    }
    
    // Páginas de los 4 elementos con más tiempo
    var topFourPages: Set<Int> {
        let sorted = data.sorted { $0.tiempo > $1.tiempo }
        return Set(sorted.prefix(5).map { $0.page })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Página", String(item.page)),
                        y: .value("Tiempo", item.tiempo),
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
                    .annotation(position: .top) {
                        if topFourPages.contains(item.page) {
                            Text("\(String(item.tiempo.formatted()))")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .offset(y: -8)
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
                            Text("Avg \(String(average.formatted()))")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.black)
                                .cornerRadius(4)
                                .foregroundColor(.white)
                                .padding(.trailing, 4)
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
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Páginas")
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3, dash: [2]))
                        .foregroundStyle(.gray.opacity(0.5))
                    AxisTick()
                    AxisValueLabel {
                        if let y = value.as(Double.self) {
                            Text("\(y.formatted())")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .chartYAxisLabel(position: .leading, alignment: .center) {
                Text("Tiempo")
                    .rotationEffect(.degrees(180))
            }

            .frame(height: 220)
        }
    }
}

