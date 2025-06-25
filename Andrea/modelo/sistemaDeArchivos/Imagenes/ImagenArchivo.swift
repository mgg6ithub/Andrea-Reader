
import SwiftUI

enum fileImageTypeEnum {
    
    case defaultFile
    case firstPage
    case randomPage
    case customImage
    
    func toString() -> String {
        switch self {
        case .defaultFile:
            return "defaultFile"
        case .firstPage:
            return "firstPage"
        case .randomPage:
            return "randomPage"
        case .customImage:
            return "customImage"
        }
    }
    
    static func fromString(_ string: String) -> fileImageTypeEnum? {
        switch string {
        case "defaultFile":
            return .defaultFile
        case "firstPage":
            return .firstPage
        case "randomPage":
            return .randomPage
        case "customImage":
            return .customImage
        default:
            return nil // Manejo de error si el string no coincide con ningún caso
        }
    }
}


class FileImageModel: ObservableObject  {
    
    var id: UUID
    var imageName: String
    var backImageName: String

    var uiImage: UIImage
    var backuiImage: UIImage
    
    var absoluteImageURL: URL
    var relativeImageURL: String
    var absoluteBackImageURL: URL
    var relativeBackImageURL: String
    
    var imageSize: Int
    var backImageSize: Int
    
    var imageDimensions: (width: Int, height: Int)
    var backImageDimensions: (width: Int, height: Int)
    
    var image: Image
    var backImage: Image
    
    var defaultImage: UIImage = DefaultConstants().dNotFoundUIImage
    
    @Published var fileImageType: fileImageTypeEnum
    
    // Constructor por defecto
    init() {
        self.id = UUID()
        self.imageName = "default"
        self.backImageName = "default"
        self.uiImage = UIImage(systemName: "photo")!  // Imagen por defecto, usa un ícono del sistema
        self.backuiImage = UIImage(systemName: "photo")!
        self.absoluteImageURL = URL(fileURLWithPath: "")
        self.relativeImageURL = ""
        self.absoluteBackImageURL = URL(fileURLWithPath: "")
        self.relativeBackImageURL = ""
        self.imageSize = 0
        self.backImageSize = 0
        self.imageDimensions = (width: 0, height: 0)
        self.backImageDimensions = (width: 0, height: 0)
        
        self.image = ImageStructure().convertToImage(uiImage: uiImage)
        self.backImage = ImageStructure().convertToImage(uiImage: backuiImage)
        self.fileImageType = fileImageTypeEnum.firstPage
    }
    
    //CONSTRUCTOR PASANDO LA FOTO POR DEFECTO
    init(tempImage: UIImage, tempBackImage: UIImage) {
        self.id = UUID()
        self.imageName = "default"
        self.backImageName = "default"
        self.uiImage = tempImage  // Imagen por defecto, usa un ícono del sistema
        self.backuiImage = tempBackImage
        self.absoluteImageURL = URL(fileURLWithPath: "")
        self.relativeImageURL = ""
        self.absoluteBackImageURL = URL(fileURLWithPath: "")
        self.relativeBackImageURL = ""
        self.imageSize = 0
        self.backImageSize = 0
        self.imageDimensions = (width: 0, height: 0)
        self.backImageDimensions = (width: 0, height: 0)
        
        self.image = ImageStructure().convertToImage(uiImage: uiImage)
        self.backImage = ImageStructure().convertToImage(uiImage: backuiImage)
        self.fileImageType = fileImageTypeEnum.firstPage
    }
   
   // Constructor para File (con backImage) - SE QUITAN LOS VALORES POR DEFECTO
    init(id: UUID, imageName: String, backImageName: String, uiImage: UIImage, backuiImage: UIImage, absoluteImageURL: URL, relativeImageURL: String, absoluteBackImageURL: URL, relativeBackImageURL: String, imageSize: Int, backImageSize: Int, imageDimensions: (width: Int, height: Int), backImageDimensions: (width: Int, height: Int)) {
       self.id = id
       self.imageName = imageName
       self.backImageName = backImageName
       self.uiImage = uiImage
       self.backuiImage = backuiImage  // Asignamos backImage aquí (puede ser nil)
       self.absoluteImageURL = absoluteImageURL
       self.relativeImageURL = relativeImageURL
       self.absoluteBackImageURL = absoluteBackImageURL
       self.relativeBackImageURL = relativeBackImageURL
       self.imageSize = imageSize
       self.backImageSize = backImageSize
       self.imageDimensions = imageDimensions
       self.backImageDimensions = backImageDimensions
        
       self.image = ImageStructure().convertToImage(uiImage: uiImage)
       self.backImage = ImageStructure().convertToImage(uiImage: backuiImage)
       self.fileImageType = fileImageTypeEnum.firstPage
   }
    
    // Constructor para File (con backImage) - SE QUITAN LOS VALORES POR DEFECTO
    init(id: UUID, imageName: String, backImageName: String, uiImage: UIImage, backuiImage: UIImage, absoluteImageURL: URL, relativeImageURL: String, absoluteBackImageURL: URL, relativeBackImageURL: String, imageSize: Int, backImageSize: Int, imageDimensions: (width: Int, height: Int), backImageDimensions: (width: Int, height: Int), defaultImage: UIImage) {
        self.id = id
        self.imageName = imageName
        self.backImageName = backImageName
        self.uiImage = uiImage
        self.backuiImage = backuiImage  // Asignamos backImage aquí (puede ser nil)
        self.absoluteImageURL = absoluteImageURL
        self.relativeImageURL = relativeImageURL
        self.absoluteBackImageURL = absoluteBackImageURL
        self.relativeBackImageURL = relativeBackImageURL
        self.imageSize = imageSize
        self.backImageSize = backImageSize
        self.imageDimensions = imageDimensions
        self.backImageDimensions = backImageDimensions
         
        self.image = ImageStructure().convertToImage(uiImage: uiImage)
        self.backImage = ImageStructure().convertToImage(uiImage: backuiImage)
        self.defaultImage = defaultImage
        self.fileImageType = fileImageTypeEnum.firstPage
    }
    
    func updateImageColor(newColor: Color, file: File) -> Bool {
        // Convertir Color a UIColor
        let newUIColor: UIColor
        switch newColor {
        case .blue:
            newUIColor = UIColor(red: 0.5, green: 0.7, blue: 1.0, alpha: 1.0)  // Azul Suave
        case .green:
            newUIColor = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)  // Verde Suave
        case .red:
            newUIColor = UIColor(red: 0.9, green: 0.5, blue: 0.5, alpha: 1.0)  // Rojo Suave
        case .yellow:
            newUIColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)  // Amarillo
        case .orange:
            newUIColor = UIColor(red: 1.0, green: 0.647, blue: 0.0, alpha: 1.0)  // Naranja
        case .purple:
            newUIColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)  // Morado
        case .pink:
            newUIColor = UIColor(red: 1.0, green: 0.5, blue: 0.7, alpha: 1.0)  // Rojo Rosado
        default:
            return false  // Si el color no está en la lista, retorna false
        }
        
//        print("COLOR ACTUAIZADO")
//        print(file.dirColor)
        
        // Regenerar la imagen con la nueva configuración
        guard let newThumbnail = file.createDefaultThumbnail(defaultFileThumbnail: FileDefaultImage.uiImage(for: file.fileType), color: newUIColor) else {
            return false
        }
        
        self.uiImage = newThumbnail.uiImage
        self.image = ImageStructure().convertToImage(uiImage: self.uiImage)
        return true
    }
    
}
