

import SwiftUI

struct FabricaColeccion {
    
    let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    func crearColeccion(coleccionNombre: String, coleccionURL: URL) -> Coleccion {
        
        let pd = PersistenciaDatos()
        let cpe = ClavesPersistenciaElementos()
        let p = ValoresElementoPredeterminados()
        let url = coleccionURL
        
        //FECHA IMPROTACION/CREACION
        var fechaImportacion: Date
        if let guardada = pd.recuperarDatoElemento(elementoURL: url, key: cpe.fechaImportacion, default: p.fechaImportacion) {
            fechaImportacion = guardada
        } else {
            fechaImportacion = Date()
            pd.guardarDatoArchivo(valor: fechaImportacion, elementoURL: url, key: cpe.fechaImportacion)
            print("FECHA IMPORTACION: ", fechaImportacion)
        }
        let fechaModificacion = sau.getElementModificationDate(elementURL: url)
        
        //COLOR DE LA COLECCION
        var color: Color = pd.recuperarDatoArchivoColor(elementoURL: url, key: cpe.colorGuardado, default: p.colorGuardado)
        
        let archivosYcolecciones = SistemaArchivosUtilidades.sau.contarArchivosYSubdirectorios(url: url)
        let totalArchivos = archivosYcolecciones.0
        let totalColecciones = archivosYcolecciones.1
        
        let favorito = pd.recuperarDatoElemento(elementoURL: url, key: cpe.favoritos, default: p.favoritos)
        let protegido = pd.recuperarDatoElemento(elementoURL: url, key: cpe.protegidos, default: p.protegidos)
        
        let coleccion = Coleccion(directoryName: coleccionNombre, directoryURL: url, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, color: color, totalArchivos: totalArchivos, totalColecciones: totalColecciones, favorito: favorito, protegido: protegido)
        
        return coleccion
    
    }
}
