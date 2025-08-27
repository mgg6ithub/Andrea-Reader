

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
//                HStack {
//                    Text("Progreso lectura")
//                        .font(.system(size: 18))
//                        .bold()
//                        .padding(.top, 10)
//                    Spacer()
//                    Botones(cambio: $cambio, tituloVerdad: "velocidad", tituloFalso: "progreso")
//                        .padding(.trailing, 20)
//                }
            HStack(alignment: .top, spacing: 20) {
                
//                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    ProgresoCircular(titulo: "progreso", progreso: sss.progreso, progresoDouble: sss.progresoDouble, color: .green)
                    
                    VStack(alignment: .center, spacing: 7) {
                        Text("Completado")
                            .font(.system(size: const.titleSize * 0.75))
                            .foregroundColor(tema.tituloColor)
                        
                        if let tot = sss.totalPaginas {
                            Text("\(sss.paginaActual)" + "/" + "\(tot) páginas")
                                .font(.system(size: const.subTitleSize * 0.7))
                                .foregroundColor(tema.secondaryText)
                        }
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    ProgresoCircular(titulo: "tiempo", progreso: sss.progresoTiempoTotal, progresoDouble: sss.progresoTiempoTotalDouble, color: .blue)
                    
                    VStack(alignment: .center, spacing: 7) {
                        Text("Tiempo total")
                            .font(.system(size: const.titleSize * 0.75))
                            .foregroundColor(tema.tituloColor)
                            
                        Text(sss.tiempoTotal.formatted())
                            .font(.system(size: const.subTitleSize * 0.7))
                            .foregroundColor(tema.secondaryText)
                        
//                        Text("Tiempo restante")
//                            .font(.system(size: const.titleSize * 0.75))
//                            .foregroundColor(tema.tituloColor)
//                            
//                        Text(sss.tiempoRestante.formatted())
//                            .font(.system(size: const.subTitleSize * 0.7))
//                            .foregroundColor(tema.secondaryText)
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    ProgresoCircular(titulo: "tamaño", progreso: 6, progresoDouble: 0.06, color: .red)
                    
                    VStack(alignment: .center, spacing: 7) {
                        Text("Almacenamiento")
                            .font(.system(size: const.titleSize * 0.75))
                            .foregroundColor(tema.tituloColor)
                        
                        Text("Ocupa \(ManipulacionSizes().formatearSize(archivo.fileSize))" + " de " + "2 GB")
                            .font(.system(size: const.subTitleSize * 0.7))
                            .foregroundColor(tema.secondaryText)
                    }
                }
                
//                Spacer()
            }
            
            
            
        }
    }
}


