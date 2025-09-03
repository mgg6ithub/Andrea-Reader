
import SwiftUI

protocol ProtocoloComic: Archivo, ObservableObject {
    
    var comicPages: [String] { get set }
    
    func cargarPaginas(applyFilters: Bool) -> [String]
    func cargarImagen(nombreImagen: String) -> UIImage?
    func loadImageBackGround(named imageName: String, completion: @escaping (UIImage?) -> Void)
    
    func getImageDimensions() -> [Int: (width: Int, height: Int)]
    
//    func invertirPaginas() -> Void
//    func invertirPaginaActual() -> Void
    
}
