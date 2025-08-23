

import SwiftUI

struct InformacionVelocidadGrafico: View {
    
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    var body: some View {
        VStack(alignment: .center) {
            
            VStack {
                Text("Velocidad de lectura")
                
                HStack(spacing: 15) {
                    HStack {
                        VStack {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text("med:")
                                .font(.caption2)
                        }
                        
                        Text("2.3 p/m")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        VStack {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.green)
                            Text("max:")
                                .font(.caption2)
                        }
                        
                        Text("4.0 p/m")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        VStack {
                            Image(systemName: "arrow.down")
                                .foregroundColor(.red)
                            Text("min:")
                                .font(.caption2)
                        }
                        
                        Text("1.2 p/m")
                            .font(.subheadline)
                    }
                    
                }
                .padding(.horizontal)
            }
            .frame(height: 50)
            
            GraficoVelocidadLectura(estadisticas: estadisticas)
        }
    }
}
