

import SwiftUI

extension Collection where Element: BinaryFloatingPoint {
    func average() -> Double {
        guard !isEmpty else { return 0 }
        let suma = reduce(0, +)
        return Double(suma) / Double(count)
    }
}

extension Collection where Element: BinaryInteger {
    func average() -> Double {
        guard !isEmpty else { return 0 }
        let suma = reduce(0, +)
        return Double(suma) / Double(count)
    }
}


final class EstadisticasColeccion: ObservableObject {
    
    let pd = PersistenciaDatos()
    let cpe = ClavesPersistenciaElementos()
    let p = ValoresElementoPredeterminados()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    @Published var totalElementos: Int = 10
    @Published var totalArchivos: Int = 0
    @Published var totalSubColecciones: Int = 0
    
    @Published var mediaValoraciones: Double = 0.0
    
    public func calcularEstadisticasColeccion(_ elementos: [ElementoSistemaArchivos], totalArchivos: Int, totalSubColecciones: Int) {
        
        print("Calculando estadisticas de la coleccion")
        print()
        
        self.totalArchivos = totalArchivos
        self.totalSubColecciones = totalSubColecciones
        self.totalElementos = self.totalArchivos + self.totalSubColecciones
        
        //VALORACIONES
        let archivos = elementos.compactMap { $0 as? Archivo }
        mediaValoraciones = archivos.compactMap { $0.puntuacion }.average()
        
        print("MEDIA DE VALORACIONES: ", mediaValoraciones)
        
    }
    
}
