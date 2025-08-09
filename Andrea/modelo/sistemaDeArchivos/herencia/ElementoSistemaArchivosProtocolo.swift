import SwiftUI

protocol ElementoSistemaArchivosProtocolo: Transferable, Hashable, Identifiable {
    
    var id: UUID { get }
    
    var nombre: String { get set }
    var descripcion: String? { get set }
    
    var url: URL { get set }
    var relativeURL: String { get }
    
    var fechaImportacion: Date { get }
    var fechaModificacion: Date { get set}
    var fechaPrimeraVez: Date? { get set }
    var fechaUltimaVez: Date? { get set }
    var vecesEntrado: Int { get set }
    
    //Atributos de estado avanzados
    var favorito: Bool { get set }
    var protegido: Bool { get set }
    
    //DEFAULT ELEMENT ACTIONS
    func getConcreteInstance() -> Self
    
    func cambiarEstadoFavorito() -> Void
    func cambiarEstadoProtegido() -> Void
    
}
