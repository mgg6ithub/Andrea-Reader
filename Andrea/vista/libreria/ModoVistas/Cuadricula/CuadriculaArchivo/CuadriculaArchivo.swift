import SwiftUI

struct CuadriculaArchivo: View {
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ArchivoThumbnailViewModel()
    let colorColeccion: Color
    @State private var isVisible = false
    var width: CGFloat = 180  // Esto lo puedes inyectar dinámicamente

    var body: some View {
        VStack(spacing: 0) {

            // --- Imagen ---
            ZStack {
                
                if let img = viewModel.thumbnail {
                    Image(uiImage: img)
                        .resizable()
//                        .frame(maxWidth: .infinity)
                } else {
                    ProgressView()
                }
                
                // --- Progreso ---
                VStack {
                    Spacer()
                    ProgresoCuadricula(archivo: archivo, colorColeccion: colorColeccion)
                }
                
            }
            .frame(width: width) // solo limitamos ancho
            
            // --- Titulo e informacion ---
            TituloInformacion(archivo: archivo, colorColeccion: colorColeccion)
            
        }
        .frame(width: width, height: 310)
        .background(Color(.systemGray6))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            guard viewModel.thumbnail == nil else { return }
            
            viewModel.loadThumbnail(for: archivo, allowGeneration: !archivo.hasThumbnail)

            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0...0.2))) {
                isVisible = true
            }
        }
        .onDisappear {
            viewModel.unloadThumbnail(for: archivo)
        }

    }
    
}


class ArchivoThumbnailViewModel: ObservableObject {
    @Published var thumbnail: UIImage? = nil
    private var pendingKey: NSString? = nil

    func loadThumbnail(for archivo: Archivo, allowGeneration: Bool = true) {
        let key = archivo.url.path as NSString
        pendingKey = key

        // Primero intentamos del cache de ThumbnailService
        if let cached = ThumbnailService.shared.cache.object(forKey: key) {
            DispatchQueue.main.async {
                self.thumbnail = cached
            }
            return
        }

        ThumbnailService.shared.thumbnail(for: archivo, allowGeneration: allowGeneration) { [weak self] image in
            DispatchQueue.main.async {
                guard self?.pendingKey == key else {
                    // Si ya cancelamos o la celda se recicla, no asignamos
                    return
                }
                self?.thumbnail = image
                if let image = image {
                    let size = self?.sizeInMB(of: image) ?? "N/A"
//                    print("✅ Loaded thumbnail for \(archivo.name) - size: \(size)")
                }
            }
        }
    }

    func unloadThumbnail(for archivo: Archivo) {
        // 1) Limpia la imagen en la ViewModel
        let before = sizeInMB(of: thumbnail)
        thumbnail = nil
        pendingKey = nil
//        print("🗑️ ViewModel: thumbnail nil for \(archivo.name) (was \(before))")

        // 2) Elimina del cache en memoria
        ThumbnailService.shared.removeCache(for: archivo)
    }

    private func sizeInMB(of image: UIImage?) -> String {
        guard let cg = image?.cgImage else { return "N/A" }
        let bytes = cg.bytesPerRow * cg.height
        return String(format: "%.2f MB", Double(bytes) / (1024*1024))
    }
}


