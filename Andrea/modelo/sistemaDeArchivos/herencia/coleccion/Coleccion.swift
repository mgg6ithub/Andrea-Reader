
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
    
    @Published var miniaturasBandeja: [UIImage] = []
    @Published var tipoMiniatura: EnumTipoMiniaturaColeccion = .carpeta
    @Published var direccionAbanico: EnumDireccionAbanico = .izquierda
    
    //ATRIBUTOS
    var isDirectory = true
    var lastImportedElement: URL?
    var lastImportedElementDate: Date?
    
    @Published var color: Color
    var totalArchivos: Int
    var totalColecciones: Int
    
    @State private var showIconAlert = false
    
    //--- CONSTRUCTOR DUMMY ---
    init(directoryName: String, directoryURL: URL, creationDate: Date, modificationDate: Date, favorito: Bool, protegido: Bool) {
        
        self.color = .blue
        self.totalArchivos = 0
        self.totalColecciones = 0
        
        super.init(nombre: directoryName, url: directoryURL, creationDate: creationDate, modificationDate: modificationDate, favortio: favorito, protegido: protegido)
        
    }
    
    //--- CONSTRUCTOR ---
    init(directoryName: String, directoryURL: URL, creationDate: Date, modificationDate: Date, color: Color, totalArchivos: Int, totalColecciones: Int, favorito: Bool, protegido: Bool) {
        
        self.color = color
        self.totalArchivos = totalArchivos
        self.totalColecciones = totalColecciones
        
        super.init(nombre: directoryName, url: directoryURL, creationDate: creationDate, modificationDate: modificationDate, favortio: favorito, protegido: protegido)
        
        if let tipoRaw = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "tipoMiniatura") as? String,
           let tipo = EnumTipoMiniaturaColeccion(rawValue: tipoRaw) {
            self.tipoMiniatura = tipo
        }
        
        if let dirRaw = PersistenciaDatos().obtenerAtributoConcreto(url: self.url, atributo: "direccionAbanico") as? String,
           let dir = EnumDireccionAbanico(rawValue: dirRaw) {
            self.direccionAbanico = dir
        }
        
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
    
    public func precargarMiniaturas() {
        
        let allURLs = SistemaArchivos.sa.obtenerURLSDirectorio(coleccionURL: self.url)
        let filteredURLs = allURLs.filter { url in
            SistemaArchivosUtilidades.sau.filtrosIndexado.allSatisfy {
                $0.shouldInclude(url : url)
            }
        }
        
        let primeros4 = Array(filteredURLs.prefix(4))

            var nuevasMiniaturas: [UIImage?] = Array(repeating: nil, count: primeros4.count)
            let group = DispatchGroup()

            for (index, url) in primeros4.enumerated() {
                if let archivo = SistemaArchivos.sa.crearInstancia(elementoURL: url) as? Archivo {
                    group.enter()
                    ModeloMiniatura.modeloMiniatura.construirMiniatura(color: self.color, archivo: archivo) { img in
                        nuevasMiniaturas[index] = img
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                self.miniaturasBandeja = nuevasMiniaturas.compactMap { $0 }
            }
    }
    
}
