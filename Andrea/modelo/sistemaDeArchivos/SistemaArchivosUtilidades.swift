

import SwiftUI
import UniformTypeIdentifiers

class SistemaArchivosUtilidades {
    
    // MARK: – Instancia singleton (perezosa + protegida con queue de sincronización)
    private static var sistemaArchivosUtilidades: SistemaArchivosUtilidades? = nil
    private static let sistemaArchivosUtilidadesQueue = DispatchQueue(label: "com.miApp.singletonSistemaArchivos")
    
    public static var getSistemaArchivosUtilidadesSingleton: SistemaArchivosUtilidades {
        return sistemaArchivosUtilidadesQueue.sync {
            if sistemaArchivosUtilidades == nil {
                sistemaArchivosUtilidades = SistemaArchivosUtilidades()
            }
            return sistemaArchivosUtilidades!
        }
    }
    
    //Variables locales del SISTEMA DE ARCHIVOS
    public var filtrosIndexado: Set<EnumFiltroArchivos> = [.excludeTrash, .excludeHiddenFiles]
    
    public var fm: FileManager // Intancia global de FileManager para interactuar con el sistema de archivos
    
    public var rootDirectory: URL // Variable con la ruta del directorio root
    
    private init() {
        
        //Inicializamos
        
        // Intentar obtener el directorio de documentos
        guard let rootURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        
        //Por defecto inicializamos con el directorio root
        self.rootDirectory = rootURL
        
        self.fm = FileManager.default
    }
    
    /**
     *METODO BASICOS PARA MANEJAR UN SISTEMA DE ARCHIVOS*
     */
    
    /**
    Devuelve la URL del directorio root
     */
    public func getRootDirectoryPath() -> URL {
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL
    }
    
    
    /**
     Metodo que comprueba si un archivo o directorio existe devolviendo un booleano. True -> existe False -> no existe.
     */
    
    public func fileExists(elementURL: URL) -> Bool {
        return fm.fileExists(atPath: elementURL.path)
    }
    
    
    /**
     Metodo que comprueba si la URL pasado como parametro es o no un directorio devolviendo un booleano. True -> Directorio False -> No directorio.
     */
    
    public func isDirectory(elementURL: URL) -> Bool {
        
        var isDirectory: ObjCBool = false
        
        if fm.fileExists(atPath: elementURL.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }
        
        return false
    }
    
    
    /**
     *RENOMBRAR TODOS A ELEMENT EN VEZ DE FILE*
     */
    
    public func getFileName(fileURL: URL) -> String {
        return fileURL.deletingPathExtension().lastPathComponent
    }
    
    
    public func getFileType(fileURL: URL) -> EnumTipoArchivos {
        return EnumTipoArchivos(rawValue: fileURL.pathExtension) ?? .unknown
    }
    

    public func getFileSize(fileURL: URL) -> Int {
        
        let fileSize = (try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int) ?? 0
        
        return fileSize
    }
    
    /**
     Metodo para obtener el mimeType del archvio
     */
    
    func getMimeType(for url: URL) -> String {
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.preferredMIMEType ?? "application/octet-stream"
        }
        return "application/octet-stream" // Default en caso de no encontrarlo
    }
    
    /**
     Metodo para obtener los permisos del archivo, LECTURA, ESCRITURA EJECUCION
     */
    
    func getFilePermissions(for url: URL) -> (readable: Bool, writable: Bool, executable: Bool) {
        let fileManager = FileManager.default
        let readable = fileManager.isReadableFile(atPath: url.path)
        let writable = fileManager.isWritableFile(atPath: url.path)
        let executable = fileManager.isExecutableFile(atPath: url.path)

        return (readable, writable, executable)
    }
    
    func readTextFile() {
        let fileManager = FileManager.default
        
        // Obtén la URL del archivo (en este caso, desde el directorio de documentos)
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("No se pudo obtener el directorio de documentos.")
            return
        }
        
        let fileURL = documentDirectory.appendingPathComponent(".userSettings.json")
        
        // Lee el contenido del archivo como texto
        do {
            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            print("Contenido del archivo: \(fileContents)")
        } catch {
            print("Error al leer el archivo: \(error)")
        }
    }
    
    
    public func getElementCreationDate(elementURL: URL) -> Date {
        do {
            if let creationDate = try fm.attributesOfItem(atPath: elementURL.path)[.creationDate] as? Date {
                return creationDate
            } else {
                print("No se encontró la fecha de creación, se usará la fecha actual como predeterminada.")
                return Date() // Retorna la fecha actual si no existe `.creationDate`
            }
        } catch {
            print("Error al obtener la fecha de creación: \(error.localizedDescription). Se usará la fecha actual como predeterminada.")
            return Date() // Retorna la fecha actual si ocurre un error
        }
    }
    
    
    public func getElementModificationDate(elementURL: URL) -> Date {
        do {
           if let modDate = try fm.attributesOfItem(atPath: elementURL.path)[.modificationDate] as? Date {
               return modDate
           } else {
               print("No se encontró la fecha de modificacion para el elemento en \(elementURL.path).")
               return Date()
           }
       } catch {
           print("Error al obtener la fecha de modificacion: \(error.localizedDescription)")
           return Date()
       }
    }
    
    /**
     *OBTENER EL TIPO DEL DIRECTORIO SEGUN LOS ARCHIVOS OCULTOS QUE TENGA*
     */
    
