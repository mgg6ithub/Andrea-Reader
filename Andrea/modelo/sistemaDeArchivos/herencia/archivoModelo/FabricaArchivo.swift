
import SwiftUI

struct FactoryArchivo {
    
    private let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton
    
    func crearArchivo(fileName: String, fileURL: URL, destionationURL: URL?, currentDirectory: URL) -> (any ProtocoloArchivo)? {
        
        let fileType = sau.getFileType(fileURL: fileURL)
        let fileSize = sau.getFileSize(fileURL: fileURL)
        let creationDate = sau.getElementCreationDate(elementURL: fileURL)
        let modificationDate = sau.getElementModificationDate(elementURL: fileURL)
        
        var archivo: (any ProtocoloArchivo)
        
        switch(fileType) {
            
        case .txt:
            archivo = TXTArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType.rawValue, fileExtension: fileURL.pathExtension, fileSize: fileSize)
        
        default:
            return nil
        }
        
        return archivo
    }
    
}
