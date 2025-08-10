

import SwiftUI

#Preview {
    PreviewMasInformacion()
}

private struct PreviewMasInformacion: View {
    @State private var pantallaCompleta = false
    
    private let archivo = Archivo()
    
    var body: some View {
        MasInformacion(
            pantallaCompleta: $pantallaCompleta,
            elemento: archivo
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // iphone s3
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // iphone 15
                .environmentObject(AppEstado(screenWidth: 744, screenHeight: 1133)) //ipad mini    
//                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180)) //ipad 10 gen
//                .environmentObject(AppEstado(screenWidth: 834, screenHeight: 1194)) //ipad 11 Pro
//                .environmentObject(AppEstado(screenWidth: 1024, screenHeight: 1366)) //ipad 12 12.92
        
    }
}

struct MasInformacion: View {
    
    @EnvironmentObject var ap: AppEstado
    @Binding var pantallaCompleta: Bool
    
    let elemento: any ElementoSistemaArchivosProtocolo
    
    @State private var show: Bool = true
    
    var body: some View {
        
        ZStack {
            
            Color.black.opacity(pantallaCompleta ? 0.9 : 0.65)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 0.3), value: pantallaCompleta)
                .onTapGesture {
                    if !pantallaCompleta {
                        withAnimation(.easeInOut(duration: 0.25)) { ap.masInformacion = false }
                    }
                }
            
            GeometryReader { geometry in
                
                let cW: CGFloat = geometry.size.width
                let cH: CGFloat = geometry.size.height
                
                let cWSmall: CGFloat = cW * 0.8
                let cHSmall: CGFloat = cH * 0.8
                
                let escala: CGFloat = pantallaCompleta ? 1.0 : 0.8
                
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .center, spacing: 0) {
                        CabeceraMasInformacion(pantallaCompleta: $pantallaCompleta)
                            .aparicionBlur(show: $show)
//                            .border(.green)
                        
                        if let archivo = elemento as? Archivo {
                            MasInformacionArchivo(archivo: archivo, pantallaCompleta: $pantallaCompleta)
                                .scaleEffect(escala)
                                .padding(.vertical, pantallaCompleta ? 0 : ap.resolucionLogica == .small ? -80 : -100)
//                                .border(.red)
                        }
                        
                        Spacer()
                    }
                    .frame(
                        width: pantallaCompleta ? cW : cWSmall,
                        height: pantallaCompleta ? cH : cHSmall
                    ) // Altura dinámica
                    .background(Color(ap.temaActual == .dark ? UIColor.systemGray5 : UIColor.systemGray6))
                    .cornerRadius(pantallaCompleta ? 0 : 15)
                    .shadow(radius: !pantallaCompleta ? 10 : 0)
                    .transition(.opacity.combined(with: .scale)) // Transición más suave
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: pantallaCompleta)
                    //                    .fixedSize()
                } //FIN PRIMER VSTACK
                .frame(maxWidth: cW, maxHeight: cH)
                
            } //FIN GEOMETRY
        } //FIN ZStack
        
    }
    
}
