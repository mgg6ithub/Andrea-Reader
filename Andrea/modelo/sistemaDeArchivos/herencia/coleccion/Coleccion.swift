
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
    
    //ATRIBUTOS PERSISTENTES

    
    //MODELO
//    var directoryImageModel: DirectoryImageModel = DirectoryImageModel()
    
//    @Published var readSettingsModel: ReadSettingsModel?
    
//    @ObservedObject private var fs = FileSystem.getFileSystemInstance
//    private let fsu: FileSystemUtils = FileSystemUtils.getFileSystemUtilsInstance()
    
    @State private var showIconAlert = false
    
    init(directoryName: String, directoryURL: URL, creationDate: Date, modificationDate: Date, elementList: [String]) {
        
        self.elementList = elementList
//        self.color = ConstantesPorDefecto().lista.randomElement() ?? .blue
        super.init(name: directoryName, url: directoryURL, creationDate: creationDate, modificationDate: modificationDate)
        
//        if let colorString = DataPersistence.getDataPersistence().getDirectoryColor(for: directoryURL), let color = Color(fromString: colorString) {
//            self.directoryColor = color
//        }
        
//        if let settingModelName = DataPersistence.getDataPersistence().getDirectoryModelName(for: directoryURL) {
//            self.readSettingsModel = ReadSettingsManager.getReadSettingsManager.getReadSettingModelByName(settingName: settingModelName)
//        }
        
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
