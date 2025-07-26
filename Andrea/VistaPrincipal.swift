import SwiftUI

struct VistaPrincipal: View {
    
    @State private var animacionesInicialesActivadas = false
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State private var ultimaID: UUID? = nil
    
    @State private var coleccionMostrada: ModeloColeccion? = nil
    
    private var viewMode: EnumModoVista { menuEstado.modoVistaColeccion }
    private let constantes = ConstantesPorDefecto()
    
    var body: some View {
        ZStack {
            appEstado.temaActual.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    MenuVista()
                        .padding(.vertical, 8)
                    
                    HistorialColecciones()
                        .frame(height: 50)
                        .padding(.bottom, 8)
                }
                .padding(.horizontal, constantes.horizontalPadding)
                
                Spacer()
                
                if let coleccion = coleccionMostrada {
                    Libreria(vm: coleccion)
                        .id(coleccion.coleccion.id) // <- Esto fuerza a SwiftUI a tratarlo como una nueva vista (clave)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
//                        .transition(.move(edge: .bottom).combined(with: .opacity))
//                        .transition(.asymmetric(
//                            insertion: .opacity.combined(with: .move(edge: .bottom)),
//                            removal: .opacity.combined(with: .scale)
//                        ))
//                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 0.95)), removal: .opacity.combined(with: .scale(scale: 0.95))))
                }
                
            }
            .onAppear {
                coleccionMostrada = pc.getColeccionActual()
            }
            .padding(0)
            .onChange(of: pc.coleccionActualVM?.coleccion.id) { nuevoID in
                // Solo si ha cambiado de verdad
                guard nuevoID != coleccionMostrada?.coleccion.id else { return }

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
