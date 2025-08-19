
import SwiftUI

// MARK: - Animaciones personalizadas
extension View {
    
    /// Animación suave (ideal para cambios de color o tamaño discretos)
    func animacionSave<T: Equatable>(_ value: T) -> some View {
        self.animation(.easeInOut(duration: 0.25), value: value)
    }
    
    /// Animación con rebote (más llamativa, estilo resorte)
    func animacionRebote<T: Equatable>(_ value: T) -> some View {
        self.animation(.spring(response: 0.25, dampingFraction: 0.7), value: value)
    }
    
    /// Animación de desvanecimiento (combina opacidad con el cambio)
    func animacionDesvanecer<T: Equatable>(_ value: T) -> some View {
        self.transition(.opacity) // si hay aparición/desaparición
            .animation(.easeInOut(duration: 0.25), value: value)
    }
}

//MARK: --- ANIMACIONES DE TEXTO ---
//porcentaje
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
