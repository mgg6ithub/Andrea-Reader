

import SwiftUI


class SistemaArchivos: ObservableObject {
    
    // MARK: – Instancia singleton (perezosa + protegida con queue de sincronización)
    private static var sistemaArchivos: SistemaArchivos? = nil
    private static let sistemaArchivosQueue = DispatchQueue(label: "com.miApp.singletonSistemaArchivos")
    
    /// Getter público que comprueba si la instancia es nula; si lo es, la crea una sola vez.
    public static var getSistemaArchivosSingleton: SistemaArchivos {
        return sistemaArchivosQueue.sync {
            if sistemaArchivos == nil {
                sistemaArchivos = SistemaArchivos()
            }
            return sistemaArchivos!
        }
    }
    
    //MARK: - LISTAS Y CACHES
    // MARK: – Cola para proteger acceso a propiedades internas (lectura/escritura concurrente)
    private let fileQueue = DispatchQueue(label: "com.miApp.sistemaArchivos.queue", attributes: .concurrent)
    
    /**
     *Diccinario de directorios cache para almacenar objetos previamente creados por cada directorio. Para una navegacion rapida entre el sistema de archivos.*
     */
    private var cacheColecciones: [URL: [URL : any ElementoSistemaArchivosProtocolo]] = [:] //Solo accesible desde el (sa)
    
    /**
     La idea es mantener privado el cache y la lista publica. Porque la lista se puede ordenar con facilidad y iterar.
     PATRON DE FUNCIONAMIENTO: Indexar directorio actual -> Comprobar Cache -> Agregar al cache los elementos que no esten -> Pasar del cache a la lista -> Ordenar lista
     */
    
    @Published var listaElementos: [any ElementoSistemaArchivosProtocolo] = [] //Es es la lista publica que se vinculara a la vista de la libreria.
    
    private var coleccionPrincipalURL: URL
    
    private init() {
        
        //Inicializamos los ayudantes del sistema de archivos
        self.coleccionPrincipalURL = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.rootDirectory
        
        //Comenzar indexacion del directorio actual
        self.refreshIndex()
//        self.crearArchivosPrueba()
        self.obtenerURLSDirectorio(coleccionURL: self.coleccionPrincipalURL)
        
    }
    
    
    public func refreshIndex(completion: (() -> Void)? = nil) {
        
        //1. Borramos lo que hubiera anteriormente
        DispatchQueue.main.async {
            self.listaElementos.removeAll()
        }
        
        //Creamos un hilo en el background para el indexado
        DispatchQueue.global().async {
            
            //Iniciamos el indexado
            //2. Primero escaneamos el directorio para saber el total de elementos que habra. Para cargar en la vista los placeholders.
            let totalElements = self.obtenerURLSDirectorio(coleccionURL: self.coleccionPrincipalURL)
            //Como en swiftui no se puede definir el tamaño de la lista antes de introducir nada hay que introducir objetos dummys hasta el tamaño que queramos
            DispatchQueue.main.async { self.listaElementos = Array(repeating: ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo, count: totalElements.count) }
            
            for (index, element) in totalElements.enumerated() {
                let elementInstance = ElementoSistemaArchivos(
                    name: element.lastPathComponent,
                    url: element,
                    creationDate: Date(),
                    modificationDate: Date()
                )
                
                print(elementInstance.name, "CARGADO")
                
                DispatchQueue.main.async {
                    self.listaElementos[index] = elementInstance
                }
                
                Thread.sleep(forTimeInterval: 0.07) // Simula carga escalonada
            }

            
            //3. Si hay 50 archivos se cargaran 50 placeholders en la vista
//            if let cacheColecciones = self.cacheColecciones[self.coleccionPrincipalURL] {
//                //Si esta en el cache actualizamos
//                self.actualizarCache()
//            } else {
//                //si no esta en cache indexamos desde 0
//                self.indexarColeccion()
//            }
            
            //4. Ordenamos el cache y construimos la lista tempListSorted
            
            //5. Asignamos las instancias a listaElementos
            
        }
        
    }
    
    /**
     Solamente agregar los nuevos elementos a la coleccion que fue previamente indexada y esta en cache.
     */
    private func actualizarCache() {
        
    }
    
    /**
     Indexa todos los elementos de la coleccion y los introduce en el cache.
     */
    private func indexarColeccion() {
        
    }
    
    //MARK: - METODOS DEL SISTEMA DE ARCHIVOS
    
