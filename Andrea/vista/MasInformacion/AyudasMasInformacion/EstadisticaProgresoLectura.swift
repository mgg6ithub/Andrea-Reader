

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

struct EstadisticasProgresoLectura: View {
    
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
                        InformacionVelocidadGrafico(estadisticas: sss)
                    } else if !cambio {
                        InformacionProgresoGrafico()
                    }
                }
                
            }
            .padding(.leading, 20)
            

        }
    }
}


