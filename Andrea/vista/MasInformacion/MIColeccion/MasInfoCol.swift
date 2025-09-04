
import SwiftUI

#Preview {
    pMIcoleccion1()
}
//
private struct pMIcoleccion1: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInfoCol(
            pantallaCompleta: $pantallaCompleta, vm: ModeloColeccion()
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct MasInfoCol: View {
    
    @EnvironmentObject var ap: AppEstado
    @Binding var pantallaCompleta: Bool
    @ObservedObject var vm: ModeloColeccion
    
    @State private var seleccionColeccion: EnumSeccionColeccion = .coleccion
    @State private var show: Bool = true
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(pantallaCompleta ? 0.9 : 0.65)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.3), value: pantallaCompleta)
                .onTapGesture {
                    if !pantallaCompleta {
                        withAnimation(.easeInOut(duration: 0.25)) { ap.masInformacionColeccion = false }
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
                        CabeceraColeccionMI(vm: vm, pantallaCompleta: $pantallaCompleta, escala: escala, seleccionColeccion: $seleccionColeccion)
                            .padding(.bottom, 5)
                        
                        TituloYAjustesColeccion(vm: vm, pantallaCompleta: $pantallaCompleta)
                        
                        // Aquí el contenido según la selección
                        switch seleccionColeccion {
                            
                        case .coleccion:
                            MasInformacionColeccion(vm: vm, pantallaCompleta: $pantallaCompleta, escala: escala)
                        case .progreso:
                            ProgresoColeccion(vm: vm, pantallaCompleta: $pantallaCompleta, escala: escala)
                        }
                        
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
