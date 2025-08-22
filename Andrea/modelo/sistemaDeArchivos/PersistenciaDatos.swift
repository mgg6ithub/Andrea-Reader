

import SwiftUI


//MARK: --- BORRA TODOS LOS DATOS PERSISTENTES REINICIANDO UD ---

extension PersistenciaDatos {
    public func reiniciarPersistencia() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print("⚠️ Se ha reiniciado toda la persistencia de la app (UserDefaults limpiado).")
    }
}

//MARK: --- BORRADO RECURSIVO EN PERSISTENCIA AL BORRAR UNA COLECCION (hay que borrar todo lo que tenga dentro) ---

extension PersistenciaDatos {
    func eliminarPersistenciaRecursiva(coleccionURL: URL, keys: [String]) {
        let baseKey = obtenerKey(coleccionURL)   // ejemplo: "/documents/test"
                
        for key in keys {
            var mapa = obtenerMapa(key: key)
            
            // Filtramos todas las sub-entradas que empiecen por la ruta base
            let keysAEliminar = mapa.keys.filter { $0.hasPrefix(baseKey) }
            
            for k in keysAEliminar {
                mapa.removeValue(forKey: k)
                print("🗑️ Eliminado recursivamente de persistencia: \(k) en '\(key)'")
            }
            
            guardarMapa(mapa: mapa, key: key)
        }
    }
}

//MARK: --- RNOMBRAR O MOVER UNA COLECCION RECURSIVAMENTE ---
extension PersistenciaDatos {
    /// Actualizar recursivamente todas las entradas de persistencia al renombrar/mover un directorio
    public func actualizarDatoArchivoRecursivo(origenURL: URL, destinoURL: URL, keys: [String]) {
        let oldk = obtenerKey(origenURL)   // Ejemplo: "/documents/test"
        let newk = obtenerKey(destinoURL)  // Ejemplo: "/documents/test-renombrado"
        
        for key in keys {
            var mapa = obtenerMapa(key: key)
            
            // Filtramos todas las claves que empiecen con la ruta original
            let keysAActualizar = mapa.keys.filter { $0.hasPrefix(oldk) }
            
            for k in keysAActualizar {
                // Creamos la nueva clave reemplazando el prefijo
                let newChildKey = k.replacingOccurrences(of: oldk, with: newk)
                mapa[newChildKey] = mapa[k]
                mapa.removeValue(forKey: k)
                
                print("🔄 Actualizado persistencia en '\(key)': \(k) → \(newChildKey)")
            }
            
            guardarMapa(mapa: mapa, key: key)
        }
    }
}


//MARK: --- CONVERTIDOR UNIVERSAL ---

extension PersistenciaDatos {
    func convertirValor(_ valor: Any) -> Any? {
        switch valor {
        //datos basicos
        case let v as Int: return v
        case let v as Double: return v
        case let v as Bool: return v
        case let v as String: return v
        case let v as CGFloat: return v
        
        //enums
        case let v as EnumTipoMiniatura: return v.rawValue
        case let v as EnumTipoMiniaturaColeccion: return v.rawValue
        case let v as EnumDireccionAbanico: return v.rawValue
        case let v as EnumModoVista: return v.rawValue
        case let v as EnumOrdenaciones: return v.rawValue
        case let v as EnumTemas: return v.rawValue
        case let v as EnumTipoSistemaArchivos: return v.rawValue
        case let v as EnumAjusteColor: return v.rawValue
        case let v as EnumBarraEstado: return v.rawValue
        case let v as EnumFuenteIcono: return v.rawValue
        case let v as EnumFondoMenu: return v.rawValue
        case let v as EnumEstiloHistorialColecciones: return v.rawValue
        case let v as EnumPorcentajeEstilo: return v.rawValue
        case let v as EnumTipoMiniatura: return v.rawValue
            
        //colores
        case let v as Color: return v.toHexString
            
        // fechas y tiempos
        case let v as Date: return v.timeIntervalSince1970  // Double
        case let v as TimeInterval: return Int(v)           // segundos redondeados
            
        //Arrays y diccinarios
        // ✅ Diccionarios con claves Int -> claves String
        case let v as [Int: Int]:
            return Dictionary(uniqueKeysWithValues: v.map { (String($0.key), $0.value) })

        case let v as [Int: TimeInterval]:
            return Dictionary(uniqueKeysWithValues: v.map { (String($0.key), Int($0.value.rounded())) })

        case let v as [String:Int]:    return v
        case let v as [String:Double]: return v
        case let v as [String:Bool]:   return v
        case let v as [String:String]: return v
        case let v as [Int]:           return v
        case let v as [Double]:        return v
        case let v as [Bool]:          return v
        case let v as [String]:        return v
            
        default: return nil
        }
    }
}

