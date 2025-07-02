
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
        
        // 4. Crear placeholders y asignar (en main queue)
        DispatchQueue.main.sync {
            sistemaArchivos.listaElementos = Array(
                repeating: ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo,
                count: filteredElements.count
            )
        }
        if isCancelled { return }
        
        // 5. Crear instancias de elementos
        var tempElementos: [any ElementoSistemaArchivosProtocolo] = Array(
            repeating: ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo,
            count: filteredElements.count
        )
        
        for (index, url) in filteredElements.enumerated() {
            if isCancelled { return }
            
            if let elemento = sistemaArchivos.crearInstancia(elementoURL: url) {
                tempElementos[index] = elemento
                
                DispatchQueue.main.async {
                    // Aseguramos que la lista no cambió
                    if index < sistemaArchivos.listaElementos.count {
                        sistemaArchivos.listaElementos[index] = elemento
                    }
                }
            }
        }
        
        if isCancelled { return }
        
        // Guardar resultado para usar luego en el main thread
        elementosFinales = tempElementos
    }
}
