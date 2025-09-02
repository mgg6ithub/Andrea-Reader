
import SwiftUI

extension TimeInterval {
    /// Devuelve los componentes significativos (d, h, m, s) de un intervalo.
    func components() -> [(valor: Int, unidad: String)] {
        var segundos = Int(self)
        
        let dias = segundos / 86400
        segundos %= 86400
        
        let horas = segundos / 3600
        segundos %= 3600
        
        let minutos = segundos / 60
        segundos %= 60
        
        var parts: [(Int, String)] = []
        
        if dias > 0 { parts.append((dias, "d")) }
        if horas > 0 { parts.append((horas, "h")) }
        if minutos > 0 { parts.append((minutos, "m")) }
        if segundos > 0 || parts.isEmpty { parts.append((segundos, "s")) }
        
        return parts
    }
    
    func formatted() -> String {
        components()
            .map { "\($0.valor)\($0.unidad)" }
            .joined(separator: " ")
    }
    
    func formatTimeMS(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
        
    }
    
}


struct TiempoFormateado: View {
    var tiempo: TimeInterval
    var color: Color = .blue.opacity(0.65)
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(tiempo.components(), id: \.unidad) { part in
                HStack(alignment: .bottom, spacing: 1.5) {
                    Text("\(part.valor)")
                        .font(.system(size: 20))
                        .foregroundColor(color)
                    Text(part.unidad)
                        .font(.system(size: 12.5))
                        .foregroundColor(.primary)
                        .offset(y: -2)
                }
            }
        }
    }
}



