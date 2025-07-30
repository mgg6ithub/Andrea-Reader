
import SwiftUI
import UniformTypeIdentifiers

class ElementoSistemaArchivos: ElementoSistemaArchivosProtocolo, Equatable, ObservableObject {
    
    var id: UUID
    @Published var nombre: String
    var descripcion: String?
    var url: URL
    var relativeURL: String = "something"
    var creationDate: Date
    var modificationDate: Date
    var firstTimeAccessedDate: Date?
    var lastAccessDate: Date?
    
    //Atributos avanzados
    @Published var favorito: Bool
    @Published var protegido: Bool
    
    init() {
        self.id = UUID()
        self.nombre = "Untitled"
        self.descripcion = nil
        self.url = URL(fileURLWithPath: "/default/path")
        self.relativeURL = "something"
        self.creationDate = Date()
        self.modificationDate = Date()
        self.firstTimeAccessedDate = nil
        self.lastAccessDate = nil
        self.favorito = false
        self.protegido = false
    }
    
    init(nombre: String, url: URL, creationDate: Date, modificationDate: Date, favortio: Bool, protegido: Bool) {
        
        self.id = UUID()
        self.nombre = nombre
        self.url = url
        self.relativeURL = ManipulacionCadenas().relativizeURL(elementURL: url)
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.favorito = favortio
        self.protegido = protegido
        
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
    
    public func cambiarEstadoFavorito() {
        withAnimation { self.favorito.toggle() }
        PersistenciaDatos().guardarDatoElemento(url: self.url, atributo: "favorito", valor: self.favorito)
    }
    
    public func cambiarEstadoProtegido() {
        withAnimation { self.protegido.toggle() }
        PersistenciaDatos().guardarDatoElemento(url: self.url, atributo: "protegido", valor: self.protegido)
    }
    
}
