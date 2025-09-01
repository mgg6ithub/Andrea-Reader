

import SwiftUI
import Charts

//#Preview {
//    PreviewMasInformacion()
//}
//
//private struct PreviewMasInformacion: View {
//    @State private var pantallaCompleta = false
//    
//    var body: some View {
//        MasInformacion(
//            pantallaCompleta: $pantallaCompleta,
//            vm: ModeloColeccion(),
//            elemento: Archivo.preview
//        )
////                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
////                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
//    }
//}

struct Botones: View {
    
    @Binding var cambio: Bool
    let tituloVerdad: String
    let tituloFalso: String
    
    var body: some View {
        HStack{
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    cambio = true
                }
            }) {
                HStack(spacing: 4) {
                    Text(tituloVerdad)
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
                    Text(tituloFalso)
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

#Preview {
    EstadisticasProgresoLectura(archivo: Archivo.preview)
}
 
struct EstadisticasProgresoLectura: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    
    @State private var cambio: Bool = true
    
    private var sss: EstadisticasYProgresoLectura { archivo.estadisticas }
    private var tema: EnumTemas { ap.temaResuelto }
    private var const: Constantes { ap.constantes }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 4) {
                Spacer()

                Image(systemName: "book")
                    .font(.system(size: const.iconSize * 0.75, weight: .medium))
                
                Text(String.localizedStringWithFormat("%d %@",
                    sss.sesionesLectura.count,
                    sss.sesionesLectura.count == 1 ? "sesión de lectura" : "sesiones de lectura"
                ))
                .font(.system(size: const.titleSize * 0.8))
                .bold()
                .offset(y: 2)
                
                Spacer()
            }
            .padding(.bottom, 25)
            
            HStack(alignment: .top, spacing: 20) {
                
                VStack(alignment: .center, spacing: 15) {
                    ProgresoCircular(titulo: "progreso", progreso: sss.progreso, progresoDouble: sss.progresoDouble, color: .green)
                    
                    VStack(alignment: .center, spacing: 4) {
                        HStack(spacing: 3) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: const.iconSize * 0.6))
                                .foregroundColor(.green.opacity(0.9))
                                .offset(y: -2.6)
                            
                            Text("Completado")
                                .font(.system(size: const.titleSize * 0.75))
                                .foregroundColor(tema.tituloColor)
                        }
                        
                        if let tot = sss.totalPaginas {
                            
                            HStack(alignment: .bottom, spacing: 2) {
                                Text("\(sss.paginaActual + 1)" + "/" + "\(tot)")
                                    .font(.system(size: const.subTitleSize * 0.75))
                                    .foregroundColor(tema.secondaryText)
                                
                                Text("páginas")
                                    .font(.system(size: const.subTitleSize * 0.65))
                                    .foregroundColor(tema.secondaryText.opacity(0.8))
                            }
                        }
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    ProgresoCircular(titulo: "tiempo", progreso: sss.progresoTiempoTotal, progresoDouble: sss.progresoTiempoTotalDouble, color: .blue)
                    
                    VStack(alignment: .center, spacing: 4) {
                        HStack(spacing: 3) {
                            Image(systemName: "clock")
                                .font(.system(size: const.iconSize * 0.65))
                                .foregroundColor(.blue.opacity(0.85))
                                .offset(y: -2)
                            Text("Tiempo de lectura")
                                .font(.system(size: const.titleSize * 0.75))
                                .foregroundColor(tema.tituloColor)
                        }
                            
                        HStack(spacing: 3) {
                            HStack(alignment: .bottom, spacing: 2) {
                                Text("Total")
                                    .font(.system(size: const.subTitleSize * 0.65))
                                    .foregroundColor(tema.secondaryText.opacity(0.8))
                                
                                Text("\(sss.tiempoTotal.formatted())")
                                    .font(.system(size: const.subTitleSize * 0.75))
                                    .foregroundColor(tema.secondaryText)
                            }
                            
                            Divider()
                            
                            HStack(alignment: .bottom, spacing: 2) {
                                Text("Falta")
                                    .font(.system(size: const.subTitleSize * 0.65))
                                    .foregroundColor(tema.secondaryText.opacity(0.8))
                                
                                Text("\(sss.tiempoRestante.formatted())")
                                    .font(.system(size: const.subTitleSize * 0.75))
                                    .foregroundColor(tema.secondaryText)
                            }
                             
                        }
                    
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    ProgresoCircular(titulo: "tamaño", progreso: 6, progresoDouble: 0.06, color: .red)
                    
                    VStack(alignment: .center, spacing: 4) {
                        HStack(spacing: 3) {
                            Image(systemName: "externaldrive")
                                .font(.system(size: const.iconSize * 0.65))
                                .foregroundColor(.red.opacity(0.85))
                                .offset(y: -1.7)
                            Text("Almacenamiento")
                                .font(.system(size: const.titleSize * 0.75))
                                .foregroundColor(tema.tituloColor)
                        }
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            Text("Ocupa")
                                .font(.system(size: const.subTitleSize * 0.65))
                                .foregroundColor(tema.secondaryText.opacity(0.8))
                            
                            Text("\(ManipulacionSizes().formatearSize(archivo.fileSize))")
                                .font(.system(size: const.subTitleSize * 0.75))
                                .foregroundColor(tema.secondaryText)
                            
                            Text("de")
                                .font(.system(size: const.subTitleSize * 0.65))
                                .foregroundColor(tema.secondaryText.opacity(0.8))
                            
                            Text("2 GB")
                                .font(.system(size: const.subTitleSize * 0.75))
                                .foregroundColor(tema.secondaryText)
                            
                        }
                    }
                }
                
//                Spacer()
            }
            
            
            
        }
    }
}


