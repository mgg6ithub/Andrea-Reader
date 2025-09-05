

import SwiftUI

// MARK: - Extensiones para BinaryInteger (Int, UInt, etc.)
extension Collection where Element: BinaryInteger {
    func sum() -> Element {
        reduce(0, +)
    }

    func average() -> Double {
        guard !isEmpty else { return 0 }
        return Double(sum()) / Double(count)
    }
}

// MARK: - Extensiones para BinaryFloatingPoint (Double, Float, CGFloat, etc.)
extension Collection where Element: BinaryFloatingPoint {
    func sum() -> Element {
        reduce(0, +)
    }
    
    func average() -> Double {
        guard !isEmpty else { return 0 }
        return Double(sum()) / Double(count)
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
    
    @Published var ALMACENAMIENTOTALPROGRAMA: Int = 0
    
    //archivos totales
    @Published var totalElementos: Int = 10
    @Published var totalArchivos: Int = 0
    @Published var totalSubColecciones: Int = 0
    
    //media valoraciones
    @Published var mediaValoraciones: Double = 0.0
    
    //Peso en bytes
    @Published var isCalculando = false
    
    @Published var pesoTotalArchivos: Int = 0
    @Published var porcentajePesoTotal: Int = 0
    @Published var porcentajePesoTotalDouble: Double = 0.0
    
    @Published var pesoPromedioArchivos: Int = 0
    @Published var archivoMasPesado: String = ""
    @Published var sizeArchivoMasPesado: Int = 0
    @Published var archivoMenosPesado: String = ""
    @Published var sizeArchivoMenosPesado: Int = 0
    
    //lo mismo para la coleccion... repetir variables
   @Published var pesoPromedioColecciones: Int = 0
   @Published var coleccionMasPesada: String = ""
   @Published var sizeColeccionMasPesada: Int = 0
   @Published var coleccionMenosPesada: String = ""
   @Published var sizeColeccionMenosPesada: Int = 0
    
    public func calcularEstadisticasColeccion(_ elementos: [ElementoSistemaArchivos], totalArchivos: Int, totalSubColecciones: Int) {
        
        let sau = SistemaArchivosUtilidades.sau
        
//        print("Calculando estadisticas del PROGRAMA: ", sau.getFileSize(fileURL: sau.home))
//        print("Calculando estadisticas del PROGRAMA: ", ManipulacionSizes().formatearSize(sau.getFileSize(fileURL: sau.home)))
        ALMACENAMIENTOTALPROGRAMA = sau.getFileSize(fileURL: sau.home)
        
        self.totalArchivos = totalArchivos
        self.totalSubColecciones = totalSubColecciones
        self.totalElementos = self.totalArchivos + self.totalSubColecciones
        
        //VALORACIONES
        let archivos = elementos.compactMap { $0 as? Archivo }
        mediaValoraciones = archivos.compactMap { $0.puntuacion }.average()
        
        //peso
        pesoTotalArchivos = archivos.compactMap { $0.fileSize }.sum()
        if ALMACENAMIENTOTALPROGRAMA > 0 {
            print("entra")
           let porcentajeDouble = (Double(pesoTotalArchivos) / Double(ALMACENAMIENTOTALPROGRAMA)) * 100
            print(porcentajeDouble)
           porcentajePesoTotal = Int(porcentajeDouble.rounded()) // si quieres entero redondeado
           porcentajePesoTotalDouble = porcentajeDouble / 100.0  // 0.56 en vez de 56
       } else {
           porcentajePesoTotal = 0
           porcentajePesoTotalDouble = 0
       }
       
        
        //Calcular porcentajs de tipos de archivos
        
    }
    
    public func calcularPesoArchivo(_ elementos: [ElementoSistemaArchivos]) {
        isCalculando = true
        DispatchQueue.global().async {
            let archivos = elementos.compactMap { $0 as? Archivo }
            
            let promedio = Int(archivos.compactMap { $0.fileSize }.average().rounded())
            let maxArchivo = archivos.max(by: { ($0.fileSize ) < ($1.fileSize ) })
            let minArchivo = archivos.min(by: { ($0.fileSize ) < ($1.fileSize ) })
            
            DispatchQueue.main.async {
                self.pesoPromedioArchivos = promedio
                self.archivoMasPesado = maxArchivo?.nombre ?? ""
                self.sizeArchivoMasPesado = maxArchivo?.fileSize ?? 0
                self.archivoMenosPesado = minArchivo?.nombre ?? ""
                self.sizeArchivoMenosPesado = minArchivo?.fileSize ?? 0
                self.isCalculando = false
            }
        }
    }
    
    
    public func calcularPesoSubcolecciones(_ elementos: [ElementoSistemaArchivos]) {
        isCalculando = true
        
        DispatchQueue.global().async {
            // 🔹 Simulación de valores aleatorios
            let nombres = ["Colección A", "Colección B", "Colección C", "Colección D"]
            
            let promedio = Int.random(in: 1_000_000...5_000_000)   // entre ~1MB y 5MB
            let maxNombre = nombres.randomElement() ?? "Desconocido"
            let maxSize = Int.random(in: 5_000_000...20_000_000) // entre ~5MB y 20MB
            let minNombre = nombres.randomElement() ?? "Desconocido"
            let minSize = Int.random(in: 100_000...900_000)      // entre ~100KB y 900KB
            
            Thread.sleep(forTimeInterval: 1.0) // simular cálculo lento
            
            DispatchQueue.main.async {
                self.pesoPromedioColecciones = promedio
                self.coleccionMasPesada = maxNombre
                self.sizeColeccionMasPesada = maxSize
                self.coleccionMenosPesada = minNombre
                self.sizeColeccionMenosPesada = minSize
                self.isCalculando = false
            }
        }
    }
    
    
//    public func calcularPesoColeccion() {
//     
//        let subcolecciones = elementos.compactMap { $0 as? Coleccion }
//        
//    }
    
}
