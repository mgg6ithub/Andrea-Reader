import SwiftUI

struct CuadriculaArchivo: View {
    
    @EnvironmentObject var appEstado: AppEstado
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @ObservedObject var coleccionVM: ModeloColeccion

    @State private var isVisible = false
    
    var width: CGFloat
    var height: CGFloat
    
    @State private var mostrarMiniatura = false

    var body: some View {
        VStack(spacing: 0) {

            // --- Imagen ---
            ZStack {
                if let img = viewModel.miniatura {
                    Image(uiImage: img)
                        .resizable()
                        .scaleEffect(mostrarMiniatura ? 1 : 0.95)
                        .opacity(mostrarMiniatura ? 1 : 0)
                        .animation(.easeOut(duration: 0.3), value: mostrarMiniatura)
                        .onAppear {
                            mostrarMiniatura = true
                        }
                } else {
                    ProgressView()
                }
                
                VStack {
                    Spacer()
                    ProgresoCuadricula(
                        progreso: archivo.progreso,
                        coleccionColor: coleccionVM.color,
                        totalWidth: width - 20
                    )
                    .frame(maxHeight: 24) // ← Altura máxima fija para evitar saltos
                }
                .frame(maxHeight: .infinity, alignment: .bottom) // 👈 fuerza que siempre esté abajo
                .padding(.bottom, 6)
            }
            .frame(width: width)
            
            // --- Titulo e informacion ---
            InformacionCuadricula(
                nombre: archivo.nombre,
                tipo: archivo.fileType.rawValue,
                tamanioMB: archivo.fileSize / (1024*1024),
                totalPaginas: archivo.totalPaginas,
                progreso: archivo.progreso,
                coleccionColor: coleccionVM.color,
                maxWidth: width
            )
            .equatable()
            
        }
        .frame(width: width, height: height)
        .background(appEstado.temaActual.cardColor)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.2), radius: 2.5, x: 0, y: 1)
//        .scaleEffect(isVisible ? 1 : 0.95)
//        .opacity(isVisible ? 1 : 0)
        .onAppear {
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)
//            isVisible = true
            mostrarMiniatura = false // ← reinicia animación si se reutiliza la celda
        }
        .onDisappear { 
//            isVisible = false
            viewModel.unloadThumbnail(for: archivo)
        }
        .onChange(of: archivo.tipoMiniatura) {
            print("CAMBIANDO MINIATURA EN LA VISTA")
            viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
        }

    }
    
}



