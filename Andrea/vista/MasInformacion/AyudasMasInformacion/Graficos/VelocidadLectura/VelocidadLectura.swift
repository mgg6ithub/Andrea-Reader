

import SwiftUI

struct InformacionVelocidadGrafico: View {
    
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @State private var verTodo: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            
            VStack {
                Text("Velocidad de lectura")
                
                HStack(spacing: 15) {
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            verTodo.toggle()
                        }
                    }) {
                        Text("Ver todo")
                            .font(.footnote)
                    }
                    .zIndex(1)
                    .padding(5) // margen interno
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.2))
                    )
                    .padding(.trailing, 15)
                    
                    HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                        
                        Text(String(format: "%.2f", estadisticas.velocidadSesionMed))
                            .font(.subheadline)
                        
                        Text("p/m")
                            .font(.caption2)
                    }
                    
                    HStack {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.green)
                        
                        Text(String(format: "%.2f", estadisticas.velocidadSesionMax))
                            .font(.subheadline)
                        
                        Text("p/m")
                            .font(.caption2)
                    }
                    
                    HStack {
                            Image(systemName: "arrow.down")
                                .foregroundColor(.red)
                        
                        Text(String(format: "%.2f", estadisticas.velocidadSesionMin))
                            .font(.subheadline)
                        
                        Text("p/m")
                            .font(.caption2)
                    }
                    
                }
            }
            .frame(height: 50)
            
            GraficoVelocidadLectura(estadisticas: estadisticas, verTodo: $verTodo)
        }
    }
}
