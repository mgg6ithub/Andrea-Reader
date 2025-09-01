

import SwiftUI

struct ImagenInfo {
    
    let url: URL?
    let ancho: Int
    let alto: Int
    let pesoKB: Int
    let formato: String
    let escala: CGFloat
    let calidad: String
    let ratio: String
    let fechaModificacion: Date?
    
    init?(imagen: UIImage?, url: URL? = nil) {
        guard let imagen = imagen else { return nil }
        
        let ancho = Int(imagen.size.width * imagen.scale)
        let alto = Int(imagen.size.height * imagen.scale)
        
        // Peso y formato
        var data: Data?
        var formato = "Desconocido"
        
        if let url = url {
            data = try? Data(contentsOf: url)
            formato = url.pathExtension.uppercased()
        } else {
            data = imagen.pngData()
            formato = "PNG"
        }
        
        let pesoKB = (data?.count ?? 0) / 1024
        
        // Calidad estimada
        let calidad: String
        if ancho >= 2000 || alto >= 2000 {
            calidad = "Muy alta"
        } else if ancho >= 1000 || alto >= 1000 {
            calidad = "Alta"
        } else if ancho >= 500 || alto >= 500 {
            calidad = "Media"
        } else {
            calidad = "Baja"
        }
        
        // Ratio
        let gcd = Self.gcd(ancho, alto)
        let ratio = "\(ancho / gcd):\(alto / gcd)"
        
        // Fecha de creación del archivo
        var fecha: Date? = nil
        if let url = url {
            let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
            fecha = attrs?[.creationDate] as? Date
        }
        
        self.url = url
        self.ancho = ancho
        self.alto = alto
        self.pesoKB = pesoKB
        self.formato = formato
        self.escala = imagen.scale
        self.calidad = calidad
        self.ratio = ratio
        self.fechaModificacion = fecha
    }
    
    static func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        while b != 0 {
            let t = b
            b = a % b
            a = t
        }
        return a
    }
}
