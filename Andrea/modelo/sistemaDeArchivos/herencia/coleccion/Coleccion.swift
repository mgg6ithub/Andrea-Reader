
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
    
    let pd = PersistenciaDatos()
    let cpe = ClavesPersistenciaElementos()
    let p = ValoresElementoPredeterminados()
    
    @Published var miniaturasBandeja: [UIImage] = []
    @Published var tipoMiniatura: EnumTipoMiniaturaColeccion = .carpeta
    @Published var direccionAbanico: EnumDireccionAbanico = .derecha
    
    @Published var icono: URL? = nil
    
    //ATRIBUTOS
    var isDirectory = true
    var lastImportedElement: URL?
    var lastImportedElementDate: Date?
    
    @Published var color: Color
    var totalArchivos: Int
    var totalColecciones: Int
    
    @State private var showIconAlert = false
    
    override var fechaPrimeraVezEntrado: Date? { didSet { pd.guardarDatoArchivo(valor: fechaPrimeraVezEntrado as Any, elementoURL: url, key: cpe.fechaPrimeraVezEntrado) } }
    
    override var fechaUltimaVezEntrado: Date? { didSet { pd.guardarDatoArchivo(valor: fechaPrimeraVezEntrado as Any, elementoURL: url, key: cpe.fechaUltimaVezEntrado) } }
    
    
    //--- CONSTRUCTOR DUMMY ---
    init(directoryName: String, directoryURL: URL, fechaImportacion: Date, fechaModificacion: Date, favorito: Bool, protegido: Bool) {
        
        self.color = .gray
        self.totalArchivos = 0
        self.totalColecciones = 0
        
        super.init(nombre: directoryName, url: directoryURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, favortio: favorito, protegido: protegido)
        
    }
    
    //--- CONSTRUCTOR DE VERDAD ---
    init(directoryName: String, directoryURL: URL, fechaImportacion: Date, fechaModificacion: Date, color: Color, totalArchivos: Int, totalColecciones: Int, favorito: Bool, protegido: Bool) {
        
        self.color = color
        self.totalArchivos = totalArchivos
        self.totalColecciones = totalColecciones
        
        //ICONO DE LA COLECCION
        let iconoString = pd.recuperarDatoElemento(elementoURL: directoryURL, key: cpe.icono, default: p.icono)
        
        if iconoString != "" {
            let iconoURL = SistemaArchivosUtilidades.sau.home.appendingPathComponent(".imagenes").appendingPathComponent(iconoString)
            self.icono = iconoURL
        }
        
        //TIPO DE MINIATURA DE LA COLECCION
        self.tipoMiniatura = pd.recuperarDatoArchivoEnum(elementoURL: directoryURL, key: cpe.miniaturaColeccion, default: p.miniaturaColeccion)
        
        super.init(nombre: directoryName, url: directoryURL, fechaImportacion: fechaImportacion, fechaModificacion: fechaModificacion, favortio: favorito, protegido: protegido)
        
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
    
    public func precargarMiniaturas(completion: (() -> Void)? = nil) {
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
            completion?() // 🔹 avisamos que terminó
        }
    }

}
