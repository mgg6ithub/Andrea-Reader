import SwiftUI

final class EstadisticasYProgresoLectura: ObservableObject {
    
    private var url: URL
    
    // --- PROGRESO Y PAGINAS ---
    @Published var totalPaginas: Int? { didSet {  } }
    
    init(url: URL) {
        self.url = url
    }
    
    public func setCurrentPage(currentPage: Int) {
        
    }
    
    public func completarLectura() {}
    
    
    //    private func actualizarProgreso() {
    //        guard let total = totalPaginas, total > 0 else {
    //            progreso = 0
    //            progresoDouble = 0
    //            return
    //        }
    //        if total == 1 {
    //            progreso = 100
    //            progresoDouble = 1.0
    //            return
    //        }
    //        let frac = Double(min(paginaActual, total - 1)) / Double(total - 1)
    //        progresoDouble = frac
    //        progreso = Int(round(frac * 100))
    //    }
}
