
import SwiftUI
import ZIPFoundation


extension Archivo {
    /// Extrae los bytes crudos de la entrada `nombreImagen` dentro del CBZ
    func dataForPage(_ nombreImagen: String) -> Data? {
        do {
            let archive = try Archive(url: self.url, accessMode: .read)
            guard let entry = archive[nombreImagen] else {
                print("❌ Entrada no encontrada en archivo: \(nombreImagen)")
                return nil
            }
            var data = Data()
            _ = try archive.extract(entry) { chunk in
                data.append(chunk)
            }
            return data
        } catch {
            print("Error extrayendo datos de \(nombreImagen):", error)
            return nil
        }
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

