//
//  PersistenciaDatos.swift
//  Andrea
//
//  Created by mgg on 2/7/25.
//

import SwiftUI

struct PersistenciaDatos {
    
    //MARK:  --- COLECCION ---
    
    // MARK: - Keys
    private func keyParaColeccion(_ coleccion: Coleccion) -> String {
        ManipulacionCadenas().borrarURLLOCAL(url: coleccion.url)
    }

    // MARK: - Guardar todo el diccionario
    @MainActor
    public func guardarDatosColeccion(coleccion: ColeccionViewModel) {
        let key = keyParaColeccion(coleccion.coleccion)

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


    // MARK: - Restaurar datos
    public func obtenerDatosColeccion(coleccion: Coleccion) -> [String: Any]? {
        let key = keyParaColeccion(coleccion)
        return UserDefaults.standard.dictionary(forKey: key)
    }


    // MARK: - Obtener un atributo específico
    public func obtenerAtributo(coleccion: Coleccion, atributo: String) -> Any? {
        let key = keyParaColeccion(coleccion)
        guard let dict = UserDefaults.standard.dictionary(forKey: key) else { return nil }
        return dict[atributo]
    }
    
    
    public func obtenerAtributoVista(coleccion: Coleccion, modo: EnumModoVista, atributo: String) -> Any? {
        let key = keyParaColeccion(coleccion)
        guard let dict = UserDefaults.standard.dictionary(forKey: key),
              let vistaAtributos = dict["vistaAtributos"] as? [String: Any],
              let atributosVista = vistaAtributos[modo.rawValue] as? [String: Any] else {
            return nil
        }
        
        return atributosVista[atributo]
    }
    

    // MARK: - Guardar / modificar un solo atributo
    public func guardarAtributo(coleccion: Coleccion, atributo: String, valor: Any) {
        let key = keyParaColeccion(coleccion)
        var dict = UserDefaults.standard.dictionary(forKey: key) ?? [:]

        if let valorEnum = valor as? EnumModoVista {
            dict[atributo] = valorEnum.rawValue
        } else if let valorColor = valor as? Color {
            dict[atributo] = valorColor.toHexString
        } else if let valor = valor as? String {
            dict[atributo] = valor
        } else if let valor = valor as? Int {
            dict[atributo] = valor
        } else if let valor = valor as? Bool {
            dict[atributo] = valor
        } else {
            print("⚠️ Tipo no soportado para persistencia: \(type(of: valor))")
            return
        }

        UserDefaults.standard.set(dict, forKey: key)
    }

    public func guardarAtributoVista(coleccion: Coleccion, modo: EnumModoVista, atributo: String, valor: Any) {
        let key = keyParaColeccion(coleccion)
        var dict = UserDefaults.standard.dictionary(forKey: key) ?? [:]

        var vistaAtributos = dict["vistaAtributos"] as? [String: Any] ?? [:]
        var atributosVista = vistaAtributos[modo.rawValue] as? [String: Any] ?? [:]

        atributosVista[atributo] = 4
//        atributosVista[atributo] = valor
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

