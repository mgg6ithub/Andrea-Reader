
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
    var lastImportedElement: URL?
    var lastImportedElementDate: Date?
    
    @Published var color: Color
    var totalArchivos: Int
    var totalColecciones: Int
    
    @State private var showIconAlert = false
    
    init(directoryName: String, directoryURL: URL, creationDate: Date, modificationDate: Date) {
        
        self.color = .blue
        self.totalArchivos = 0
        self.totalColecciones = 0
        
        super.init(nombre: directoryName, url: directoryURL, creationDate: creationDate, modificationDate: modificationDate)
        
    }
    
    init(directoryName: String, directoryURL: URL, creationDate: Date, modificationDate: Date, color: Color, totalArchivos: Int, totalColecciones: Int) {
        
        self.color = color
        self.totalArchivos = totalArchivos
        self.totalColecciones = totalColecciones
        
        super.init(nombre: directoryName, url: directoryURL, creationDate: creationDate, modificationDate: modificationDate)
        
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
