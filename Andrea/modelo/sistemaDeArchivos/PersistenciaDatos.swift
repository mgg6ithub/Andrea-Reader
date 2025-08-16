

import SwiftUI

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
    
    private func convertirValor(_ valor: Any) -> Any? {
        switch valor {
        //datos basicos
        case let v as Int: return v
        case let v as Double: return v
        case let v as Bool: return v
        case let v as String: return v
        
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
            
        //colores
        case let v as Color: return v.toHexString
        default: return nil
        }
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
    //MARK: - --- AJUSTES GENERALES ---
    
}

extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X", Int(red*255), Int(green*255), Int(blue*255))
    }
}

extension Color {
    var toHexString: String {
        UIColor(self).toHexString()
    }

    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        if scanner.scanHexInt64(&rgb) {
            let r = Double((rgb >> 16) & 0xFF) / 255.0
            let g = Double((rgb >> 8) & 0xFF) / 255.0
            let b = Double(rgb & 0xFF) / 255.0
            self.init(red: r, green: g, blue: b)
        } else {
            self = .blue // fallback color
        }
    }
}




