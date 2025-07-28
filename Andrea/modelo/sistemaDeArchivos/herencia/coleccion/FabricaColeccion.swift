

import SwiftUI

struct FabricaColeccion {
    
    let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    func crearColeccion(coleccionNombre: String, coleccionURL: URL) -> Coleccion {
        
        let creationDate = sau.getElementCreationDate(elementURL: coleccionURL)
        let modificationDate = sau.getElementModificationDate(elementURL: coleccionURL)
        
        var color: Color
        
        if let colorString = PersistenciaDatos().obtenerAtributoConcreto(url: coleccionURL, atributo: "color") as? String {
           color = Color(hex: colorString)
        } else {
            color = .blue
        }
        
        let archivosYcolecciones = SistemaArchivosUtilidades.sau.contarArchivosYSubdirectorios(url: coleccionURL)
        let totalArchivos = archivosYcolecciones.0
        let totalColecciones = archivosYcolecciones.1
        
        let coleccion = Coleccion(directoryName: coleccionNombre, directoryURL: coleccionURL, creationDate: creationDate, modificationDate: modificationDate, color: color, totalArchivos: totalArchivos, totalColecciones: totalColecciones)
        
        return coleccion
    
    }
}
