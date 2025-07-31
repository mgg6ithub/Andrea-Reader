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
                    if menuEstado.seleccionMultiplePresionada {
                        if let coleccion = coleccionMostrada {
                            MenuSeleccionMultipleArriba(vm: coleccion)
                                .frame(width: .infinity, height: 50)
                                .background(.gray.opacity(0.2))
                        }
                    } else {
                        VStack(spacing: 0) {
                            MenuVista()
                                .padding(.vertical, 8)
                                .padding(.bottom, 15)
                            
                            HistorialColecciones()
                                .frame(height: 50)
                        }
                        .padding(.horizontal, constantes.horizontalPadding)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: menuEstado.seleccionMultiplePresionada)
                
                Spacer()
                
                if let coleccion = coleccionMostrada {
                    Libreria(vm: coleccion)
                    // --- ANIMACIONES DE CAMBIO DE COLECCION ---
                        .id(coleccion.coleccion.id)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                
                VStack(spacing: 0) {
                    if menuEstado.seleccionMultiplePresionada {
                        MenuSeleccionMultipleAbajo()
                            .frame(width: .infinity, height: 50)
                            .background(.gray.opacity(0.2))
                    } else {
                        EmptyView()
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: menuEstado.seleccionMultiplePresionada)
                
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
            
            if appEstado.masInformacion, let elementoSelecionado = appEstado.elementoSeleccionado {
                MasInformacion(vm: pc.getColeccionActual(), pantallaCompleta: $appEstado.pantallaCompleta, elemento: elementoSelecionado)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(10)
            }
            
            if appEstado.vistaPrevia, let elementoSelecionado = appEstado.elementoSeleccionado {
                CartaHolografica3D(vm: pc.getColeccionActual(), elemento: elementoSelecionado)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(10)
            }
            
        }
        .foregroundColor(appEstado.temaActual.textColor)
        .animation(.easeInOut, value: appEstado.temaActual)
    }
}
