import SwiftUI

struct GraficoGithubStyle: View {
    // Datos: nombre, cantidad, color base
    let datos: [(String, Int, Color)] = [
        ("CBZ", 60, .blue),
        ("CBR", 26, .green),
        ("PDF", 13, .orange),
        ("TXT", 5, .purple),
        ("EPUB", 5, .red)
    ]
    
    var total: Int {
        datos.map { $0.1 }.reduce(0, +)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 🔹 Barra segmentada
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(datos, id: \.0) { tipo, cantidad, color in
                        let porcentaje = CGFloat(cantidad) / CGFloat(total)
                        
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
            
            // 🔹 Leyenda en cuadrícula adaptable
            let columnas = [
                GridItem(.adaptive(minimum: 90), alignment: .leading)
            ]
            
            LazyVGrid(columns: columnas, alignment: .leading, spacing: 8) {
                ForEach(datos, id: \.0) { tipo, cantidad, color in
                    let porcentaje = Double(cantidad) / Double(total) * 100
                    
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

