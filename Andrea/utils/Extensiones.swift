
import SwiftUI


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
