

import SwiftUI

struct FabricaColeccion {
    
    let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    func crearColeccion(coleccionNombre: String, coleccionURL: URL) -> Coleccion {
        
        let fechaImportacion = sau.getElementCreationDate(elementURL: coleccionURL)
        let fechaModificacion = sau.getElementModificationDate(elementURL: coleccionURL)
        
        var color: Color
        
        if let colorString = PersistenciaDatos().obtenerAtributoConcreto(url: coleccionURL, atributo: "color") as? String {
           color = Color(hex: colorString)
        } else {
            color = .gray
        }
        
        let archivosYcolecciones = SistemaArchivosUtilidades.sau.contarArchivosYSubdirectorios(url: coleccionURL)
        let totalArchivos = archivosYcolecciones.0
        let totalColecciones = archivosYcolecciones.1
        
        let favorito = PersistenciaDatos().obtenerAtributoConcreto(url: coleccionURL, atributo: "favorito") as? Bool ?? false
        let protegido = PersistenciaDatos().obtenerAtributoConcreto(url: coleccionURL, atributo: "protegido") as? Bool ?? false
        
        let coleccion = Coleccion(directoryName: coleccionNombre, directoryURL: coleccionURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, color: color, totalArchivos: totalArchivos, totalColecciones: totalColecciones, favorito: favorito, protegido: protegido)
        
        return coleccion
    
    }
}
