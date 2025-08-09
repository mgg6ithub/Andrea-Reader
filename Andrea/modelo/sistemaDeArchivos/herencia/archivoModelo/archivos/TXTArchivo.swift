

import SwiftUI

class TXTArchivo: Archivo {
    
    override init(fileName: String, fileURL: URL, fechaImportacion: Date, fechaModificacion: Date, fileType: EnumTipoArchivos, fileExtension: String, fileSize: Int, favorito: Bool, protegido: Bool) {
        
        //SE HACEN COSAS
        
        super.init(fileName: fileName, fileURL: fileURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, fileType: fileType, fileExtension: fileExtension, fileSize: fileSize, favorito: favorito, protegido: protegido)
    }
    
}