    /**
     Escanea el directorio dado para obtener las URLs de los elementos contenidos en él.
     
     - Parameter coleccionURL: La URL del directorio a escanear.
     - Returns: Un array de URLs que representan los elementos en el directorio.
     */
    private func obtenerURLSDirectorio(coleccionURL: URL) -> [URL] {
        do {
            // Obtén todas las URLs en el directorio
            let contentsURLs = try FileManager.default.contentsOfDirectory(at: coleccionURL, includingPropertiesForKeys: nil)
            // Filtra los elementos según sea necesario (descomentar o modificar según el uso)
            let filteredURLs = contentsURLs.filter { url in
                // Aplica filtros personalizados aquí (si es necesario)
                // return indexingFilters.allSatisfy { $0.shouldInclude(url: url) }
                true
            }
            
            print("En total hay para el directorio: ", self.coleccionPrincipalURL)
            print(filteredURLs.count)
            print(filteredURLs)
            
            return filteredURLs
        } catch {
            print("Error al obtener las URLs del directorio '\(coleccionURL.lastPathComponent)': \(error.localizedDescription)")
            return []
        }
    }

//    func crearArchivosPrueba() {
//        let fileManager = FileManager.default
//        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("No se pudo obtener el directorio de documentos")
//            return
//        }
//
//        for i in 1...40 {
//            let nombreArchivo = "archivo\(i).txt"
//            let contenidoArchivo = "Contenido del archivo \(i)"
//            let fileURL = documentsURL.appendingPathComponent(nombreArchivo)
//
//            do {
//                try contenidoArchivo.write(to: fileURL, atomically: true, encoding: .utf8)
//                print("Archivo creado: \(fileURL.path)")
//            } catch {
//                print("Error al crear el archivo \(nombreArchivo): \(error)")
//            }
//        }
//    }
    
    
    // MARK: – Ejemplo de método que modifica `elements` (protegido por fileQueue)
    public func indexarCarpeta(_ carpeta: URL) {
        // Usamos fileQueue.async para hacer trabajo en background
        fileQueue.async { [weak self] in
            guard let self = self else { return }
            // --- Aquí iría la lógica real de leer el contenido de “carpeta” ---
            // Supongamos que construimos un array provisional:
            let nuevos: [Any] = [] // <-- reemplaza con tu propio modelo
            
            // Cuando ya tenemos el array completo, publicamos en el hilo principal:
//            DispatchQueue.main.async {
//                self.elementList = nuevos
//            }
        }
    }
    
    // MARK: – Ejemplo de método para borrar un elemento (protegido por fileQueue)
    public func borrarElemento(_ elemento: Any) throws {
        try fileQueue.sync {
            // --- Lógica para borrar del disco, actualizar caches internas, etc. ---
            // Por ejemplo:
            // try FileManager.default.removeItem(at: (elemento as! URL))
            //
            // Una vez borrado en disco, actualizamos la propiedad `elements` en main:
            
            DispatchQueue.main.async {
                // Aquí harías algo como:
                // self.elements.removeAll { $0.id == elemento.id }
                // (Este es solo un ejemplo; adapta a tu modelo real)
            }
        }
    }
    
    // MARK: – Ejemplo de método para mover/renombrar (protegido por fileQueue)
    public func moverElemento(_ elemento: Any, a nuevaURL: URL) throws {
        try fileQueue.sync {
            // --- Lógica para mover/renombrar en disco ---
            // try FileManager.default.moveItem(at: (elemento as! URL), to: nuevaURL)
            //
            // Luego, actualizar caches internas si tienes, y finalmente:
            
            DispatchQueue.main.async {
                // Actualizas `elements` para reflejar la nueva URL/nombre, etc.
            }
        }
    }
    
    // MARK: – Ejemplo de método para crear una carpeta nueva (protegido)
    public func crearCarpeta(_ nombre: String, en carpetaPadre: URL) {
        fileQueue.async {
            // --- Lógica para crear carpeta en disco ---
            // let urlNueva = carpetaPadre.appendingPathComponent(nombre, isDirectory: true)
            // try? FileManager.default.createDirectory(at: urlNueva, withIntermediateDirectories: true)
            //
            // Luego reindexar o actualizar caches, y publicar en main:
            
            DispatchQueue.main.async {
                // Por ejemplo: self.indexarCarpeta(carpetaPadre)
            }
        }
    }
    
    
}
