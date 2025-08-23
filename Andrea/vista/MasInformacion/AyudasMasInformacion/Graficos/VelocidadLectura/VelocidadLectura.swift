

import SwiftUI

struct InformacionVelocidadGrafico: View {
    
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    var body: some View {
        VStack(alignment: .center) {
            
            VStack {
                Text("Velocidad de lectura")
                
                HStack(spacing: 15) {
                    HStack {
//                        VStack {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
//                            Text("med:")
//                                .font(.caption2)
//                        }
                        
                        Text(String(format: "%.2f", estadisticas.velocidadSesionMed))
                            .font(.subheadline)
                        
                        Text("p/m")
                            .font(.caption2)
                    }
                    
                    HStack {
//                        VStack {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.green)
//                            Text("max:")
//                                .font(.caption2)
//                        }
                        
                        Text(String(format: "%.2f", estadisticas.velocidadSesionMax))
                            .font(.subheadline)
                        
                        Text("p/m")
                            .font(.caption2)
                    }
                    
                    HStack {
//                        VStack {
                            Image(systemName: "arrow.down")
                                .foregroundColor(.red)
//                            Text("min:")
//                                .font(.caption2)
//                        }
                        
                        Text(String(format: "%.2f", estadisticas.velocidadSesionMin))
                            .font(.subheadline)
                        
                        Text("p/m")
                            .font(.caption2)
                    }
                    
                }
                .padding(.horizontal)
            }
            .frame(height: 50)
            
            GraficoVelocidadLectura(estadisticas: estadisticas)
        }
    }
}