//MARK: --- ESTRCUTURA PARA CENTRALIZAR EL ACCESO A UD ---

struct PersistenciaDatos {
    
    let mc = ManipulacionCadenas()
    private let uds = UserDefaults.standard
    
    //MARK: --- ELIMINAR CLAVE Y VALOR DE PERSISTENCIA ---
    public func eliminarDatos(url: URL) {
        let key = obtenerKey(url)
        uds.removeObject(forKey: key)
        print("🗑️ Eliminados datos de persistencia para la clave: \(key)")
    }

    
    //MARK: --- ACTUALIZAR PERSISTENCIA ---
    public func actualizarClaveURL(origen: URL, destino: URL) {
        let keyAntigua = obtenerKey(origen)
        let keyNueva = obtenerKey(destino)

        guard let datosAntiguos = uds.dictionary(forKey: keyAntigua) else {
            print("⚠️ No se encontraron datos en persistencia para la clave antigua: \(keyAntigua)")
            return
        }

        uds.set(datosAntiguos, forKey: keyNueva)
        uds.removeObject(forKey: keyAntigua)
        print("🔄 Persistencia actualizada de \(keyAntigua) → \(keyNueva)")
    }
    
    //MARK: --- DUPLICAR DATOS DE UNA CLAVE ---
    public func duplicarDatosClave(origen: URL, destino: URL) {
        let keyOrigen = obtenerKey(origen)
        let keyDestino = obtenerKey(destino)
        
        guard let datosOrigen = uds.dictionary(forKey: keyOrigen) else {
            print("⚠️ No se encontraron datos para duplicar desde la clave: \(keyOrigen)")
            return
        }

        uds.set(datosOrigen, forKey: keyDestino)
        print("📄 Datos duplicados de \(keyOrigen) → \(keyDestino)")
    }
    
    //MARK: --- ARCHIVO ---
    public func guardarDatoElemento(url: URL, atributo: String, valor: Any) {
        let key = obtenerKey(url)
        var dict = uds.dictionary(forKey: key) ?? [:]

        if let convertido = self.convertirValor(valor) {
            dict[atributo] = convertido
        }
        
        uds.set(dict, forKey: key)
    }
    
    //MARK:  --- COLECCION ---
    
    // MARK: - Keys
    public func obtenerKey(_ url: URL) -> String {
        mc.borrarURLLOCAL(url: url)
    }


    // MARK: - Obtener todos los datos de un elemento
    public func obtenerAtributos(url: URL) -> [String: Any]? {
        let key = obtenerKey(url)
        return uds.dictionary(forKey: key)
    }

    // MARK: - Obtener un atributo específico
    public func obtenerAtributoConcreto(url: URL, atributo: String) -> Any? {
        let key = obtenerKey(url)
        
        guard let dict = uds.dictionary(forKey: key) else { return nil }
        return dict[atributo]
    }
    
