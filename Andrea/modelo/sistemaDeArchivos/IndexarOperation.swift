import SwiftUI

class IndexarOperation: Operation {
    let coleccionURL: URL
    weak var sistemaArchivos: SistemaArchivos?
    var elementosFinales: [any ElementoSistemaArchivosProtocolo] = []

    init(coleccionURL: URL, sistemaArchivos: SistemaArchivos) {
        self.coleccionURL = coleccionURL
        self.sistemaArchivos = sistemaArchivos
    }

    override func main() {
        guard let sistemaArchivos = sistemaArchivos else { return }

        // 1. Limpiar lista elementos antes de comenzar (en main queue)
        DispatchQueue.main.sync {
            sistemaArchivos.listaElementos.removeAll()
        }
        if isCancelled { return }

        // 2. Obtener URLs directorio
        let allURLs = sistemaArchivos.obtenerURLSDirectorio(coleccionURL: coleccionURL)
        if isCancelled { return }

        // 3. Filtrar elementos
        let filteredElements = allURLs.filter { url in
            SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.filtrosIndexado.allSatisfy {
                $0.shouldInclude(url: url)
            }
        }
        if isCancelled { return }

        let total = filteredElements.count
        // Obtener el centro (scrollPosition) para este directorio, si existe
        let centerIndex = sistemaArchivos.coleccionActual.scrollPosition
        let orderedIndices: [Int]
        if let center = centerIndex, center < total {
            orderedIndices = Self.indicesDesdeCentro(total: total, centro: center)
        } else {
            orderedIndices = Array(0..<total)
        }

        // 4. Crear placeholders y asignar (en main queue)
        DispatchQueue.main.sync {
            sistemaArchivos.listaElementos = Array(
                repeating: ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo,
                count: total
            )
        }
        if isCancelled { return }

        // 5. Crear instancias de elementos en orden centrado
        var tempElementos: [any ElementoSistemaArchivosProtocolo] = Array(
            repeating: ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo,
            count: total
        )

        for originalIndex in orderedIndices {
            if isCancelled { break }
            let url = filteredElements[originalIndex]
            if let elemento = sistemaArchivos.crearInstancia(elementoURL: url) {
                tempElementos[originalIndex] = elemento
                DispatchQueue.main.async {
                    // Aseguramos que la lista no cambió
                    if originalIndex < sistemaArchivos.listaElementos.count {
                        sistemaArchivos.listaElementos[originalIndex] = elemento
                    }
                }
            }
        }
        if isCancelled { return }

        // Guardar resultado para usar luego en el main thread
        elementosFinales = tempElementos
    }

    /// Genera un arreglo de índices de 0..<total que comienza en "centro" y luego se expande hacia afuera.
    private static func indicesDesdeCentro(total: Int, centro: Int) -> [Int] {
        var resultado: [Int] = []
        var offset = 0
        while resultado.count < total {
            let i1 = centro - offset
            if i1 >= 0 {
                resultado.append(i1)
            }
            let i2 = centro + offset
            if offset != 0 && i2 < total {
                resultado.append(i2)
            }
            offset += 1
        }
        return resultado
    }
}

