

import SwiftUI

class TXTArchivo: Archivo {
    
    override init(fileName: String, fileURL: URL, creationDate: Date, modificationDate: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
        
        //SE HACEN COSAS
        
        super.init(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileExtension, fileSize: fileSize, favorito: favorito, protegido: protegido)
    }
    
}