    public func obtenerAtributoVista(coleccion: Coleccion, modo: EnumModoVista, atributo: String) -> Any? {
        let key = obtenerKey(coleccion.url)
        guard let dict = uds.dictionary(forKey: key),
              let vistaAtributos = dict["vistaAtributos"] as? [String: Any],
              let atributosVista = vistaAtributos[modo.rawValue] as? [String: Any] else {
            return nil
        }
        
        return atributosVista[atributo]
    }

    
    //MARK: - gurdar un atributo
    public func guardarAtributoVista(coleccion: Coleccion, modo: EnumModoVista, atributo: String, valor: Any) {
        let key = obtenerKey(coleccion.url)
        var dict = uds.dictionary(forKey: key) ?? [:]

        var vistaAtributos = dict["vistaAtributos"] as? [String: Any] ?? [:]
        var atributosVista = vistaAtributos[modo.rawValue] as? [String: Any] ?? [:]

        atributosVista[atributo] = valor
        vistaAtributos[modo.rawValue] = atributosVista
        dict["vistaAtributos"] = vistaAtributos

        uds.set(dict, forKey: key)
    }
    

    //MARK: - --- AJUSTES GENERALES ---
    public func guardarAjusteGeneral(valor: Any, key: String) {
        if let convertido = self.convertirValor(valor) {
            uds.set(convertido, forKey: key)
        }
    }
    
    public func obtenerAjusteGeneral<T>(key: String, default def: T) -> T {
        return (uds.object(forKey: key) as? T) ?? def
    }

    public func obtenerAjusteGeneralEnum<E: RawRepresentable>(key: String, default def: E) -> E where E.RawValue == String {
        if let raw = UserDefaults.standard.string(forKey: key),
           let e = E(rawValue: raw) {
            return e
        }
        return def
    }
    
    public func obtenerAjusteGeneralEnum<E: RawRepresentable>(key: String, default def: E) -> E where E.RawValue == Int {
        let raw = uds.object(forKey: key) as? Int
        return raw.flatMap { E(rawValue: $0) } ?? def
    }

    /// Color guardado como hex (porque en guardar usas Color -> hex)
    public func obtenerAjusteGeneralColor(key: String, default def: Color) -> Color {
        if let hex = uds.string(forKey: key) {
            return Color(hex: hex)
        }
        return def
    }
    
    //MARK: - --- GUARDAR DICCINARIOS CON MUCHOS DATOS PERO UNA SOLA CLAVE EN UD (Para elementos) ---
    // valor = Dato (int, string, bool, enum ...) que se guarda en ud
    // elementURL = el elemento (coleccion o archivo) al que pertenece el valor se usara como k en el dict
    // key = llave de ese diccinario donde se guardaran todos los datos
    public func guardarDatoArchivo(valor: Any, elementoURL: URL, key: String) { // <- sirve para sobreescribir valors es decir actualizar
        let k = self.obtenerKey(elementoURL)
        if let convertido = self.convertirValor(valor) {
            var mapa = obtenerMapa(key: key)
            mapa[k] = convertido
            guardarMapa(mapa: mapa, key: key)
        }
    }
    
    //elementoURL = el elemento del que se quiere recuperar el dato (clave del dict)
    //key = clave del diccinario donde estara ese dato asociado a dicho elementoURL
    public func recuperarDatoElemento<T>(elementoURL: URL, key: String, default def: T) -> T {
        let k = self.obtenerKey(elementoURL)
        let valor = self.obtenerMapa(key: key)[k]

        // Caso especial: Date
        if T.self == Date.self, let timestamp = valor as? Double {
            return Date(timeIntervalSince1970: timestamp) as! T
        }

        // Caso especial: Date?
        if T.self == Date?.self, let timestamp = valor as? Double {
            return (Date(timeIntervalSince1970: timestamp) as Date?) as! T
        }

        // Caso especial: Color
        if T.self == Color.self, let hex = valor as? String {
            return Color(hex: hex) as! T
        }

        return (valor as? T) ?? def
    }

    
    /// Recuperar un enum guardado como rawValue en el mapa
    public func recuperarDatoArchivoEnum<E: RawRepresentable>(elementoURL: URL, key: String, default def: E) -> E where E.RawValue: Any {
        let k = self.obtenerKey(elementoURL)
        let mapa = self.obtenerMapa(key: key)
        
        if let raw = mapa[k] as? E.RawValue, let value = E(rawValue: raw) {
            return value
        }
        return def
    }
    
    
    /// Recuperar un color desde persistencia
//    public func recuperarDatoArchivoColor(elementoURL: URL, key: String, default def: Color) -> Color {
//        let k = self.obtenerKey(elementoURL)
//        let mapa = self.obtenerMapa(key: key)
//
//        if let hex = mapa[k] as? String {
//            return Color(hex: hex)
//        }
//        return def
//    }

    
    /// Actualizar la clave en varios diccionarios de persistencia (ej: al renombrar o mover un archivo)
    public func actualizarDatoArchivo(origenURL: URL, destinoURL: URL, keys: [String]) {
        let oldk = self.obtenerKey(origenURL)
        let newk = self.obtenerKey(destinoURL)
        
        for key in keys {
            var mapa = self.obtenerMapa(key: key)
            if let valor = mapa[oldk] {
                mapa[newk] = valor
                mapa.removeValue(forKey: oldk) // eliminar la antigua
                guardarMapa(mapa: mapa, key: key)
                print("🔄 Actualizado persistencia en '\(key)': \(oldk) → \(newk)")
            } else {
                print("⚠️ No se encontró valor para '\(oldk)' en '\(key)'")
            }
        }
    }
    
