import SwiftUI

protocol ElementoSistemaArchivosProtocolo: Transferable, Hashable, Identifiable {
    
    var id: UUID { get }
    var name: String { get set }
    var description: String? { get set }
    var url: URL { get set }
    var relativeURL: String { get }
    var creationDate: Date { get }
    var modificationDate: Date { get set}
    var firstTimeAccessedDate: Date? { get set }
    var lastAccessDate: Date? { get set }
    
    //DEFAULT ELEMENT ACTIONS
    func getConcreteInstance() -> Self
    
}
