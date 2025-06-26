

import SwiftUI

class TXTArchivo: Archivo {
    
    override init(fileName: String, fileURL: URL, creationDate: Date, modificationDate: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int) {
        
        //SE HACEN COSAS
        
        super.init(fileName: fileName, fileURL: fileURL, creationDate: creationDate, modificationDate: modificationDate, fileType: fileType, fileExtension: fileExtension, fileSize: fileSize)
    }
    
}
