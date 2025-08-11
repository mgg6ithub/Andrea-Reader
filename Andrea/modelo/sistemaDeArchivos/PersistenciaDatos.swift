

import SwiftUI

struct PersistenciaDatos {
    
    let mc = ManipulacionCadenas()
    
    //MARK: --- ACTUALIZAR PERSISTENCIA ---
    public func actualizarClaveURL(origen: URL, destino: URL) {
        let keyAntigua = obtenerKey(origen)
        let keyNueva = obtenerKey(destino)

        guard let datosAntiguos = UserDefaults.standard.dictionary(forKey: keyAntigua) else {
            print("⚠️ No se encontraron datos en persistencia para la clave antigua: \(keyAntigua)")
            return
        }

        UserDefaults.standard.set(datosAntiguos, forKey: keyNueva)
        UserDefaults.standard.removeObject(forKey: keyAntigua)
        print("🔄 Persistencia actualizada de \(keyAntigua) → \(keyNueva)")
    }
    
    //MARK: --- DUPLICAR DATOS DE UNA CLAVE ---
    public func duplicarDatosClave(origen: URL, destino: URL) {
        let keyOrigen = obtenerKey(origen)
        let keyDestino = obtenerKey(destino)
        
        guard let datosOrigen = UserDefaults.standard.dictionary(forKey: keyOrigen) else {
            print("⚠️ No se encontraron datos para duplicar desde la clave: \(keyOrigen)")
            return
        }

        UserDefaults.standard.set(datosOrigen, forKey: keyDestino)
        print("📄 Datos duplicados de \(keyOrigen) → \(keyDestino)")
    }


    
    //MARK: --- ARCHIVO ---
    public func guardarDatoElemento(url: URL, atributo: String, valor: Any) {
        
        let key = obtenerKey(url)
        
        print("Guardando con la key -> \(key)")
        
        var dict = UserDefaults.standard.dictionary(forKey: key) ?? [:]

        if let valor = valor as? Int {
            dict[atributo] = valor
        } else if let valor = valor as? Double {
            dict[atributo] = valor
        } else if let valor = valor as? Bool {
            dict[atributo] = valor
        } else if let valor = valor as? String {
            dict[atributo] = valor
        } else if let tipoMiniatura = valor as? EnumTipoMiniatura {
            dict[atributo] = tipoMiniatura.rawValue
        } else if let tipoMiniatura = valor as? EnumTipoMiniaturaColeccion {
            dict[atributo] = tipoMiniatura.rawValue
        } else if let direccionAbanico = valor as? EnumDireccionAbanico {
            dict[atributo] = direccionAbanico.rawValue
        } else {
            print("⚠️ Tipo no soportado para persistencia en elemento: \(type(of: valor))")
            return
        }
        
        UserDefaults.standard.set(dict, forKey: key)
    }

    
    //MARK:  --- COLECCION ---
    
    // MARK: - Keys
    private func obtenerKey(_ url: URL) -> String {
        mc.borrarURLLOCAL(url: url)
    }


    // MARK: - Obtener todos los datos de un elemento
    public func obtenerAtributos(url: URL) -> [String: Any]? {
        let key = obtenerKey(url)
        return UserDefaults.standard.dictionary(forKey: key)
    }

    // MARK: - Obtener un atributo específico
    public func obtenerAtributoConcreto(url: URL, atributo: String) -> Any? {
        
        let key = obtenerKey(url)
        
        guard let dict = UserDefaults.standard.dictionary(forKey: key) else { return nil }
        return dict[atributo]
    }
    
    public func obtenerAtributoVista(coleccion: Coleccion, modo: EnumModoVista, atributo: String) -> Any? {
        let key = obtenerKey(coleccion.url)
        guard let dict = UserDefaults.standard.dictionary(forKey: key),
              let vistaAtributos = dict["vistaAtributos"] as? [String: Any],
              let atributosVista = vistaAtributos[modo.rawValue] as? [String: Any] else {
            return nil
        }
        
        return atributosVista[atributo]
    }
    
    
    // MARK: - Guardar todo el diccionario
    @MainActor
    public func guardarDatosColeccion(coleccion: ModeloColeccion) {
        let key = obtenerKey(coleccion.coleccion.url)

        var datos: [String: Any] = [
            "scrollPosition": coleccion.scrollPosition,
            "color": coleccion.color.toHexString,
            "tipoVista": coleccion.modoVista.rawValue
        ]
        
        // Atributos específicos de la vista actual
        switch coleccion.modoVista {
        case .cuadricula:
            datos["vistaAtributos"] = [
                "cuadricula": [
                    "columnas": coleccion.columnas
                ]
            ]
        case .lista:
            datos["vistaAtributos"] = [
                "lista": [
                    "alturaItem": coleccion.altura
                ]
            ]
        default:
            break
        }

        UserDefaults.standard.set(datos, forKey: key)
    }
    

    // MARK: - Guardar / modificar un solo atributo
    public func guardarAtributoColeccion(coleccion: Coleccion, atributo: String, valor: Any) {
        let key = obtenerKey(coleccion.url)
        var dict = UserDefaults.standard.dictionary(forKey: key) ?? [:]

        if let tipoVistaEnum = valor as? EnumModoVista {
            dict[atributo] = tipoVistaEnum.rawValue
        } else if let ordenacionEnum = valor as? EnumOrdenaciones {
            dict[atributo] = ordenacionEnum.rawValue
        } else if let valorColor = valor as? Color {
            dict[atributo] = valorColor.toHexString
        } else if let valor = valor as? String {
            dict[atributo] = valor
        } else if let valor = valor as? Int {
            dict[atributo] = valor
        } else if let valor = valor as? Bool {
            dict[atributo] = valor
        } else if let valorDict = valor as? [String: Int] {
            dict[atributo] = valorDict
        } else {
            print("⚠️ Tipo no soportado para persistencia: \(type(of: valor))")
            return
        }

        UserDefaults.standard.set(dict, forKey: key)
    }
    
    //MARK: - gurdar un atributo
    public func guardarAtributoVista(coleccion: Coleccion, modo: EnumModoVista, atributo: String, valor: Any) {
        let key = obtenerKey(coleccion.url)
        var dict = UserDefaults.standard.dictionary(forKey: key) ?? [:]

        var vistaAtributos = dict["vistaAtributos"] as? [String: Any] ?? [:]
        var atributosVista = vistaAtributos[modo.rawValue] as? [String: Any] ?? [:]

        atributosVista[atributo] = valor
        vistaAtributos[modo.rawValue] = atributosVista
        dict["vistaAtributos"] = vistaAtributos

        UserDefaults.standard.set(dict, forKey: key)
    }

    
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




