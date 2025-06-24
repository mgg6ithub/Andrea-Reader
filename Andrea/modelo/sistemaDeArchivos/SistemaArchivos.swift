

import SwiftUI


class SistemaArchivos: ObservableObject {
    
    // MARK: – Instancia singleton (perezosa + protegida con queue de sincronización)
    private static var sistemaArchivos: SistemaArchivos? = nil
    
    private static let sistemaArchivosQueue = DispatchQueue(label: "com.miApp.singletonSistemaArchivos")
    
    //MARK: - Creamos por primera vez el singleton de ayuda del sistema de archivos y lo usamos para asignar la coleccion actual (Documents) coelccion raiz
    private(set) var coleccionHomeURL: URL = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.rootDirectory
    
//    private(set) var coleccionHome: ColeccionValor
    
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
    //MARK: – Cola para proteger acceso a propiedades internas (lectura/escritura concurrente)
    private let fileQueue = DispatchQueue(label: "com.miApp.sistemaArchivos.queue", attributes: .concurrent)
    
    /**
     *Diccinario de directorios cache para almacenar objetos previamente creados por cada directorio. Para una navegacion rapida entre el sistema de archivos.*
     */
    private(set) var cacheColecciones: [URL : ColeccionValor] = [:] //Solo accesible desde el (sa). Clave -> Direccion unica URL, Valor -> Estructura con una instancia de la coleccion y la lista de sus elementos.
    
    /**
     La idea es mantener privado el cache y la lista publica. Porque la lista se puede ordenar con facilidad y iterar.
     PATRON DE FUNCIONAMIENTO: Indexar directorio actual -> Comprobar Cache -> Agregar al cache los elementos que no esten -> Pasar del cache a la lista -> Ordenar lista
     */
    
    @Published var listaElementos: [any ElementoSistemaArchivosProtocolo] = [] //Es es la lista publica que se vinculara a la vista de la libreria.
    
    private let fm: FileManager = FileManager.default
    
    //MARK: - CONSTRUCTOR
    /**
     1. Se obtiene el directorio actual
     2. Metodo recursivo para calcular todos las colecciones.
     3. Se asigna en la pila para inicializar la coleccion del usuario
     4. Se realiza el primer indexado de dicha coleccion
     */
    private init() {
        
        let coleccionHomeURL = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.rootDirectory
//        self.coleccionHome = ColeccionValor(coleccion: FabricaColeccion().crearColeccion(collectionName: coleccionHomeURL.lastPathComponent, collectionURL: coleccionHomeURL)!)
        
        //Creamos el cache de colecciones -> Instanciando todas las colecciones posibles
        self.indexamientoRecursivoColecciones(desde: coleccionHomeURL)
        
//        if let coleccionValor = self.cacheColecciones[coleccionHomeURL] {
//            self.coleccionHome = coleccionValor
//        }
        
    }
    
    /**
     Recorre recursivamente todas las colecciones.
     */
    private func indexamientoRecursivoColecciones(desde coleccionURL: URL) {
        let sau = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton

        // Verificamos que es un directorio válido antes de continuar
        guard sau.isDirectory(elementURL: coleccionURL) else { return }

        // Si no está ya cacheado, lo agregamos al cache con una lista vacía de elementos
        if cacheColecciones[coleccionURL] == nil {
            if let coleccion = FabricaColeccion().crearColeccion(collectionName: sau.getFileName(fileURL: coleccionURL), collectionURL: coleccionURL) {
                cacheColecciones[coleccionURL] = ColeccionValor(coleccion: coleccion)
            }
        }

        guard var coleccionValor = cacheColecciones[coleccionURL] else { return }
        // Filtramos solo los directorios
        let subdirectorios = obtenerURLSDirectorio(coleccionURL: coleccionURL).filter { sau.isDirectory(elementURL: $0) }
        
        // Llamamos recursivamente sobre cada subdirectorio
        for subdir in subdirectorios {
            coleccionValor.subColecciones.insert(subdir)
            indexamientoRecursivoColecciones(desde: subdir)
        }
        
        
        
    }
    
    
    public func refreshIndex(coleccionActual: URL, completion: (() -> Void)? = nil) {
        
        //1. Borramos lo que hubiera anteriormente
        DispatchQueue.main.async {
            self.listaElementos.removeAll()
        }
        
        //Si ya esta en cache actualizamos la lista con los elementos del cache y retornamos
        if let coleccionValor = self.cacheColecciones[coleccionActual],
           !coleccionValor.listaElementos.isEmpty {
            
            DispatchQueue.main.async {
                print("Ya esta en cache: ", coleccionValor.coleccion.name)
                print(coleccionValor.listaElementos)
                self.listaElementos = coleccionValor.listaElementos
                completion?()
            }
            return
        }
        
        //Creamos un hilo en el background para el indexado
        DispatchQueue.global().async {
            
            //Iniciamos el indexado
            //2. Primero escaneamos el directorio para saber el total de elementos que habra. Para cargar en la vista los placeholders.
            let totalElements = self.obtenerURLSDirectorio(coleccionURL: coleccionActual)

            //Como en swiftui no se puede definir el tamaño de la lista antes de introducir nada hay que introducir objetos dummys hasta el tamaño que queramos
            DispatchQueue.main.async {
                self.listaElementos = Array(repeating: ElementoPlaceholder() as any ElementoSistemaArchivosProtocolo, count: totalElements.count)
            }
            
            for (index, element) in totalElements.enumerated() {
                if let elemento: (any ElementoSistemaArchivosProtocolo) = self.crearInstancia(elementoURL: element) {
                    DispatchQueue.main.async {
                        self.listaElementos[index] = elemento
                    }
                }
            }
            
            DispatchQueue.main.async { 
                if let coleccionValor = self.cacheColecciones[coleccionActual] {
                    coleccionValor.listaElementos = self.listaElementos
                }
                completion?()
            }
            
        }
        
    }
    
