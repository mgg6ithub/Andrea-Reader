

import SwiftUI

@MainActor
class ColeccionViewModel: ObservableObject {
    
  let coleccion: Coleccion
  @Published var elementos: [any ElementoSistemaArchivosProtocolo] = []
  @Published var isLoading = false
  @Published var scrollPosition: Int
  @Published var isPerformingAutoScroll = false

    init(_ coleccion: Coleccion) {
        self.coleccion = coleccion
        self.scrollPosition = PersistenciaDatos().obtenerPosicionScroll(coleccion: coleccion)

        print("🟠 Inicializando VM para colección: \(coleccion.name) con scrollPosition: \(self.scrollPosition)")

//        cargarElementos()
    }


    func cargarElementos() {
        isLoading = true

        // 1. Obtener las URLs y filtrarlas SINCRÓNICAMENTE para crear los placeholders
        let allURLs = SistemaArchivos.getSistemaArchivosSingleton.obtenerURLSDirectorio(coleccionURL: coleccion.url)
        let filteredURLs = allURLs.filter { url in
            SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.filtrosIndexado.allSatisfy {
                $0.shouldInclude(url: url)
            }
        }

        let total = filteredURLs.count
        elementos = (0..<total).map { _ in
            ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo
        }

        print("Placeholders cargados")
        print("Indice en ", self.scrollPosition)
        
        // 2. Scroll automático (lo activará la vista si isPerformingAutoScroll = true)
        self.isPerformingAutoScroll = true

        // 3. Indexado asincrónico y centrado
        Task.detached { [weak self] in
            guard let self = self else { return }
            
            let centro = await MainActor.run { self.scrollPosition }
            print("Rellenando placeholders desde ", centro)
            
            let urls = filteredURLs
            let indices = Algoritmos().generarIndicesDesdeCentro(centro, total: urls.count)

            for idx in indices {
                let url = urls[idx]
                if let elem = SistemaArchivos.getSistemaArchivosSingleton.crearInstancia(elementoURL: url) {
                    await MainActor.run {
                        var nuevos = self.elementos
                        nuevos[idx] = elem
                        self.elementos = nuevos
                    }
                }
            }

            await MainActor.run {
                self.isLoading = false
            }
        }


    }
    
    func actualizarScroll(_ nuevo: Int) {
//        print("🟡 Scroll actualizado a: \(nuevo) para colección: \(coleccion.name)")

        scrollPosition = nuevo
        coleccion.scrollPosition = nuevo

        PersistenciaDatos().guardarPosicionScroll(coleccion: coleccion)
    }
    
}

