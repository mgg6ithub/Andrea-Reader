
import SwiftUI

struct ImageMod {
    
    //METODOS PARA MANIPULAR IMAGENES
    //pasar a JPEG
    func convertToJPEG(image: UIImage, quality: CGFloat = 0.8) -> UIImage? {
        guard let jpegData = image.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: jpegData)
    }
    
}
