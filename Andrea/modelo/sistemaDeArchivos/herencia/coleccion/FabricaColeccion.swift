

import SwiftUI

struct FabricaColeccion {
    
    let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton
    
    func crearColeccion(collectionName: String, collectionURL: URL) -> Coleccion? {
        
//        let directoryType = sau.getDirectoryType(directoryURL: collectionURL)
        let creationDate = sau.getElementCreationDate(elementURL: collectionURL)
        let modificationDate = sau.getElementModificationDate(elementURL: collectionURL)
        
        let coleccion = Coleccion(directoryName: collectionName, directoryURL: collectionURL, creationDate: creationDate, modificationDate: modificationDate, elementList: [])
        
//        coleccion.scrollPosition = PersistenciaDatos().obtenerPosicionScroll(coleccion: coleccion)
        if let hexColor = PersistenciaDatos().obtenerAtributo(coleccion: coleccion, atributo: "color") as? String {
            coleccion.color = Color(hex: hexColor)
        } else {
            coleccion.color = .blue // valor por defecto
        }
        
        return coleccion
        
//        var elementList: [String] = []
        
//        for content in fs.fsu.getUrlsSubdirectoryContents(urlPath: directoryURL) {
//            
//            let contentRemovePrivate = StringManipulation().normalizeURL(content)
//            let rootRemovePrivate = StringManipulation().normalizeURL(fs.fsu.getRootDirectoryPath().deletingLastPathComponent())
//            
//            let relativePath = contentRemovePrivate.path.replacingOccurrences(of: rootRemovePrivate.path, with: "")
//            
//            elementList.append(relativePath)
//        }
    }
}
