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
            guard viewModel.miniatura == nil else { return }
            
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

    func loadThumbnail(coleccion: Coleccion, for archivo: Archivo, allowGeneration: Bool = true) {
        
        //1. Comprobamos cache de miniaturas
        if let miniaturaCacheada = mm.obtenerMiniatura(archivo: archivo) {
            
            print("Esta en cache para: ", archivo.name)
            print()
            
            DispatchQueue.main.async {
                self.miniatura = miniaturaCacheada
            }
            return
        }
        
        //2. Creamos desde 0
        mm.construirMiniatura(coleccion: coleccion, archivo: archivo) { [weak self] image in
           guard let self = self, let img = image else { return }
           // Ya dentro de construirMiniatura haces DispatchQueue.main.async para el completion
           // Si no, asegúrate de hacerlo aquí:
           DispatchQueue.main.async {
               self.miniatura = img
           }
       }
        
    }

    func unloadThumbnail(for archivo: Archivo) {
        // 1) Limpia la imagen en la ViewModel
//        let before = sizeInMB(of: miniatura)
        miniatura = nil
//        print("🗑️ ViewModel: thumbnail nil for \(archivo.name) (was \(before))")

        // 2) Elimina del cache en memoria
//        mm.eliminarMiniatura(archivo: archivo)
    }

    private func sizeInMB(of image: UIImage?) -> String {
        guard let cg = image?.cgImage else { return "N/A" }
        let bytes = cg.bytesPerRow * cg.height
        return String(format: "%.2f MB", Double(bytes) / (1024*1024))
    }
}


