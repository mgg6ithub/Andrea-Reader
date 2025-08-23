import SwiftUI
import Charts

struct PageVisitCount: Identifiable {
    var id: Int { page }   // clave estable
    let page: Int
    let count: Int
}

extension EstadisticasYProgresoLectura {
    /// Devuelve solo las páginas más visitadas (ej. top N), ordenadas por número de página
    func topPaginasMasVisitadas(limit: Int) -> [PageVisitCount] {
        let sortedByCount = visitasPorPagina
            .map { (page, count) in PageVisitCount(page: page, count: count) }
            .sorted { $0.count > $1.count }   // más visitas primero
        
        let topN = Array(sortedByCount.prefix(limit))
        return topN.sorted { $0.page < $1.page }  // ordenadas por número de página
    }
}


struct GraficoPaginasMasVisitadas: View {
    
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    var data: [PageVisitCount] {
        estadisticas.topPaginasMasVisitadas(limit: 14)
    }
    
    var average: Double {
        guard !data.isEmpty else { return 0 }
        return Double(data.map(\.count).reduce(0, +)) / Double(data.count)
    }
    
    // Top 5 páginas con más visitas
    var topFivePages: Set<Int> {
        let sorted = data.sorted { $0.count > $1.count }
        return Set(sorted.prefix(5).map { $0.page })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Página", String(item.page)),
                        y: .value("Visitas", item.count),
                        width: 28
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.6),
                                Color.purple.opacity(0.1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(2)
                    .annotation(position: .top) {
                        if topFivePages.contains(item.page) {
                            Text("\(item.count)")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.purple)
                                .offset(y: -8)
                        }
                    }
                }
                
                RuleMark(y: .value("Promedio", average))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(.purple)
                    .annotation(position: .overlay) {
                        HStack {
                            Spacer()
                            Text("Avg \(String(format: "%.1f", average))")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.purple)
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
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0))
                }
            }
            .frame(height: 220)
            .padding(.horizontal, 40)
        }
    }
}

