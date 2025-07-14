
//import SwiftUI
//
//class IndexarOperation: Operation {
//    
//    let coleccionActual: Coleccion
//    weak var sistemaArchivos: SistemaArchivos?
//    var elementosFinales: [any ElementoSistemaArchivosProtocolo] = []
//    
//    init(coleccionActual: Coleccion, sistemaArchivos: SistemaArchivos) {
//        self.coleccionActual = coleccionActual
//        self.sistemaArchivos = sistemaArchivos
//    }
//    
//    override func main() {
//        guard let sistemaArchivos = sistemaArchivos else { return }
//    
//        
//        if isCancelled { return }
//        
//        // 2. Obtener URLs directorio
//        let allURLs = sistemaArchivos.obtenerURLSDirectorio(coleccionURL: coleccionActual.url)
//        if isCancelled { return }
//        
//        // 3. Filtrar elementos
//        let filteredElements = allURLs.filter { url in
//            SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.filtrosIndexado.allSatisfy {
//                $0.shouldInclude(url: url)
//            }
//        }
//        if isCancelled { return }
//        
//        print("hay un total de", filteredElements.count)
//        
//        // 4. Crear placeholders y asignar (en main queue)
//        DispatchQueue.main.sync {
//            sistemaArchivos.listaElementos = (0..<filteredElements.count).map { _ in
//                ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo
//            }
//        }
//        
//        // --- CAMBIAR COLECCION DEL SA PARA TRIGGEAR LA VISTA ---
////        SistemaArchivos.getSistemaArchivosSingleton.coleccionActual = coleccionActual
//        
//        if isCancelled { return }
//        
//        //5. Crear instancias de elementos
//        var tempElementos: [any ElementoSistemaArchivosProtocolo] = Array(
//            repeating: ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo,
//            count: filteredElements.count
//        )
//        
////        print("Coleccion al terminar el indexado de los placeholders: ", PilaColecciones.getPilaColeccionesSingleton.getColeccionActual().name)
//        
////        let startIndex = coleccionActual.scrollPosition ?? 0
//        
//        print("Indice de comienzo -> ", 0)
//
//        let totalCount = filteredElements.count
////        let indices = Algoritmos().generarIndicesDesdeCentro(startIndex, total: totalCount)
//
//        for index in indices {
//            if isCancelled { return }
//
//            let url = filteredElements[index]
//            
//            if let elemento = sistemaArchivos.crearInstancia(elementoURL: url) {
//                tempElementos[index] = elemento
//                
//                DispatchQueue.main.async {
//                    if index < sistemaArchivos.listaElementos.count {
//                        sistemaArchivos.listaElementos[index] = elemento
//                    }
//                }
//            }
//        }
//        
//        if isCancelled { return }
//        
//        // Guardar resultado para usar luego en el main thread
//        elementosFinales = tempElementos
//    }
//}
