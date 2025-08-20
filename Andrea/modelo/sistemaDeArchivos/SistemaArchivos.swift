

import SwiftUI


class SistemaArchivos: ObservableObject {
    
    private let pd = PersistenciaDatos()
    private let cpe = ClavesPersistenciaElementos()
    
    // MARK: --- Instancia singleton totalmente segura, lazy, thread-safe ---
    static let sa: SistemaArchivos = SistemaArchivos()
//    static var sa: SistemaArchivos = {
//        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
//            return SistemaArchivos(preview: true)
//        } else {
//            return SistemaArchivos()
//        }
//    }()
    
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
     2. Metodo recursivo para calcular todos las coleccones.
     3. Se asigna en la pila para inicializar la coleccion del usuario
     4. Se realiza el primer indexado de dicha coleccion
     */
    private init(preview: Bool = false) {
        
        self.homeURL = ManipulacionCadenas().agregarPrivate(self.homeURL)
        
        // Crear la coleccion raiz y asignarla
        let home = FabricaColeccion().crearColeccion(coleccionNombre: "HOME", coleccionURL: self.homeURL)
        cacheColecciones[homeURL] = ColeccionValor(coleccion: home)
        
//        if preview {
//            let coleccion1 = homeURL.appendingPathComponent("Coleccion1")
//            let coleccion2 = homeURL.appendingPathComponent("Coleccion2")
//            let coleccion3 = homeURL.appendingPathComponent("Coleccion3")
//            
//            for url in [coleccion1, coleccion2, coleccion3] {
//                let nombre = url.lastPathComponent
//                let col = FabricaColeccion().crearColeccion(coleccionNombre: nombre, coleccionURL: url)
//                cacheColecciones[url] = ColeccionValor(coleccion: col)
//                cacheColecciones[homeURL]?.subColecciones.insert(url)
//            }
//            return
//        }
        
        // Indexar recursivamente a partir de la raiz
        self.indexamientoRecursivoColecciones(desde: homeURL)
        
    }
    
    func obtenerColeccionPrincipal() -> Coleccion? {
        return cacheColecciones[homeURL]?.coleccion
    }
    
