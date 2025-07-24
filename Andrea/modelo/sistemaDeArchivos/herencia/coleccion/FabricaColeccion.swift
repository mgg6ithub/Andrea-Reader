

import SwiftUI

struct FabricaColeccion {
    
    let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    func crearColeccion(collectionName: String, collectionURL: URL) -> Coleccion {
        
        let creationDate = sau.getElementCreationDate(elementURL: collectionURL)
        let modificationDate = sau.getElementModificationDate(elementURL: collectionURL)
        let coleccion = Coleccion(directoryName: collectionName, directoryURL: collectionURL, creationDate: creationDate, modificationDate: modificationDate, elementList: [])
        
        return coleccion
    
    }
}
