

import SwiftUI


class SistemaArchivos: ObservableObject {
    
    // MARK: --- Instancia singleton totalmente segura, lazy, thread-safe ---
    static let sa: SistemaArchivos = SistemaArchivos()
    
//    private static let sistemaArchivosQueue = DispatchQueue(label: "com.miApp.singletonSistemaArchivos")
    
    //MARK: - Creamos por primera vez el singleton de ayuda del sistema de archivos y lo usamos para asignar la coleccion actual (Documents) coelccion raiz
    private(set) var homeURL: URL = SistemaArchivosUtilidades.sau.home

    
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
    
    private let sau = SistemaArchivosUtilidades.sau
    private let fm: FileManager = FileManager.default
    
    //MARK: - CONSTRUCTOR
    /**
     1. Se obtiene el directorio actual
     2. Metodo recursivo para calcular todos las colecciones.
     3. Se asigna en la pila para inicializar la coleccion del usuario
     4. Se realiza el primer indexado de dicha coleccion
     */
    private init() {
        // Crear la coleccion raiz y asignarla
        let home = FabricaColeccion().crearColeccion(collectionName: "HOME", collectionURL: self.homeURL)
        cacheColecciones[homeURL] = ColeccionValor(coleccion: home)
        
        // Indexar recursivamente a partir de la raiz
        self.indexamientoRecursivoColecciones(desde: homeURL)
    }
    
    /**
     Recorre recursivamente todas las colecciones.
     */
    private func indexamientoRecursivoColecciones(desde coleccionURL: URL) {

        // Verificamos que es un directorio válido antes de continuar
        guard sau.isDirectory(elementURL: coleccionURL) else { return }

        // Si no está ya cacheado, lo agregamos al cache con una lista vacía de elementos
        if cacheColecciones[coleccionURL] == nil {
            let coleccion = FabricaColeccion().crearColeccion(collectionName: sau.getFileName(fileURL: coleccionURL), collectionURL: coleccionURL)
            cacheColecciones[coleccionURL] = ColeccionValor(coleccion: coleccion)
        }

        guard let coleccionValor = cacheColecciones[coleccionURL] else { return }
        // Filtramos solo los directorios
        let subdirectorios = obtenerURLSDirectorio(coleccionURL: coleccionURL).filter { sau.isDirectory(elementURL: $0) }
        
        // Llamamos recursivamente sobre cada subdirectorio
        for subdir in subdirectorios {
            coleccionValor.subColecciones.insert(subdir)
            indexamientoRecursivoColecciones(desde: subdir)
        }
        
    }
    
    private let indexacionQueue = OperationQueue()

    
    public func crearInstancia(elementoURL: URL, coleccionDestinoURL: URL? = nil) -> ElementoSistemaArchivos {
    
        let destinoURL: URL = coleccionDestinoURL ?? self.homeURL
        
        if sau.isDirectory(elementURL: elementoURL) {
            if let coleccionValor: ColeccionValor = self.cacheColecciones[elementoURL] {
                return coleccionValor.coleccion
            }
            return FabricaColeccion().crearColeccion(collectionName: sau.getFileName(fileURL: elementoURL), collectionURL: elementoURL)
        } else {
            return FactoryArchivo().crearArchivo(fileName: sau.getFileName(fileURL: elementoURL), fileURL: elementoURL, destionationURL: destinoURL, currentDirectory: self.homeURL)
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
    func obtenerURLSDirectorio(coleccionURL: URL) -> [URL] {
        do {
            let contentsURLs = try fm.contentsOfDirectory(at: coleccionURL, includingPropertiesForKeys: nil)
            let filteredURLs = contentsURLs.filter { url in
                // Aplica filtros personalizados aquí (si es necesario)
                // return indexingFilters.allSatisfy { $0.shouldInclude(url: url) }
                true
            }
            
            return filteredURLs
        } catch {
            print("Error al obtener las URLs del directorio '\(coleccionURL.lastPathComponent)': \(error.localizedDescription)")
            return []
        }
    }
    
    
    // MARK: – Ejemplo de método para borrar un elemento (protegido por fileQueue)
    public func borrarElemento(elemento: any ElementoSistemaArchivosProtocolo, vm: ColeccionViewModel) {
        fileQueue.async {
            
            // --- obtenemos la url del elemento a borrar
            let url: URL = elemento.url
            do {
                try self.fm.removeItem(at: url) //borramos del dispositivo con fm
                
                DispatchQueue.main.async {
                    // Verifica que realmente se haya borrado
                    let existe = SistemaArchivosUtilidades
                        .sau
                        .fileExists(elementURL: url)
                    
                    if !existe { //si ya no existe
                        withAnimation(.easeInOut(duration: 0.35)) {
                            vm.elementos.removeAll(where: { $0.id == elemento.id }) //borramos de la vista del vm
                        }
                        
                        if self.cacheColecciones[url] != nil {
                            self.cacheColecciones.removeValue(forKey: url) //borramos del cache de coleccion en sa
                            print("✅ Colección eliminada del cache")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    // Aquí podrías mostrar un alert en la UI si usas un binding
                    print("⚠️ Error al borrar el archivo: \(error)")
                }
            }
        }
    }

    
    
    // MARK: – Ejemplo de método para mover/renombrar (protegido por fileQueue)
    public func moverElemento(_ elemento: Any, a nuevaURL: URL) throws {
        fileQueue.sync {
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
            let coleccionDestinoURL = coleccionDestino ?? self.homeURL
            // 3. Construimos la nueva URL
            let nuevoArchivoURL = coleccionDestinoURL.appendingPathComponent(nombreArchivo)
            
            // --- Agregamos el archivo a la carpeta Andrea para la persistencia ---
            if !self.sau.fileExists(elementURL: nuevoArchivoURL) {
                
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
                
                // --- Agregamos el archivo a la listaElementos para actualizar la UI solo con ese elemento
                self.actualizarUISoloElemento(elementoURL: nuevoArchivoURL)
                return
            }
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
            let coleccionDestino = direccionNuevaColeccion ?? self.homeURL
            let nuevaColeccionURL = coleccionDestino.appendingPathComponent(nombre, isDirectory: true)
            
            if !self.sau.fileExists(elementURL: nuevaColeccionURL) {
                try? self.fm.createDirectory(at: nuevaColeccionURL, withIntermediateDirectories: true)
                
                // --- Creamos la instancia de la coleccion ---
                self.actualizarUISoloElemento(elementoURL: nuevaColeccionURL)
            }
            else {
                print("La coleccion ya existe no se creara otra")
            }
        }
    }
    
    
    /**
     Agregar en el hilo principal un elemento a la listaElementos para actualizar la UI solo con ese elemento. Puede ser un archivo o una coleccion.
     - Parameters:
        - elementoURL: URL
     */
    private func actualizarUISoloElemento(elementoURL: URL) {
        
        // --- Introducir el elemento en la lista en el hilo principal
        let elemento: ElementoSistemaArchivos = self.crearInstancia(elementoURL: elementoURL)
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.35)) {
                    PilaColecciones.pilaColecciones.getColeccionActual().elementos.append(elemento)
                }
            }

        //Actualizar todas las instancias dependientes de dicho elemento
        
    }
    
    
}
