

import SwiftUI

//#Preview {
//    PreviewMasInformacion()
//}
//
//private struct PreviewMasInformacion: View {
//    @State private var pantallaCompleta = false
//
//    private let archivo = Archivo()
//
//    var body: some View {
//        MasInformacion(
//            pantallaCompleta: $pantallaCompleta,
//            elemento: archivo
//        )
////                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
////        .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
//    }
//}

struct CabeceraMasInformacion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let nombre: String
    @Binding var pantallaCompleta: Bool
    
    var cDinamico: Color { ap.temaActual.colorContrario }
    var padding: CGFloat { pantallaCompleta ? 20 : 10 }
    private let constantes = ConstantesPorDefecto()
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                isPressed = true
                withAnimation(.easeInOut(duration: 0.25)) { ap.masInformacion = false }
            }) {
                Image(systemName: "xmark.square.fill")
                    .font(.system(size: ap.constantes.iconSize * 1.5))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, Color.red)
                    .padding(padding)
                    .symbolEffect(.bounce, value: isPressed)
            }
            
            Spacer()
                                    
            Text(nombre)
                .font(.system(size: ap.constantes.titleSize * 1.45))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
            
            Spacer()
            
            Button(action: {
                pantallaCompleta.toggle()
            }) {
                HStack {
                                                        
                    Text(pantallaCompleta ? "Salir de Fullscreen" : "Fullscreen")
                        .font(.system(size: ap.constantes.subTitleSize * 0.9))
                        .foregroundColor(cDinamico)
                    
                    Divider()
                       .frame(width: 2, height: 20) // Ajusta la altura de la línea divisoria
                       .background(cDinamico) // Color de la línea divisoria
                       .clipShape(RoundedRectangle(cornerRadius: 40))
                    
                    Image(systemName: pantallaCompleta ? "square.resize.down" : "square.resize.up")
                        .font(.system(size: ap.constantes.iconSize * 0.9))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(cDinamico)
                        .animation(nil, value: pantallaCompleta)
                    
                }
                .padding(9)
                .background(pantallaCompleta ? Color.red : Color(UIColor.systemGray3))
                .cornerRadius(10)
                
            }
        }
        .padding(.horizontal, padding)
        .padding(.top, padding)
    }
}
