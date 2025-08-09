
import SwiftUI

struct FactoryArchivo {
    
    private let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    func crearArchivo(fileName: String, fileURL: URL, destionationURL: URL?, currentDirectory: URL) -> Archivo {
        
        let fileType = sau.getFileType(fileURL: fileURL)
        let fileSize = sau.getFileSize(fileURL: fileURL)
        let fechaImportacion = sau.getElementCreationDate(elementURL: fileURL)
        let fechaModificacion = sau.getElementModificationDate(elementURL: fileURL)
        
        var archivo: Archivo
        
        let favorito = PersistenciaDatos().obtenerAtributoConcreto(url: fileURL, atributo: "favorito") as? Bool ?? false
        let protegido = PersistenciaDatos().obtenerAtributoConcreto(url: fileURL, atributo: "protegido") as? Bool ?? false
        
        switch(fileType) {
            
        case .txt:
            archivo = TXTArchivo(
                fileName: fileName,
                fileURL: fileURL,
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
                fileURL: fileURL,
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
                fileURL: fileURL,
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
