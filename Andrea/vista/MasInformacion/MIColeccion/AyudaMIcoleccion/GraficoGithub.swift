import SwiftUI

struct GraficoGithubStyle: View {
    @ObservedObject var estadisticas: EstadisticasColeccion
    
    var total: Int {
        estadisticas.distribucionTipos.map { $0.1 }.reduce(0, +)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Barra segmentada
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(estadisticas.distribucionTipos, id: \.0) { tipo, cantidad, color in
                        let porcentaje = CGFloat(cantidad) / CGFloat(max(total, 1))
                        
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.8), color]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geo.size.width * porcentaje, height: 12)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .frame(height: 12)
            
            // Leyenda
            let columnas = [GridItem(.adaptive(minimum: 90), alignment: .leading)]
            
            LazyVGrid(columns: columnas, alignment: .leading, spacing: 8) {
                ForEach(estadisticas.distribucionTipos, id: \.0) { tipo, cantidad, color in
                    let porcentaje = Double(cantidad) / Double(max(total, 1)) * 100
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [color.opacity(0.7), color]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 10, height: 10)
                        
                        Text(tipo)
                            .font(.subheadline).bold()
                        
                        Text("\(Int(porcentaje))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}


