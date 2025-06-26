//
//  ImagenArchivo.swift
//  Andrea
//
//  Created by mgg on 26/6/25.
//

import SwiftUI

class ImagenArchivo: ObservableObject  {
    
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
    
    var defaultImage: UIImage = ConstantesPorDefecto().dNotFoundUIImage
    
    @Published var tipoMiniatura: EnumTipoMiniatura
    
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
        
        self.image = ImagenArchivoModelo().convertToImage(uiImage: uiImage)
        self.backImage = ImagenArchivoModelo().convertToImage(uiImage: backuiImage)
        self.tipoMiniatura = EnumTipoMiniatura.firstPage
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
        
        self.image = ImagenArchivoModelo().convertToImage(uiImage: uiImage)
        self.backImage = ImagenArchivoModelo().convertToImage(uiImage: backuiImage)
        self.tipoMiniatura = EnumTipoMiniatura.firstPage
    }
    
    //CONSTRUCTOR SOLAMENTE CON MINIATURA DE DELANTE
    init(id: UUID, imageName: String, uiImage: UIImage, absoluteImageURL: URL, relativeImageURL: String, imageSize: Int, imageDimensions: (width: Int, height: Int)) {
        self.id = id
        self.imageName = imageName
        self.backImageName = "dafault"
        self.uiImage = uiImage
        self.backuiImage = defaultImage
        self.image = ImagenArchivoModelo().convertToImage(uiImage: uiImage)
        self.backImage = ImagenArchivoModelo().convertToImage(uiImage: defaultImage)
        
        self.absoluteImageURL = absoluteImageURL
        self.relativeImageURL = relativeImageURL
        self.absoluteBackImageURL = URL(fileURLWithPath: "")
        self.relativeBackImageURL = ""
        
        self.imageSize = imageSize
        self.backImageSize = 0
        self.imageDimensions = imageDimensions
        self.backImageDimensions = (width: 0, height: 0)
        self.tipoMiniatura = EnumTipoMiniatura.firstPage
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
        
       self.image = ImagenArchivoModelo().convertToImage(uiImage: uiImage)
       self.backImage = ImagenArchivoModelo().convertToImage(uiImage: backuiImage)
       self.tipoMiniatura = EnumTipoMiniatura.firstPage
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
         
        self.image = ImagenArchivoModelo().convertToImage(uiImage: uiImage)
        self.backImage = ImagenArchivoModelo().convertToImage(uiImage: backuiImage)
        self.defaultImage = defaultImage
        self.tipoMiniatura = EnumTipoMiniatura.firstPage
    }
    
    func updateImageColor(newColor: Color, archivo: Archivo) -> Bool {
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
//        guard let newThumbnail = archivo.createDefaultThumbnail(defaultFileThumbnail: EnumMiniaturasArchivos.uiImage(for: archivo.fileType), color: newUIColor) else {
//            return false
//        }
//        
//        self.uiImage = newThumbnail.uiImage
//        self.image = ImagenArchivoModelo().convertToImage(uiImage: self.uiImage)
        return true
    }
    
}
