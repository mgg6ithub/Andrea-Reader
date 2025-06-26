
import SwiftUI

struct ImagenArchivoModelo {
    
    // Método que convierte UIImage a Image de SwiftUI, manejando nil
    public func convertToImageOptional(uiImage: UIImage?) -> Image? {
        if let uiImage = uiImage {
            return Image(uiImage: uiImage)
        }
        return nil
    }

    public func convertToImage(uiImage: UIImage) -> Image {
        return Image(uiImage: uiImage)
    }

    
    public func calculateUIImageDimensions(uiImage: UIImage?) -> (width: Int, height: Int) {
        guard let uiImage = uiImage else {
            return (width: 0, height: 0) // Valor por defecto
        }
        return (width: Int(uiImage.size.width), height: Int(uiImage.size.height))
    }
    
    /**
     Metodo para redimensionar una UIImage a Image
     */
    public func convertFromUIImageToImage(imageToConvert: UIImage) -> Image {
        
        let thumbnailSize = ConstantesPorDefecto().dComicSize
        let resizedImage = imageToConvert.resized(to: thumbnailSize)
        // Devuelve la imagen como un Image de SwiftUI
        return Image(uiImage: resizedImage)

    }
    
}

//Extension para poder redimensionar imagenes
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIImage {
    func resizedToSize(targetSize: CGSize) -> UIImage? {
        // Calcular la escala
        let widthRatio = targetSize.width / self.size.width
        let heightRatio = targetSize.height / self.size.height
        let scaleFactor = max(widthRatio, heightRatio)
        
        // Nuevo tamaño basado en la escala
        let newSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
        
        // Redibujar la imagen escalada
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

extension UIImage {
    convenience init?(image: Image) {
        let controller = UIHostingController(rootView: image)
        let view = controller.view
        
        let renderer = UIGraphicsImageRenderer(size: view?.intrinsicContentSize ?? CGSize(width: 1, height: 1))
        
        let uiImage = renderer.image { ctx in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: view?.intrinsicContentSize ?? .zero), afterScreenUpdates: true)
        }
        
        self.init(cgImage: uiImage.cgImage!)
    }
}
