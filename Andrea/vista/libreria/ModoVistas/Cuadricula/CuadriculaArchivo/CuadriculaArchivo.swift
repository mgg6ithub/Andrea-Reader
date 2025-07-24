import SwiftUI

struct CuadriculaArchivo: View {
    
    @EnvironmentObject var appEstado: AppEstado
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @ObservedObject var coleccionVM: ModeloColeccion

    @State private var miniatura: UIImage? = nil
    @State private var isVisible = false
    
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        VStack(spacing: 0) {

            // --- Imagen ---
            ZStack {
                if let img = viewModel.miniatura {
                    Image(uiImage: img)
                        .resizable()
                } else {
                    ProgressView()
                }
                
                VStack {
                    Spacer()
                    ProgresoCuadricula(
                        progreso: archivo.fileProgressPercentage,
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
                nombre: archivo.name,
                tipo: archivo.fileType.rawValue,
                tamanioMB: archivo.fileSize / (1024*1024),
                totalPaginas: archivo.totalPaginas,
                progreso: archivo.fileProgressPercentage,
                coleccionColor: coleccionVM.color,
                maxWidth: width
            )
            .equatable()
            .onAppear {
                if archivo.totalPaginas == nil {
                    archivo.cargarPaginasAsync()
                }
            }
        }
        .frame(width: width, height: height)
        .background(appEstado.temaActual.cardColor)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.2), radius: 2.5, x: 0, y: 1)
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)
            isVisible = true
        }
        .onDisappear { viewModel.unloadThumbnail(for: archivo) }

    }
    
}