    public func crearInstancia(elementoURL: URL, coleccionDestinoURL: URL? = nil) -> (any ElementoSistemaArchivosProtocolo)? {
        
        let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton
        let destinoURL: URL = coleccionDestinoURL ?? self.coleccionHomeURL
        
        if sau.isDirectory(elementURL: elementoURL) {
            if let coleccionValor: ColeccionValor = self.cacheColecciones[elementoURL] {
                return coleccionValor.coleccion
            }
            return FabricaColeccion().crearColeccion(collectionName: sau.getFileName(fileURL: elementoURL), collectionURL: elementoURL)
        } else {
            return FactoryArchivo().crearArchivo(fileName: sau.getFileName(fileURL: elementoURL), fileURL: elementoURL, destionationURL: destinoURL, currentDirectory: self.coleccionHomeURL)
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
            
            //            print("En total hay para el directorio: ", self.coleccionHomeURL)
            //            print(filteredURLs.count)
            //            print(filteredURLs)
            
            return filteredURLs
        } catch {
            print("Error al obtener las URLs del directorio '\(coleccionURL.lastPathComponent)': \(error.localizedDescription)")
            return []
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
    
    /**
     Crea un archivo en la coleccion de destino indicada. Si no se pasa la coleccion de destino lo creara en la actual.
     
        - Parameters:
        - nombre: Nombre del archivo que se creara.
        - coleccionDestino:  Destino de la coleccion donde se creara el archivo.
     */
    public func crearArchivo(archivoURL: URL, coleccionDestino: URL? = nil) {
        
        fileQueue.async {
            
            // --- Construimos la URL del nuevo archivo
            
            // 1. Obtenenmos el nombre de la url
            let nombreArchivo: String = archivoURL.lastPathComponent
            // 2. Verificamos si se ha pasado un destino concreto. Si no se creara en la colecciona actual.
            let coleccionDestinoURL = coleccionDestino ?? self.coleccionHomeURL
            // 3. Construimos la nueva URL
            let nuevoArchivoURL = coleccionDestinoURL.appendingPathComponent(nombreArchivo)
            
            // --- Agregamos el archivo a la carpeta Andrea para la persistencia ---
            if !SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.fileExists(elementURL: nuevoArchivoURL) {
                
                do {
                    guard archivoURL.startAccessingSecurityScopedResource() else {
                        print("No se pudo acceder al archivo de manera segura.")
                        return
                    }
                    defer { archivoURL.stopAccessingSecurityScopedResource() }
                    
                    try self.fm.copyItem(at: archivoURL, to: nuevoArchivoURL)
                } catch {
                    print("Error a la hora de crear el archivo -> ", nombreArchivo)
                }
                
            }
            
            // --- Agregamos el archivo a la listaElementos para actualizar la UI solo con ese elemento
            self.actualizarUISoloElemento(elementoURL: nuevoArchivoURL)
            
        }
        
    }
    
    
    /**
     Crea una nueva carpeta dentro del sistema de archivos en una ruta determinada o, por defecto, en la colección actual.
     
     - Parameters:
        - nombre: Nombre de la carpeta que se desea crear.
        - direccionNuevaColeccion: Ruta opcional donde se desea crear la nueva carpeta. Si no se proporciona, se usará `coleccionActual`.
     */
    public func crearColeccion(nombre: String, en direccionNuevaColeccion: URL? = nil) {
        fileQueue.async {
            // --- Lógica para crear carpeta en disco ---
            let coleccionDestino = direccionNuevaColeccion ?? self.coleccionHomeURL
            let nuevaColeccionURL = coleccionDestino.appendingPathComponent(nombre, isDirectory: true)
            try? self.fm.createDirectory(at: nuevaColeccionURL, withIntermediateDirectories: true)
            
            // --- Creamos la instancia de la coleccion ---
            self.actualizarUISoloElemento(elementoURL: nuevaColeccionURL)

        }
    }
    
    
    /**
     Agregar en el hilo principal un elemento a la listaElementos para actualizar la UI solo con ese elemento. Puede ser un archivo o una coleccion.
     - Parameters:
        - elementoURL: URL
     */
    private func actualizarUISoloElemento(elementoURL: URL) {
        
        // --- Introducir el elemento en la lista en el hilo principal
        if let coleccion: (any ElementoSistemaArchivosProtocolo) = self.crearInstancia(elementoURL: elementoURL) {
            DispatchQueue.main.async { self.listaElementos.append(coleccion) }
        }
        
        //Actualizar todas las instancias dependientes de dicho elemento
        
    }
    
    
}
