
import SwiftUI

struct ModificarSize<Value: Numeric & Comparable>: ViewModifier {
    @Binding var value: Value
    var minValue: Value
    var maxValue: Value
    var step: Value
    @Binding var scrollEnabled: Bool

    // Parámetros para persistir
    var coleccion: Coleccion
    var modoVista: EnumModoVista
    var atributo: String

    @State private var lastMagnification: CGFloat = 1.0
    @State private var currentMagnification: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { val in
                        scrollEnabled = false
                        currentMagnification = val
                    }
                    .onEnded { val in
                        let delta = val / lastMagnification

                        let currentDouble = toDouble(value)
                        let stepDouble = toDouble(step)
                        let minDouble = toDouble(minValue)
                        let maxDouble = toDouble(maxValue)

                        var newValue = currentDouble

                        switch modoVista {
                        case .cuadricula:
                            if delta > 1.1, currentDouble - stepDouble >= minDouble {
                                // Zoom in (acercar) => menos columnas
                                newValue = currentDouble - stepDouble
                            } else if delta < 0.9, currentDouble + stepDouble <= maxDouble {
                                // Zoom out (alejar) => más columnas
                                newValue = currentDouble + stepDouble
                            }
                            //--- PERSISTENCIA ---
                            if let convertedBack = fromDouble(newValue) { value = convertedBack }
                            PersistenciaDatos().guardarDatoArchivo(valor: value, elementoURL: coleccion.url, key: ClavesPersistenciaElementos().columnas)
                            
                        default:
                            if delta > 1.1, currentDouble + stepDouble <= maxDouble {
                                // Zoom in (acercar) => más tamaño
                                newValue = currentDouble + stepDouble
                            } else if delta < 0.9, currentDouble - stepDouble >= minDouble {
                                // Zoom out (alejar) => menos tamaño
                                newValue = currentDouble - stepDouble
                            }
                            
                            //--- PERSISTENCIA ---
                            if let convertedBack = fromDouble(newValue) { value = convertedBack }
                            PersistenciaDatos().guardarDatoArchivo(valor: value, elementoURL: coleccion.url, key: ClavesPersistenciaElementos().altura)
                            
                        }
                        
                        lastMagnification = 1.0
                        currentMagnification = 1.0

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            scrollEnabled = true
                        }
                    }
            )
    }

    // Helpers para convertir Numeric genérico a Double
    func toDouble<T: Numeric>(_ val: T) -> Double {
        if let v = val as? Double { return v }
        if let v = val as? CGFloat { return Double(v) }
        if let v = val as? Int { return Double(v) }
        // Agrega más conversiones si quieres
        return 0
    }

    func fromDouble(_ val: Double) -> Value? {
        if Value.self == Double.self {
            return val as? Value
        }
        if Value.self == CGFloat.self {
            return CGFloat(val) as? Value
        }
        if Value.self == Int.self {
            return Int(val) as? Value
        }
        return nil
    }
}

extension View {
    func modificarSizeExtension<Value: Numeric & Comparable>(
        value: Binding<Value>,
        minValue: Value,
        maxValue: Value,
        step: Value,
        scrollEnabled: Binding<Bool>,
        coleccion: Coleccion,
        modoVista: EnumModoVista,
        atributo: String
    ) -> some View {
        self.modifier(
            ModificarSize(
                value: value,
                minValue: minValue,
                maxValue: maxValue,
                step: step,
                scrollEnabled: scrollEnabled,
                coleccion: coleccion,
                modoVista: modoVista,
                atributo: atributo
            )
        )
    }
}
