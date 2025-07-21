
import SwiftUI
import UniformTypeIdentifiers

class ElementoSistemaArchivos: ElementoSistemaArchivosProtocolo, Equatable {
    
    var id: UUID
    var name: String
    var description: String?
    var url: URL
    var relativeURL: String = "something"
    var creationDate: Date
    var modificationDate: Date
    var firstTimeAccessedDate: Date?
    var lastAccessDate: Date?
    
    init() {
        self.id = UUID()
        self.name = "Untitled"
        self.description = nil
        self.url = URL(fileURLWithPath: "/default/path")
        self.relativeURL = "something"
        self.creationDate = Date()
        self.modificationDate = Date()
        self.firstTimeAccessedDate = nil
        self.lastAccessDate = nil
    }
    
    init(name: String, url: URL, creationDate: Date, modificationDate: Date) {
        
        self.id = UUID()
        self.name = name
        self.url = url
        self.relativeURL = ManipulacionCadenas().relativizeURL(elementURL: url)
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        
    }
    
    //MARK: - HACER HASHABLE y TRASNFERABLE
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }

    static func == (lhs: ElementoSistemaArchivos, rhs: ElementoSistemaArchivos) -> Bool {
        return lhs.id == rhs.id
    }
    
    
//    func handleTap(elementModel: ElementModel) -> AnyView? {
//        print("Handling tap")
//        return nil
//    }
    
    func getConcreteInstance() -> Self {
        return self
    }
    
}
