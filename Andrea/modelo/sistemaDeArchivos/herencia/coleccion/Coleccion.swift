
import SwiftUI

class ColeccionValor {
    
    var coleccion: Coleccion
    var subColecciones: Set<URL> =  []
    var listaElementos: [(any ElementoSistemaArchivosProtocolo)] = []
    
    init(coleccion: Coleccion) {
        self.coleccion = coleccion
    }
    
}

class Coleccion: ElementoSistemaArchivos {
    //ATRIBUTOS
    var isDirectory = true
    var elementList: [String]
    var lastImportedElement: URL?
    var lastImportedElementDate: Date?
    
    @State private var showIconAlert = false
    
    init(directoryName: String, directoryURL: URL, creationDate: Date, modificationDate: Date, elementList: [String]) {
        
        self.elementList = elementList
        super.init(name: directoryName, url: directoryURL, creationDate: creationDate, modificationDate: modificationDate)
        
    }
    
    public func meterColeccion() {
        DispatchQueue.main.async {
            PilaColecciones.pilaColecciones.meterColeccion(coleccion: self)
        }
    }
    
    public func guardarPosicionScroll(scrollPosition: Int) {
        
    }
    
    public func obtenerPosicionScroll() -> Int {
        return 0
    }
    
}