//    public func getDirectoryType(directoryURL: URL) -> EnumDirectoryTypes {
//        
//        let contents = self.getUrlsSubdirectoryContents(urlPath: directoryURL)
//        
//        let hiddenFile = contents.filter { $0.lastPathComponent.hasPrefix(".") }
//        
//        if let hiddenFileName = hiddenFile.first?.lastPathComponent.dropFirst() {
//            if let directoryType = EnumDirectoryTypes(rawValue: String(hiddenFileName)) {
//                return directoryType
//            }
//        }
//        
//        return .normal
//    }
    
    
    /**
     *DEVUELVE UNA LISTA DE STRINGS CON EL NOMBRE DE LOS ELEMENTOS DEL DIRECTORIO ROOT*
     */
    private func getListRootDirectoryContents() -> [String] {
        do {
            return try fm.contentsOfDirectory(atPath: getRootDirectoryPath().path)
        } catch {
            print("Error a la hora de obtener la lista de los contenidos del directorio raiz: \(error)")
        }
        return []
    }
    
    /**
     *DEVUELVE UNA LISTA DE URLS CON LAS URLS DE LOS ELEMENTOS DEL DIRECTORIO ROOT*
     */
    
    public func getUrlsRootDirectoryContents() -> [URL] {
        do {
            
            return try fm.contentsOfDirectory(at: getRootDirectoryPath(), includingPropertiesForKeys: nil)
        } catch {
            print("Error a la hora de obtener las urls del directorio raiz: \(error)")
        }
        return []
    }
    
    /**
     *DEVUELVE UNA LISTA DE STRINGS CON EL NOMBRE DE LOS ELEMENTOS DEL DIRECTORIO PASADO COMO PARAMETRO*
     */
    
    private func getListSubdirectoryContents(urlPath: URL) -> [String] {
        
        do {
            return try fm.contentsOfDirectory(atPath: urlPath.path)
        } catch {
            print("Error al listar el subdirectorio \(urlPath.lastPathComponent) error: \(error)")
        }
        return []
    }
    
    /**
     *METODO PARA OBTENER TODOS LOS NOMBRES DE LOS ELEMENTOS DE UN DIRECTORIO PERO SIN EXTENSION*
     */
    
    public func getListSubdirectoryContentsWithNoExtensions(urlPath: URL) -> [String] {
        
        var newList: [String] = []
        
        do {
            let contents = try fm.contentsOfDirectory(atPath: urlPath.path)
            
            for i in contents {
                
                newList.append(ManipulacionCadenas().removeExtensionFromString(name: i))
                
            }
            
            return newList
            
        } catch {
            print("Error al listar el subdirectorio \(urlPath.lastPathComponent) error: \(error)")
        }
        return []
    }
    
    private func getListSubdirectoryContentsWithNoExtensionsFilters(urlPath: URL, elementsToAvoid: [String]) -> [String] {
        
        var newList: [String] = []
        
        do {
            let contents = try fm.contentsOfDirectory(atPath: urlPath.path)
            
            for i in contents {
                
                if elementsToAvoid.contains(i){
                    continue
                }
                
                newList.append(ManipulacionCadenas().removeExtensionFromString(name: i))
                
            }
            
            return newList
            
        } catch {
            print("Error al listar el subdirectorio \(urlPath.lastPathComponent) error: \(error)")
        }
        return []
    }
    
    
    /**
     *DEVUELVE UNA LISTA DE URLS CON LAS URLS DE LOS ELEMENTOS DEL DIRECTORIO PASADO COMO PARAMETRO*
     */
    
    public func getUrlsSubdirectoryContents(urlPath: URL) -> [URL] {
        do {
            
            var temp: [URL] = []
            let contentsURLS = try fm.contentsOfDirectory(at: urlPath, includingPropertiesForKeys: nil)
            
            for url in contentsURLS {
//                guard indexingFilters.allSatisfy({ $0.shouldInclude(url: url) }) else {
//                    continue
//                }
                temp.append(url)
            }
            
            return temp
        } catch {
            print("Error a la hora de obtener las urls del subdirectorio \(urlPath.lastPathComponent) error: \(error)")
        }
        return []
    }
    
    
    /**
     Metodo para obtener los aatributos de un archivo
     */
    public func getAllAttributes(elementURL: URL) {
        print("ATRIBUTOS DEL ELEMENTO")
        print(elementURL.lastPathComponent)
        print()
        
        do {
            if let attributes = try FileManager.default.attributesOfItem(atPath: elementURL.path) as? [FileAttributeKey: Any] {
                for (key, value) in attributes {
                    print("\(key): \(value)")
                }
            }
        } catch {
            print("Error obteniendo atributos: \(error)")
        }
    }
    
}
