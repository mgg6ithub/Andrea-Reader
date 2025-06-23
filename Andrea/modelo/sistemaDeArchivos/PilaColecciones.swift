

import SwiftUI

class PilaColecciones: ObservableObject {
    
    //Cola para administrar el acceso al singleton desde todo el programa
    private static let pilaColeccionesQueue = DispatchQueue(label: "com.miApp.pilaColecciones")
    
    //Singleton perezoso
    private static var pilaColecciones: PilaColecciones? = nil
    
    //MARK: - Creamos por primera vez el singleton de ayuda del sistema de archivos y lo usamos para asignar la coleccion actual (Documents) coelccion raiz
    private(set) var coleccionRaiz: URL = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.rootDirectory
    
    //Cola personalizada donde se almacenaran en el orden en el que el usuario entre a las colecciones
    //(final) Coleccion1 -> Coleccion2 -> Coleccion3 (principio)
    @Published private(set) var colecciones: [Coleccion] = []
    
    //Constructor privado
    private init() {
        //1. Inicializamos el estado de la pila anteriormente guardado
        //  1.1 Introducimos los valores en colecciones y actualizamos coleccionActual con la ultima coleccion
        //2. Si no se puede coleccionActual = coleccionRaiz (Documents)
        self.cargarPila()
        
        SistemaArchivos.getSistemaArchivosSingleton.refreshIndex(coleccionActual: self.coleccionRaiz)
    }
    
    //Metodo principal para obtener la unica instancia del singleton
    public static var getPilaColeccionesSingleton: PilaColecciones {
        return pilaColeccionesQueue.sync {
            if pilaColecciones == nil {
                pilaColecciones = PilaColecciones()
            }
            return pilaColecciones!
        }
    }
    
    /**
     Persistencia de la pila. Se obtiene la pila como se guardo.
     */
    public func cargarPila() {
        
        let coleccionRaizStripped = self.coleccionRaiz.deletingLastPathComponent()
        
        if let pilaGuardada = UserDefaults.standard.array(forKey: ConstantesPorDefecto().pilaColeccionesClave) as? [String] {
            
            // 1. Convertimos los paths relativos guardados a URLs absolutas
            let coleccionesGuardadas: [URL] = pilaGuardada.compactMap { col in
                let absolutaURL = coleccionRaizStripped.appendingPathComponent(col)
                return ManipulacionCadenas().agregarPrivate(absolutaURL)
            }

            // 2. Obtenemos el cache
            let cache = SistemaArchivos.getSistemaArchivosSingleton.cacheColecciones
            
//            print(coleccionesGuardadas)
//            print()
//            print(cache)
            
            // 3. Extraemos las colecciones en el orden dado
            self.colecciones = coleccionesGuardadas.compactMap { url in
                cache[url]?.coleccion
            }
            
//            print("PILA DE COLECCIONES")
//            print(self.colecciones)
            
        }
    }
    
    /**
     Guarda el estado de la pila.
     Guarda el nombre de las colecciones en el orden en el que estan.
     */
    public func guardarPila() {
        let coleccionRaizStripped = self.coleccionRaiz.deletingLastPathComponent().path
        
        let rutasRelativas = self.colecciones.map { col in
            let normalizarURL = ManipulacionCadenas().normalizarURL(col.url).path
            return normalizarURL.replacingOccurrences(of: coleccionRaizStripped, with: "").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }
        UserDefaults.standard.set(rutasRelativas, forKey: ConstantesPorDefecto().pilaColeccionesClave)
    }
    
    /**
     Mete una coleccion en la parte de arriba de la pila.
     */
    public func meterColeccion(coleccion: Coleccion) {
        colecciones.append(coleccion) //agregamos la coleccion a la pila
        print("Has metido: ", coleccion.name)
        self.guardarPila() //guardamos persistencia
        SistemaArchivos.getSistemaArchivosSingleton.refreshIndex(coleccionActual: coleccion.url) //hacemos un refresh sobre esa coleccion
    }
    
    /**
     Saca la primera coleccion de la pila, es decir, la coleccion de la parte de arriba de pila.
     */
    public func sacarColeccion() {
        colecciones.popLast()
    }
    
    /**
     Obtener la priemera coleccion de la pila de colecciones.
     */
    public func getColeccionActual() -> Coleccion {
        return self.colecciones.last!
    }
    
    /**
     Metodo para comprobar si la coleccion es la primera de la pila.
     */
    public func esColeccionActual(coleccion: Coleccion) -> Bool {
        return self.getColeccionActual() == coleccion
    }
    
    /**
     Saca de la pila todos los elementos posteriores al seleccionado.
     */
    public func sacarHastaEncontrarColeccion(coleccion: Coleccion) {
        while let ultima = colecciones.last {
            if ultima == coleccion {
                // Si quieres mantener la colección encontrada, simplemente haz break aquí
                self.guardarPila()
                SistemaArchivos.getSistemaArchivosSingleton.refreshIndex(coleccionActual: coleccion.url) //hacemos un refresh sobre esa coleccion
                break
            }
            colecciones.removeLast()
        }
    }

    
}
