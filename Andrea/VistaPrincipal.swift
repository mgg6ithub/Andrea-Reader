import SwiftUI

struct VistaPrincipal: View {
    
    @State private var animacionesInicialesActivadas = false
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State private var coleccionMostrada: ModeloColeccion? = nil
    private let constantes = ConstantesPorDefecto()
    
    var body: some View {
        ZStack {
            appEstado.temaActual.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    MenuVista()
                        .padding(.vertical, 8)
                        .padding(.bottom, 15)
                    
                    HistorialColecciones()
                        .frame(height: 50)
//                        .padding(.bottom, 8)
                }
                .padding(.horizontal, constantes.horizontalPadding)
                
                Spacer()
                
                if let coleccion = coleccionMostrada {
                    Libreria(vm: coleccion)
                    // --- ANIMACIONES DE CAMBIO DE COLECCION ---
                        .id(coleccion.coleccion.id)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                
            }
            .onAppear {
                coleccionMostrada = pc.getColeccionActual()
            }
            .padding(0)
            .onChange(of: pc.coleccionActualVM?.coleccion.id) {
                // Solo si ha cambiado de verdad
                guard pc.coleccionActualVM?.coleccion.id != coleccionMostrada?.coleccion.id else { return }

                withAnimation(.easeOut(duration: 0.15)) {
                    coleccionMostrada = nil // Oculta la actual con transición
                }

                // Espera que se oculte antes de mostrar la nueva
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        coleccionMostrada = pc.getColeccionActual()
                    }
                }
            }

        }
        .foregroundColor(appEstado.temaActual.textColor)
        .animation(.easeInOut, value: appEstado.temaActual)
    }
}
