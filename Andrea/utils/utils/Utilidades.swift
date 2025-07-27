
import SwiftUI

struct Utilidades {
    
    //MARK: - ALGORITMOS DE ORDENACION
    /**
     *Ordenamiento de URL*
     */
    
    public func simpleSorting(contentFiles: [URL]) -> [URL] {
        
        let sortedFiles = contentFiles.sorted { url1, url2 in
            url1.lastPathComponent < url2.lastPathComponent
        }
        
        return sortedFiles
        
    }

    
    /**
     *Ordenamiento de Strings*
     */
    
    public func simpleSorting(contentFiles: [String]) -> [String] {
        
        let mc = ManipulacionCadenas()
        
        return contentFiles.sorted { file1, file2 in
            let nums1 = mc.extractNumbers(from: file1)
            let nums2 = mc.extractNumbers(from: file2)

            // Si file1 no tiene números y file2 sí, file1 va después
            if nums1.isEmpty && !nums2.isEmpty {
                return false
            }
            // Si file1 tiene números y file2 no, file1 va antes
            if !nums1.isEmpty && nums2.isEmpty {
                return true
            }
            // Si ambos no tienen números, ordenar alfabéticamente
            if nums1.isEmpty && nums2.isEmpty {
                return file1 < file2
            }

            // Ambos tienen números: comparar número a número
            for (n1, n2) in zip(nums1, nums2) {
                if n1 != n2 {
                    return n1 < n2
                }
            }
            // Si todos los números comparados son iguales, el que tiene menos números va primero
            return nums1.count < nums2.count
        }
    }
    
    
}


struct Benchmark {
    private let label: String
    private let startTime: CFAbsoluteTime

    init(_ label: String) {
        self.label = label
        self.startTime = CFAbsoluteTimeGetCurrent()
//        print("⏱️ [\(label)] Inicio benchmark")
    }

    func end() {
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsed = endTime - startTime
        print("✅ [\(label)] Finalizado en \(String(format: "%.3f", elapsed)) segundos")
        print()
    }
}



// 1) Definimos un Shape que sólo redondea las esquinas que le digamos
struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// 2) Creamos una extensión para poder usarlo como un modificador
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorners(radius: radius, corners: corners) )
    }
}


