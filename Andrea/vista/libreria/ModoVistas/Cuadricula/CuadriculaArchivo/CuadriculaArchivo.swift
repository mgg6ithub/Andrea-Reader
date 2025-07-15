import SwiftUI

struct CuadriculaArchivo: View {
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ArchivoThumbnailViewModel()
    @ObservedObject var coleccionVM: ColeccionViewModel
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
//                        .transition(.opacity)                  // <-- transición de aparición
                } else {
                    ProgressView()
//                        .transition(.opacity)                  // <-- transición de desaparición
                }
                VStack {
                    Spacer()
                    ProgresoCuadricula(archivo: archivo, coleccionVM: coleccionVM)
                }
            }
            .frame(width: width)
//            .animation(.easeInOut(duration: 0.3), value: viewModel.miniatura)  // <-- anima cuando cambia miniatura
            
            // --- Titulo e informacion ---
            TituloInformacion(archivo: archivo, coleccionVM: coleccionVM)
            
        }
        .frame(width: width, height: height)
        .background(Color(.systemGray6))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)

//            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0.2...0.4))) {
                isVisible = true
//            }
        }
        .onDisappear {
            viewModel.unloadThumbnail(for: archivo)
        }

    }
    
}

class ArchivoThumbnailViewModel: ObservableObject {
    @Published var miniatura: UIImage? = nil
    
    private let mm: ModeloMiniatura = ModeloMiniatura.getModeloMiniaturaSingleton
    private var cargaTask: Task<Void, Never>? = nil

    func loadThumbnail(color: Color, for archivo: Archivo, allowGeneration: Bool = true) {
        
        guard miniatura == nil else { return }
        
        // Cancelamos cualquier carga anterior
        cargaTask?.cancel()

        // Creamos nueva carga como Task
        cargaTask = Task {
            // 1. Consultamos cache
            if let miniaturaCacheada = mm.obtenerMiniatura(archivo: archivo) {
                await MainActor.run {
                    self.miniatura = miniaturaCacheada
                }
                return
            }

            // 2. Generamos desde 0
            guard !Task.isCancelled else { return }

            // convertimos construirMiniatura a async (más abajo te explico cómo)
            if let miniaturaNueva = await construirMiniaturaAsync(color: color, archivo: archivo) {
                await MainActor.run {
                    self.miniatura = miniaturaNueva
                }
            }
        }
    }

    func unloadThumbnail(for archivo: Archivo) {
        cargaTask?.cancel()
        miniatura = nil
    }

    /// Convierte el método callback en uno async usando `withCheckedContinuation`
    private func construirMiniaturaAsync(color: Color, archivo: Archivo) async -> UIImage? {
        await withCheckedContinuation { continuation in
            mm.construirMiniatura(color: color, archivo: archivo) { image in
                continuation.resume(returning: image)
            }
        }
    }
}



