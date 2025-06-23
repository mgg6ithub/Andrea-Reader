
import SwiftUI


enum EnumTipoArchivos: String {
    
    //LIBRO ELECTRONICO
    case epub = "epub"
    
    //PDF
    case pdf = "pdf"
    
    // COMICS
    case cbz = "cbz"
    case cbr = "cbr"
    
    //PLAIN TEXT
    case txt = "txt"
    case xml = "xml"
    case md = "md"
    case json = "json"
    
    case unknown = "unknown" // Por si hay un archivo que no corresponde a un tipo definido
    
    // Método para obtener la extensión del archivo asociada
    func fileExtension() -> String {
        return self.rawValue
    }
    
}

enum EnumDescripcionArchivo: String {
    
    //LIBRO ELECTRONICO
    case epub = "Electronic Publishing"
    
    //PDF
    case pdf = "Portable Document Format"
    
    // COMICS
    case cbz = "Comic Book Zip"
    case cbr = "Comic Book Rar"
    
    //PLAIN TEXT
    case txt = "Plain Text File"
    case xml = "Extensible Markup Language"
    case md = "Markdown"
    case json = "JavaScript Object Notation"
    
    case unknown = "Unknown File Type"

    static func descripcion(for tipoArchivo: EnumTipoArchivos) -> String {
        return EnumDescripcionArchivo(rawValue: tipoArchivo.rawValue)?.rawValue ?? "Unknown File Type"
    }
}

//MARK: - TEMPORAL PARA PODER

enum EnumDirectoryTypes: String {
    
    case cbz = "cbz_dir"
    case cbr = "cbr_dir"
    
    case normal = "normal"
    
    // Método para obtener la cadena asociada al tipo
    func directoryName() -> String {
        return self.rawValue
    }
    
}

//MARK: - TEMPORAL PARA PODER

//enum FileDefaultImage: String {
//    
//    case epub = "archivo-epub"
//    case pdf = "archivo-pdf1"
//    case cbz = "archivo-cbz"
//    case cbr = "archivo-cbr"
//    case txt = "archivo-txt"
//    case xml = "archivo-xml"
//    case md = "archivo-md"
//    case json = "archivo-json"
//    case unknown = "corrupted"
//    
//    static func uiImage(for fileExtension: String) -> UIImage {
//        let imageName: String
//
//        switch fileExtension {
//        case "epub":
//            imageName = FileDefaultImage.epub.rawValue
//        case "pdf":
//            imageName = FileDefaultImage.pdf.rawValue
//        case "cbz":
//            imageName = FileDefaultImage.cbz.rawValue
//        case "cbr":
//            imageName = FileDefaultImage.cbr.rawValue
//        case "txt":
//            imageName = FileDefaultImage.txt.rawValue
//        case "xml":
//            imageName = FileDefaultImage.xml.rawValue
//        case "md":
//            imageName = FileDefaultImage.md.rawValue
//        case "json":
//            imageName = FileDefaultImage.json.rawValue
//        default:
//            imageName = FileDefaultImage.unknown.rawValue
//        }
//
//        // Intenta cargar la imagen desde el asset catalog
//        if let image = UIImage(named: imageName) {
//            return image
//        }
//        return UIImage(named: "corrupted")!
//    }
//    
//    static func uiImage(for fileExtension: EnumFileTypes) -> UIImage {
//        let imageName: String
//
//        switch fileExtension {
//        case .epub:
//            imageName = FileDefaultImage.epub.rawValue
//        case .pdf:
//            imageName = FileDefaultImage.pdf.rawValue
//        case .cbz:
//            imageName = FileDefaultImage.cbz.rawValue
//        case .cbr:
//            imageName = FileDefaultImage.cbr.rawValue
//        case .txt:
//            imageName = FileDefaultImage.txt.rawValue
//        case .xml:
//            imageName = FileDefaultImage.xml.rawValue
//        case .md:
//            imageName = FileDefaultImage.md.rawValue
//        case .json:
//            imageName = FileDefaultImage.json.rawValue
//        default:
//            imageName = FileDefaultImage.unknown.rawValue
//        }
//
//        // Intenta cargar la imagen desde el asset catalog
//        if let image = UIImage(named: imageName) {
//            return image
//        }
//        return UIImage(named: "corrupted")!
//    }
//
//    
//    static func image(for fileExtension: EnumFileTypes) -> Image {
//        switch fileExtension {
//        case .epub:
//            return Image(systemName: FileDefaultImage.epub.rawValue)
//        case .pdf:
//            return Image(systemName: FileDefaultImage.pdf.rawValue)
//        case .cbz:
//            return Image(systemName: FileDefaultImage.cbz.rawValue)
//        case .cbr:
//            return Image(systemName: FileDefaultImage.cbr.rawValue)
//        case .txt:
//            return Image(systemName: FileDefaultImage.txt.rawValue)
//        case .xml:
//            return Image(systemName: FileDefaultImage.xml.rawValue)
//        case .md:
//            return Image(systemName: FileDefaultImage.md.rawValue)
//        case .json:
//            return Image(systemName: FileDefaultImage.json.rawValue)
//        default:
//            return Image(systemName: FileDefaultImage.unknown.rawValue)
//        }
//    }
//}
