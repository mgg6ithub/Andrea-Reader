
import SwiftUI

extension TimeInterval {
    func formattedTime() -> String {
        let segundos = Int(self)
        let horas = segundos / 3600
        let minutos = (segundos % 3600) / 60
        let segs = segundos % 60
        
        if horas > 0 {
            return "\(horas)h \(minutos)m \(segs)s"
        } else if minutos > 0 {
            return "\(minutos)m \(segs)s"
        } else {
            return "\(segs)s"
        }
    }
}

