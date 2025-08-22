
import SwiftUI

struct FactoryArchivo {
    
    private let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    func crearArchivo(fileName: String, fileURL: URL, destionationURL: URL?, currentDirectory: URL) -> Archivo {
        
        let pd = PersistenciaDatos()
        let cpe = ClavesPersistenciaElementos()
        let p = ValoresElementoPredeterminados()
        let url = fileURL
        
        let fileType = sau.getFileType(fileURL: url)
        let fileSize = sau.getFileSize(fileURL: url)
        
        var fechaImportacion: Date
        if let guardada = pd.recuperarDatoElemento(elementoURL: url, key: cpe.fechaImportacion, default: p.fechaImportacion) {
            fechaImportacion = guardada
        } else {
            fechaImportacion = Date()
            pd.guardarDatoArchivo(valor: fechaImportacion, elementoURL: url, key: cpe.fechaImportacion)
            print("FECHA IMPORTACION: ", fechaImportacion)
        }
        
        let fechaModificacion = sau.getElementModificationDate(elementURL: url)
        
        var archivo: Archivo
        
        let favorito = pd.recuperarDatoElemento(elementoURL: url, key: cpe.favoritos, default: p.favoritos)
        let protegido = pd.recuperarDatoElemento(elementoURL: url, key: cpe.protegidos, default: p.protegidos)
        
        switch(fileType) {
            
        case .txt:
            archivo = TXTArchivo(
                fileName: fileName,
                fileURL: url,
                fechaImportacion: fechaImportacion,
                fechaModificacion: fechaModificacion,
                fileType: fileType,
                fileExtension: fileURL.pathExtension,
                fileSize: fileSize,
                favorito: favorito,
                protegido: protegido
            )

        case .cbr:
            archivo = CBRArchivo(
                fileName: fileName,
                fileURL: url,
                fechaImportacion: fechaImportacion,
                fechaModificacion: fechaModificacion,
                fileType: fileType,
                fileExtension: fileURL.pathExtension,
                fileSize: fileSize,
                favorito: favorito,
                protegido: protegido
            )

        case .cbz:
            archivo = CBZArchivo(
                fileName: fileName,
                fileURL: url,
                fechaImportacion: fechaImportacion,
                fechaModificacion: fechaModificacion,
                fileType: fileType,
                fileExtension: fileURL.pathExtension,
                fileSize: fileSize,
                favorito: favorito,
                protegido: protegido
            )
            
//        case .epub:
//            archivo = EPUBArchivo(fileName: fileName, fileURL: fileURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, fileType: fileType.rawValue, fileExtension: fileURL.pathExtension, fileSize: fileSize)
        
        default:
            return Archivo()
        }
        
        // --- PAGINAS Y PORCENTAJE ---


        return archivo
    }
    
}
