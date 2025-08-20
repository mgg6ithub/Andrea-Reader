
import SwiftUI

class ModeloMiniaturaArchivo: ObservableObject {
    @Published var miniatura: UIImage? = nil
    
    private let mm: ModeloMiniatura = ModeloMiniatura.modeloMiniatura
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
    
    public func cambiarMiniatura(color: Color, archivo: Archivo, tipoMiniatura: EnumTipoMiniatura) {
        
        switch tipoMiniatura {
        case .imagenBase:
            self.miniatura = mm.imagenBase(tipoArchivo: archivo.fileType, color: color)
        case .primeraPagina:
            self.miniatura = mm.obtenerMiniatura(archivo: archivo) //Tiene que estar ya en cache si no fallara
        default:
            self.miniatura = mm.imagenBase(tipoArchivo: archivo.fileType, color: color)
        }
        
    }
    
//    public func cambiarMiniaturaColeccion() {
//        
//    }
    
}