    /**
     Recorre recursivamente todas las colecciones.
     */
    private func indexamientoRecursivoColecciones(desde coleccionURL: URL) {

        // Verificamos que es un directorio válido antes de continuar
        guard sau.isDirectory(elementURL: coleccionURL) else { return }

        // Si no está ya cacheado, lo agregamos al cache con una lista vacía de elementos
        if cacheColecciones[coleccionURL] == nil {
            let coleccion = FabricaColeccion().crearColeccion(coleccionNombre: sau.getFileName(fileURL: coleccionURL), coleccionURL: coleccionURL)
            cacheColecciones[coleccionURL] = ColeccionValor(coleccion: coleccion)
        }

        guard let coleccionValor = cacheColecciones[coleccionURL] else { return }
        // Filtramos solo los directorios
        var subdirectorios = obtenerURLSDirectorio(coleccionURL: coleccionURL).filter { sau.isDirectory(elementURL: $0) }
        
        //Filtramos
        subdirectorios = subdirectorios.filter { url in
            SistemaArchivosUtilidades.sau.filtrosIndexado.allSatisfy {
                $0.shouldInclude(url: url)
            }
        }
        
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
            return FabricaColeccion().crearColeccion(coleccionNombre: sau.getFileName(fileURL: elementoURL), coleccionURL: elementoURL)
        } else {
            return FactoryArchivo().crearArchivo(fileName: sau.getFileName(fileURL: elementoURL), fileURL: elementoURL, destionationURL: destinoURL, currentDirectory: self.homeURL)
        }
    }
    
    
    //MARK: - METODOS DEL SISTEMA DE ARCHIVOS

    /**
     Escanea el directorio dado para obtener las URLs de los elementos contenidos en él.
     
     - Parameter coleccionURL: La URL del directorio a escanear.
     - Returns: Un array de URLs que representan los elementos en el directorio.
     */
    func obtenerURLSDirectorio(coleccionURL: URL) -> [URL] {
        do {
//            print(coleccionURL)
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
    
    //MARK: --- renombrar elemento del sistema de archivos ---
    public func renombrarElemento(elemento: any ElementoSistemaArchivosProtocolo, nuevoNombre: String) {
        fileQueue.async {
            
            let origenURL = elemento.url
            let extensionOriginal = origenURL.pathExtension
            
            var nuevoNombre = nuevoNombre
            if !self.sau.isDirectory(elementURL: origenURL) {
                nuevoNombre = ManipulacionCadenas().joinNameWithExtension(name: nuevoNombre, ext: extensionOriginal)
            }
            
            let destinoURL = origenURL.deletingLastPathComponent().appendingPathComponent(nuevoNombre)
            nuevoNombre = self.sau.eliminarExtension(nombreArchivo: nuevoNombre)
            
            do {
                try self.fm.moveItem(at: origenURL, to: destinoURL) //Renombrar dentro del sistema de archivos
                
                //--- Actualizamos vista --- 
                if let archivo = elemento as? Archivo {
                    withAnimation { archivo.nombre = nuevoNombre }
                    archivo.url = destinoURL
                } else if let coleccion = elemento as? Coleccion {
                    withAnimation { coleccion.nombre = nuevoNombre }
                    coleccion.url = destinoURL
                    //--- si es una coleccion actualizamos el cache de colecciones del sa ---
                    let valor = self.cacheColecciones.removeValue(forKey: origenURL)
                    self.cacheColecciones[destinoURL] = valor
                }
                
                // --- actualizar persistencia ---
//                PersistenciaDatos().actualizarClaveURL(origen: origenURL, destino: destinoURL)
                self.pd.actualizarDatoArchivo(origenURL: origenURL, destinoURL: destinoURL, keys: self.cpe.arrayClavesPersistenciaElementos)
                
                // --- LOG ---
                DispatchQueue.main.async {
                    NotificacionesEstado.ne.crearLog(mensaje: "Renombrado de \(origenURL.lastPathComponent) -> \(nuevoNombre).", icono: "cambio-nombre", color: .orange)
                }
                
            } catch {
                DispatchQueue.main.async {
                    print("⚠️ Error al renombrar el archivo: \(error)")
                }
            }
        }
    }
    
    // MARK: – Ejemplo de método para mover/renombrar (protegido por fileQueue)
    public func moverElemento(_ elemento: any ElementoSistemaArchivosProtocolo, vm: ModeloColeccion, a nuevaURL: URL) throws {
        fileQueue.sync {
            
            let origenURL = elemento.url
            let destinoURL = nuevaURL.appendingPathComponent(origenURL.lastPathComponent)
            
            do {
                
                try self.fm.moveItem(at: origenURL, to: destinoURL)
                
                //--- actualizar la vista ---
                let coleccionActual: Coleccion = vm.coleccion
                
                guard let coleccionDestino: Coleccion = self.cacheColecciones[nuevaURL]?.coleccion else {
                    print("No se ha podido obtener la coleccion destino")
                    return
                }
                
                DispatchQueue.main.async { withAnimation(.easeInOut(duration: 0.35)) { vm.elementos.removeAll(where: { $0.id == elemento.id }) } }
                
                if let _ = elemento as? Archivo {
                    coleccionActual.totalArchivos -= 1
                    coleccionDestino.totalArchivos += 1
                } else if let coleccion = elemento as? Coleccion { // si es coleccion
                    coleccionActual.totalColecciones -= 1
                    coleccionDestino.totalColecciones += 1
                    
                    //--- actualizar cache colecciones ---
                    coleccion.url = destinoURL
                    self.borrarColeccionDeCache(claveURL: origenURL)
                    
                    let nuevaColeccionValor = ColeccionValor(coleccion: coleccion)
                    self.cacheColecciones[destinoURL] = nuevaColeccionValor
                    
                    // 2. Actualizar la colección padre
                    if let valorPadre = self.cacheColecciones[nuevaURL] {
                        valorPadre.subColecciones.insert(destinoURL)
                        valorPadre.listaElementos.append(coleccion)
                    }
                }
                
                // --- actualizar persistencia ---
                self.pd.actualizarDatoArchivo(origenURL: origenURL, destinoURL: destinoURL, keys: self.cpe.arrayClavesPersistenciaElementos)
        
            } catch {
                print("⚠️ Error al mover \(origenURL.lastPathComponent) a \(destinoURL.lastPathComponent)")
            }
        }
    }
    
    // MARK: – Ejemplo de método para mover/renombrar (protegido por fileQueue)
    public func copiarElemento(_ elemento: any ElementoSistemaArchivosProtocolo, vm: ModeloColeccion, a nuevaURL: URL) throws {
        fileQueue.sync {
            let origenURL = elemento.url
            let destinoURL = nuevaURL.appendingPathComponent(origenURL.lastPathComponent)
            
            do {
                try self.fm.copyItem(at: origenURL, to: destinoURL)
                
                //--- actualizamos la instancia de la coleccion destino ---
                guard let coleccionDestino: Coleccion = self.cacheColecciones[nuevaURL]?.coleccion else {
                    print("No se ha podido obtener la coleccion destino")
                    return
                }
                
                if let _ = elemento as? Archivo {
                    coleccionDestino.totalArchivos += 1
                } else if let coleccion = elemento as? Coleccion {
                    coleccionDestino.totalArchivos += 1
                    
                    let nuevaColeccionValor = ColeccionValor(coleccion: coleccion)
                    self.cacheColecciones[destinoURL] = nuevaColeccionValor
                    
                    // 2. Actualizar la colección padre
                    if let valorPadre = self.cacheColecciones[nuevaURL] {
                        valorPadre.subColecciones.insert(destinoURL)
                        valorPadre.listaElementos.append(coleccion)
                    }
                    
                    //--- duplicar en persistencia ---
//                    PersistenciaDatos().duplicarDatosClave(origen: origenURL, destino: destinoURL)
                    self.pd.duplicarDatoElemento(origenURL: origenURL, destinoURL: destinoURL, keys: self.cpe.arrayClavesPersistenciaElementos)
                }
                
            } catch {
                print("⚠️ Error al copiar \(origenURL.lastPathComponent) a \(destinoURL.lastPathComponent)")
            }
        }
    }
    
    //MARK: --- DUPLICACION RAPIDA DE UN ELEMENTO EN LA MISMA COLECCION ---
    public func duplicarElemento(_ elemento: any ElementoSistemaArchivosProtocolo, vm: ModeloColeccion) throws {
        fileQueue.sync {
            
            let origenURL = elemento.url
            let nombreOrigen = origenURL.deletingPathExtension().lastPathComponent + "(1)" + "." + origenURL.pathExtension
            
            let duplicadaURL = origenURL.deletingLastPathComponent().appendingPathComponent(nombreOrigen)
            
            print("Nombre duplicado -> ", nombreOrigen)
            print("URL nueva -> ", duplicadaURL)
            
            do {
                
                try self.fm.copyItem(at: origenURL, to: duplicadaURL)
                
                Task { @MainActor in
                    self.actualizarUISoloElemento(elementoURL: duplicadaURL)
                }
                
            } catch {
                print("⚠️ Error al duplicar \(origenURL.lastPathComponent) a \(duplicadaURL.lastPathComponent)")
            }
            
            //--- duplicar en persistencia ---
//            PersistenciaDatos().duplicarDatosClave(origen: origenURL, destino: duplicadaURL)
            self.pd.duplicarDatoElemento(origenURL: origenURL, destinoURL: duplicadaURL, keys: self.cpe.arrayClavesPersistenciaElementos)
            
        }
    }
    
    
    /**
     Borra la coleccion pasada del cache de colecciones.
     
     - Parameter claveURL: URL de la coleccion para borrarla del diccinario.
     */
    private func borrarColeccionDeCache(claveURL: URL) {
        if self.cacheColecciones[claveURL] != nil {
            self.cacheColecciones.removeValue(forKey: claveURL) //borramos del cache de coleccion en sa
            print("✅ Colección eliminada del cache")
        }
    }
    
    
    // MARK: – Ejemplo de método para borrar un elemento (protegido por fileQueue)
    public func borrarElemento(elemento: any ElementoSistemaArchivosProtocolo, vm: ModeloColeccion) {
        fileQueue.async {
            
            // --- obtenemos la url del elemento a borrar
            let url: URL = elemento.url
            let esDirectorio = self.sau.isDirectory(elementURL: url)
            
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
                        
                        if esDirectorio {
                            vm.coleccion.totalColecciones -= 1
                            self.borrarColeccionDeCache(claveURL: url)
                        } else {
                            vm.coleccion.totalArchivos -= 1
                        }
                    }
                    
                    // --- ELIMINAR PERSISTENCIA ---
                    self.pd.eliminarPersistenciaElemento(elementoURL: url, keys: self.cpe.arrayClavesPersistenciaElementos)
                    
                    // --- LOG ---
                    var tipo: String = ""
                    if let _ = elemento as? Coleccion {
                        tipo = "Coleccion"
                    } else {
                        tipo = "Archivo"
                    }
                    NotificacionesEstado.ne.crearLog(mensaje: "\(tipo) \(elemento.nombre) eliminado.", icono: "\(tipo)-eliminado", color: .red)
                    
                }
            } catch {
                DispatchQueue.main.async {
                    // Aquí podrías mostrar un alert en la UI si usas un binding
                    print("⚠️ Error al borrar el archivo: \(error)")
                }
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
            
            // 1. Obtenenmos el nombre de la url
            let nombreArchivo: String = archivoURL.lastPathComponent
            // 2. Verificamos si se ha pasado un destino concreto. Si no se creara en la colecciona actual.
            let coleccionDestinoURL = coleccionDestino ?? self.homeURL
            // 3. Construimos la nueva URL
            let nuevoArchivoURL = coleccionDestinoURL.appendingPathComponent(nombreArchivo)
            
            // --- AL IMPORTAR UN ARCHIVO SE CREAR ---
            // guardamos su nombre original al importar
            PersistenciaDatos().guardarDatoElemento(url: nuevoArchivoURL, atributo: "nombreOriginal", valor: nombreArchivo)
            //guardamos la fecha en la que se importo
            PersistenciaDatos().guardarDatoElemento(url: nuevoArchivoURL, atributo: "fechaImportacion", valor: Fechas().formatDate1(Date()))
            
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
                Task { @MainActor in
                    // --- LOG HISTORIAL ---
                    NotificacionesEstado.ne.crearLog(mensaje: "Archivo \(nombreArchivo) importado.", icono: "Archivo-creado", color: .green)
                    self.actualizarUISoloElemento(elementoURL: nuevoArchivoURL)
                }
                
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
                
                // --- LOG ---
                NotificacionesEstado.ne.crearLog(mensaje: "Coleccion \(nombre) creada.", icono: "Coleccion-creado", color: .green)
                
                // --- Creamos la instancia de la coleccion ---
                Task { @MainActor in
                    self.actualizarUISoloElemento(elementoURL: nuevaColeccionURL, coleccionDestino: coleccionDestino)
                }
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
    @MainActor 
    private func actualizarUISoloElemento(elementoURL: URL, coleccionDestino: URL? = nil) {
        
        // --- Introducir el elemento en la lista en el hilo principal
        let elemento: ElementoSistemaArchivos = self.crearInstancia(elementoURL: elementoURL)
        
        let coleccionActualVM = PilaColecciones.pilaColecciones.getColeccionActual()

        print("Creando un nuevo archiov: ", elementoURL.lastPathComponent)
        print("Archivo en la coleccion:")
        for c in coleccionActualVM.elementos {
            print(c.nombre)
        }
        
        // ✅ Actualizar UI en el hilo principal
        DispatchQueue.main.async {
            withAnimation(.easeOut(duration: 0.35)) {
                coleccionActualVM.elementos.append(elemento)
            }
        }

        //Actualizar todas las instancias dependientes de dicho elemento
        if sau.isDirectory(elementURL: elemento.url) {
            guard let nuevaColeccion = elemento as? Coleccion else { return }
            guard let coleccionDestino = coleccionDestino else { return }
            let nuevoValor = ColeccionValor(coleccion: nuevaColeccion)
            self.cacheColecciones[elementoURL] = nuevoValor
            
            // 2. Actualizar la colección padre
            if let valorPadre = self.cacheColecciones[coleccionDestino] {
                valorPadre.subColecciones.insert(elementoURL)
                valorPadre.coleccion.totalColecciones += 1
                valorPadre.listaElementos.append(nuevaColeccion)
            } else {
                print("⚠️ No se encontró la colección padre en el cache: \(coleccionDestino.path)")
            }
        } else {
            coleccionActualVM.coleccion.totalArchivos += 1
        }
        
    }
    
    
}
