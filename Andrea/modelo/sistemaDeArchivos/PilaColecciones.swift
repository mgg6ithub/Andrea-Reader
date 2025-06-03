

import SwiftUI

class PilaColecciones: ObservableObject {
    
    //Cola para administrar el acceso al singleton desde todo el programa
    private static let pilaColeccionesQueue = DispatchQueue(label: "com.miApp.pilaColecciones")
    
    //Singleton perezoso
    private static var pilaColecciones: PilaColecciones? = nil
    
    //Cola personalizada donde se almacenaran en el orden en el que el usuario entre a las colecciones
    //(final) Coleccion1 -> Coleccion2 -> Coleccion3 (principio)
    private(set) var colecciones: [URL] = []
    
    //Constructor privado
    private init() {}
    
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
        if let pilaGuardada = UserDefaults.standard.array(forKey: ConstantesPorDefecto().pilaColeccionesClave) {
            print(pilaGuardada)
        }
    }
    
    /**
     Guarda el estado de la pila.
     Guarda el nombre de las colecciones en el orden en el que estan.
     */
    public func guardarPila() {
        let coleccionPrincipal = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.rootDirectory
        
    }
    
}