    // Duplicar datos de una clave (atributos asociados directamente a una URL)
    /// No borra el origen, solo copia su valor a la nueva URL.
    public func duplicarDatoElemento(origenURL: URL, destinoURL: URL, keys: [String]) {
        let oldk = self.obtenerKey(origenURL)
        let newk = self.obtenerKey(destinoURL)
        
        for key in keys {
            var mapa = self.obtenerMapa(key: key)
            if let valor = mapa[oldk] {
                mapa[newk] = valor
                guardarMapa(mapa: mapa, key: key)
                print("📄 Duplicado en '\(key)': \(oldk) → \(newk)")
            } else {
                print("⚠️ No se encontró valor en '\(key)' para \(oldk)")
            }
        }
    }


    
    //metodo para eliminar de persistencia
    public func eliminarPersistenciaElemento(elementoURL: URL, keys: [String]) {
        let k = self.obtenerKey(elementoURL)
        
        for key in keys {
            var mapaParaEstaKey = self.obtenerMapa(key: key)
            mapaParaEstaKey.removeValue(forKey: k)
            print("Eliminado de persistencia: ", elementoURL.lastPathComponent)
            self.guardarMapa(mapa: mapaParaEstaKey, key: key)
        }
    }
    
    
//    public func actualizarDatoArchivo(valor: Any?, elementoURL: URL, key: String) {
//        
//    }

    //metodo para actualizar o borrar varias claves en un diccinario pasando un array de keys = [String]
    
    private func obtenerMapa(key: String) -> [String : Any] {
        if let mapa = uds.dictionary(forKey: key) {
            return mapa
        } else {
//            print("Error a la hora de obtener el mapa en persistencia para: ", key)
            return [:]
        }
    }
    
    private func guardarMapa(mapa: [String : Any], key: String) {
        uds.set(mapa, forKey: key)
    }
    
}

extension PersistenciaDatos {
    func recuperarTiemposPorPagina(elementoURL: URL, key: String) -> [Int: TimeInterval] {
        let k = obtenerKey(elementoURL)
        let mapa = obtenerMapa(key: key)

        guard let raw = mapa[k] as? [String: Any] ?? mapa[k] as? [String: Int] else {
            return [:]
        }

        var result: [Int: TimeInterval] = [:]
        for (ks, v) in raw {
            guard let page = Int(ks) else { continue }
            if let n = v as? Int {
                result[page] = TimeInterval(n)
            } else if let d = v as? Double {
                result[page] = d
            }
        }
        return result
    }

    func recuperarVisitasPorPagina(elementoURL: URL, key: String) -> [Int: Int] {
        let k = obtenerKey(elementoURL)
        let mapa = obtenerMapa(key: key)

        guard let raw = mapa[k] as? [String: Int] else { return [:] }

        var result: [Int: Int] = [:]
        for (ks, v) in raw {
            if let page = Int(ks) {
                result[page] = v
            }
        }
        return result
    }
}










