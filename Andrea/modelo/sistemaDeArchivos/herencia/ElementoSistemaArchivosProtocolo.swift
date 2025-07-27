import SwiftUI

protocol ElementoSistemaArchivosProtocolo: Transferable, Hashable, Identifiable {
    
    var id: UUID { get }
    var nombre: String { get set }
    var descripcion: String? { get set }
    var url: URL { get set }
    var relativeURL: String { get }
    var creationDate: Date { get }
    var modificationDate: Date { get set}
    var firstTimeAccessedDate: Date? { get set }
    var lastAccessDate: Date? { get set }
    
    //DEFAULT ELEMENT ACTIONS
    func getConcreteInstance() -> Self
    
}
