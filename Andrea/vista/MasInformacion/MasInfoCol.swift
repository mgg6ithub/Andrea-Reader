
import SwiftUI

struct MasInfoCol: View {
    
    @EnvironmentObject var ap: AppEstado
    @Binding var pantallaCompleta: Bool
    @ObservedObject var vm: ModeloColeccion
    
    @State private var show: Bool = true
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(pantallaCompleta ? 0.9 : 0.65)
                .ignoresSafeArea()
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
                
                let escala: CGFloat = pantallaCompleta ? 1.0 : 1.0
                
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .center, spacing: 0) {
                        CabeceraColeccionMI(vm: vm, pantallaCompleta: $pantallaCompleta)
                            .padding(.bottom, 5)
                        
                        MasInformacionColeccion(vm: vm, pantallaCompleta: $pantallaCompleta, escala: escala)
                        
                        Spacer()
                    }
                    .frame(
                        width: pantallaCompleta ? cW : cWSmall,
                        height: pantallaCompleta ? cH : cHSmall
                    ) // Altura dinámica
                    .background(ap.temaResuelto.backgroundGradient.ignoresSafeArea())
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
