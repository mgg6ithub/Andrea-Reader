
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
            archivo = TXTArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileURL.pathExtension, fileSize: fileSize)

//        case .cbr:
//            archivo = CBRArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType.rawValue, fileExtension: fileURL.pathExtension, fileSize: fileSize)
            
        case .cbz:
            archivo = CBZArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileURL.pathExtension, fileSize: fileSize)
            
//        case .epub:
//            archivo = EPUBArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType.rawValue, fileExtension: fileURL.pathExtension, fileSize: fileSize)
        
        default:
            return nil
        }
        
        // --- PAGINAS Y PORCENTAJE ---
        archivo.fileTotalPages = Int.random(in: 20...50)
        archivo.setCurrentPage(currentPage: Int.random(in: 1...50))
        
        return archivo
    }
    
}
