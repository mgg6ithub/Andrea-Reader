
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
