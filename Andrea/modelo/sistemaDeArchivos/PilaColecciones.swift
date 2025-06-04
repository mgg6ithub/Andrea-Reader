

import SwiftUI

class PilaColecciones: ObservableObject {
    
    //Cola para administrar el acceso al singleton desde todo el programa
    private static let pilaColeccionesQueue = DispatchQueue(label: "com.miApp.pilaColecciones")
    
    //Singleton perezoso
    private static var pilaColecciones: PilaColecciones? = nil
    
    //Cola personalizada donde se almacenaran en el orden en el que el usuario entre a las colecciones
    //(final) Coleccion1 -> Coleccion2 -> Coleccion3 (principio)
    @Published private(set) var colecciones: [Coleccion] = []
    
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
    
    /**
     Mete una coleccion en la parte de arriba de la pila.
     */
    public func meterColeccion(coleccion: Coleccion) {
        colecciones.append(coleccion)
        print("Has metido: ", coleccion.name)
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
    public func coleccionActual() -> Coleccion {
        return self.colecciones.last!
    }
    
    /**
     Metodo para comprobar si la coleccion es la primera de la pila.
     */
    public func esColeccionActual(coleccion: Coleccion) -> Bool {
        return self.coleccionActual() == coleccion
    }
    
    /**
     Saca de la pila todos los elementos posteriores al seleccionado.
     */
    public func sacarHastaEncontrarColeccion(coleccion: Coleccion) {
        while let ultima = colecciones.last {
            if ultima == coleccion {
                // Si quieres mantener la colección encontrada, simplemente haz break aquí
                break
            }
            colecciones.removeLast()
        }
    }

    
}
