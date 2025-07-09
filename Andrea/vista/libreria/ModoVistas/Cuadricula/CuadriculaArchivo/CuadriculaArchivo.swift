import SwiftUI

struct CuadriculaArchivo: View {
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ArchivoThumbnailViewModel()
    let coleccion: Coleccion
    @State private var isVisible = false
    var width: CGFloat = 180  // Esto lo puedes inyectar dinámicamente

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
                
                // --- Progreso ---
                VStack {
                    Spacer()
                    ProgresoCuadricula(archivo: archivo, colorColeccion: coleccion.directoryColor)
                }
                
            }
            .frame(width: width) // solo limitamos ancho
            
            // --- Titulo e informacion ---
            TituloInformacion(archivo: archivo, colorColeccion: coleccion.directoryColor)
            
        }
        .frame(width: width, height: 310)
        .background(Color(.systemGray6))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
//            guard viewModel.miniatura == nil else { return }
            
            viewModel.loadThumbnail(coleccion: coleccion, for: archivo)

            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0.0...0.2))) {
                isVisible = true
            }
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

    func loadThumbnail(coleccion: Coleccion, for archivo: Archivo, allowGeneration: Bool = true) {
        // Cancelamos cualquier carga anterior
        cargaTask?.cancel()

        // Creamos nueva carga como Task
        cargaTask = Task {
            // 1. Consultamos cache
            if let miniaturaCacheada = mm.obtenerMiniatura(archivo: archivo) {
                print("✅ Miniatura desde cache para: \(archivo.name)")
                await MainActor.run {
                    self.miniatura = miniaturaCacheada
                }
                return
            }

            // 2. Generamos desde 0
            guard !Task.isCancelled else { return }

            // convertimos construirMiniatura a async (más abajo te explico cómo)
            if let miniaturaNueva = await construirMiniaturaAsync(coleccion: coleccion, archivo: archivo) {
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
    private func construirMiniaturaAsync(coleccion: Coleccion, archivo: Archivo) async -> UIImage? {
        await withCheckedContinuation { continuation in
            mm.construirMiniatura(coleccion: coleccion, archivo: archivo) { image in
                continuation.resume(returning: image)
            }
        }
    }
}



