
import SwiftUI

struct FactoryArchivo {
    
    private let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    func crearArchivo(fileName: String, fileURL: URL, destionationURL: URL?, currentDirectory: URL) -> Archivo {
        
        let fileType = sau.getFileType(fileURL: fileURL)
        let fileSize = sau.getFileSize(fileURL: fileURL)
        let creationDate = sau.getElementCreationDate(elementURL: fileURL)
        let modificationDate = sau.getElementModificationDate(elementURL: fileURL)
        
        var archivo: Archivo
        
        switch(fileType) {
            
        case .txt:
            archivo = TXTArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileURL.pathExtension, fileSize: fileSize)

        case .cbr:
            archivo = CBRArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileURL.pathExtension, fileSize: fileSize)
            
        case .cbz:
            archivo = CBZArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileURL.pathExtension, fileSize: fileSize)
            
//        case .epub:
//            archivo = EPUBArchivo(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType.rawValue, fileExtension: fileURL.pathExtension, fileSize: fileSize)
        
        default:
            return Archivo()
        }
        
        // --- PAGINAS Y PORCENTAJE ---
        archivo.setCurrentPage(currentPage: 10)
        
        return archivo
    }
    
}
