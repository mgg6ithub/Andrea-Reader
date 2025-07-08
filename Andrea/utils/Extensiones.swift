
import SwiftUI
import ZIPFoundation

//MARK: --- PERSISTENCIA PARA LOS AJUSTES GENERALES DE USUARIO ---
/**
 Modificacion para poder guardar enums en UserDefaults
 */
extension UserDefaults {
    func setEnum<T: RawRepresentable>(_ value: T, forKey key: String) where T.RawValue == String {
        set(value.rawValue, forKey: key)
    }

    func getEnum<T: RawRepresentable>(forKey key: String, default defaultValue: T) -> T where T.RawValue == String {
        guard let rawValue = string(forKey: key), let value = T(rawValue: rawValue) else {
            return defaultValue
        }
        return value
    }
    
    // Si también usas enums con Int
    func getEnum<T: RawRepresentable>(forKey key: String, default defaultValue: T) -> T where T.RawValue == Int {
        let rawValue = self.integer(forKey: key)
        return T(rawValue: rawValue) ?? defaultValue
    }
}



//MARK: - MODELO HERENCIA PARA EL SISTEMA DE ARCHVIOS

// Extensión para cumplir con el protocolo Transferable en la clase **ElementoSistemaArchivos**
extension ElementoSistemaArchivos: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.url)
    }
}


//MARK: - VISTAS

//Modificador para agregar un shimmering a una vista concreta
extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}


//MARK: - ANIMACION TEXTO

extension View {
    /// Le pasas tu Int, internamente se convierte a Double
    func animatedProgressText1(_ intValue: Int) -> some View {
        let doubleValue = Double(intValue)
        return self.modifier(ProgressTextModifier1(value: doubleValue))
    }
}

struct ProgressTextModifier1: AnimatableModifier {
    /// Este es el valor animable
    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        Text("% \(Int(value))")
    }
}

