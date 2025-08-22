
import SwiftUI

protocol ProtocoloArchivo: ElementoSistemaArchivosProtocolo {
    
    //POSIBLE INFORMACION EXTRAIDA DEL ARCHIVO QUE SE IMPORTE
    var perteneceAcoleccion: String? { get set }
    var numeroDeLaColeccion: Int? { get }
    var nombreOriginal: String? { get set }
    
    var fileType: EnumTipoArchivos { get }
    var fileSize: Int { get }
    
    var idioma: EnumIdiomas { get set }
    var genero: String { get set }
    
    func viewContent() -> AnyView
    
//    func getTotalPages() -> Int
//    func setCurrentPage(currentPage: Int) -> Void
    
    func extractPageData(named: String) -> Data?
    
}
