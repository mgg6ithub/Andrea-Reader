import SwiftUI
import Charts

//#Preview {
////    ProgresoTiempo(archivo: Archivo.preview)
//    PreviewMasInformacion2()
//}

//private struct PreviewMasInformacion2: View {
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


struct EstadisticaProgresoTiempo: View {
    
    @ObservedObject var archivo: Archivo
    @State private var cambio: Bool = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Tiempo total")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.bottom, 20)
                    Spacer()
                    Botones(cambio: $cambio, tituloVerdad: "mas tiempo", tituloFalso: "mas visitas")
                        .padding(.trailing, 20)
                }
                HStack {
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
                    
                    if cambio {
                        GraficoTiempoPorPagina(estadisticas: archivo.estadisticas)
                    } else {
                        GraficoPaginasMasVisitadas(estadisticas: archivo.estadisticas)
                    }
                }
                
            }
            .padding(.leading, 20)
            
            

        }
    }
}








