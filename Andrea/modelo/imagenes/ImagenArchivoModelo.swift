
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
    
    
    func crearMiniaturaPorDefecto(miniatura: UIImage, color: UIColor? = nil) -> (uiImage: UIImage, imageData: Data?, imageDimensions: (width: Int, height: Int))? {
            let thumbnailSize: CGSize = CGSize(width: 190, height: 260)
            
    //        if let archivoPDFImage = UIImage(named: miniatura) {
                
    //                let azulSuave = UIColor(red: 0.5, green: 0.7, blue: 1.0, alpha: 1.0)
                    let verdeSuave = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0) // Verde suave
    //            let rojoSuave = UIColor(red: 0.9, green: 0.5, blue: 0.5, alpha: 1.0) // Rojo suave


                let negroGrisAzul = UIColor(red: 51/255.0, green: 62/255.0, blue: 72/255.0, alpha: 1.0)
                let blanco = UIColor(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1.0)
            
            var ternariColor: UIColor = color ?? UIColor(Color.blue)
                
            let symbolColorConfig = UIImage.SymbolConfiguration(paletteColors: [negroGrisAzul, blanco, ternariColor])  // Ajusta los colores según sea necesario
                let coloredImage = miniatura.applyingSymbolConfiguration(symbolColorConfig)
                
                let size = CGSize(width: 247, height: 304)
                
                // Ajusta la posición de la imagen moviéndola hacia arriba (cambia el valor del origen 'y')
                let offsetY: CGFloat = -20  // Ajusta este valor para mover la imagen hacia arriba o abajo
                let offsetX: CGFloat = -28  // Ajusta este valor para mover la imagen hacia arriba o abajo
                
                // Redibujar la imagen manteniendo sus proporciones pero desplazada hacia arriba
                UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, 0.0)
                coloredImage?.draw(in: CGRect(origin: CGPoint(x: offsetX, y: offsetY), size: size))  // Aplica el desplazamiento en Y
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                // Obtener los datos de la imagen redimensionada
                let imageData = resizedImage?.jpegData(compressionQuality: 1.0)
                let imageDimensions = (width: Int(resizedImage?.size.width ?? 0), height: Int(resizedImage?.size.height ?? 0))
                
                return (resizedImage ?? miniatura, imageData, imageDimensions)
    //        } else {
    //            print("No se pudo cargar la imagen de archivo-pdf desde los assets")
    //        }
    //        return nil
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
