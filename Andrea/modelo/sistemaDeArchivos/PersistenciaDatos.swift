

import SwiftUI

//MARK: --- PROGRESO DE LAS PAGINAS DE CADA ARCHIVO ---

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
            
        //Arrays y diccinarios
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
        return (self.obtenerMapa(key: key)[k] as? T) ?? def
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

    
    //metodo para actualizar o borrar la clave en un diccinario pasando una key = String
    //Si el valor esta vacio es para borrar ese dato de persistencia.
    //Si se pasa un array con mas de un valor quiere decir que es para borrarlos
    public func actualizarDatoArchivo(valor: Any?, anteriorURL: URL, nuevaURL: URL, keys: [String]) {
        let oldk = self.obtenerKey(anteriorURL)
        let newk = self.obtenerKey(nuevaURL)
        
        for dKey in keys {
            var mapa = self.obtenerMapa(key: dKey)
            
            if let convertido = self.convertirValor(valor as Any) {
                mapa[newk] = mapa[oldk] // <- actualizar nueva clave con el valor antigua
            } else {
                mapa.removeValue(forKey: oldk) // <- borrar entrada
            }
            
            guardarMapa(mapa: mapa, key: dKey)
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
            print("Error a la hora de obtener el mapa en persistencia para: ", key)
            return [:]
        }
    }
    
    private func guardarMapa(mapa: [String : Any], key: String) {
        uds.set(mapa, forKey: key)
    }
    
}







