
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

//MARK: - IMAGENES POR DEFECTO

enum EnumMiniaturasArchivos: String {
    
    case epub = "archivo-epub"
    case pdf = "archivo-pdf"
    case cbz = "archivo-cbz"
    case cbr = "archivo-cbr"
    case txt = "archivo-txt"
    case xml = "archivo-xml"
    case md = "archivo-md"
    case json = "archivo-json"
    case unknown = "corrupted"
    
    static func uiImage(for fileExtension: String) -> UIImage {
        let imageName: String

        switch fileExtension {
        case "epub":
            imageName = EnumMiniaturasArchivos.epub.rawValue
        case "pdf":
            imageName = EnumMiniaturasArchivos.pdf.rawValue
        case "cbz":
            imageName = EnumMiniaturasArchivos.cbz.rawValue
        case "cbr":
            imageName = EnumMiniaturasArchivos.cbr.rawValue
        case "txt":
            imageName = EnumMiniaturasArchivos.txt.rawValue
        case "xml":
            imageName = EnumMiniaturasArchivos.xml.rawValue
        case "md":
            imageName = EnumMiniaturasArchivos.md.rawValue
        case "json":
            imageName = EnumMiniaturasArchivos.json.rawValue
        default:
            imageName = EnumMiniaturasArchivos.unknown.rawValue
        }
        print("Se ejecuta este metodo")
        // Intenta cargar la imagen desde el asset catalog
        if let image = UIImage(named: imageName) {
            return image
        }
        return UIImage(named: "corrupted")!
    }
    
    static func uiImage(for fileExtension: EnumTipoArchivos) -> UIImage {
        let imageName: String

        switch fileExtension {
        case .epub:
            imageName = EnumMiniaturasArchivos.epub.rawValue
        case .pdf:
            imageName = EnumMiniaturasArchivos.pdf.rawValue
        case .cbz:
            imageName = EnumMiniaturasArchivos.cbz.rawValue
        case .cbr:
            imageName = EnumMiniaturasArchivos.cbr.rawValue
        case .txt:
            imageName = EnumMiniaturasArchivos.txt.rawValue
        case .xml:
            imageName = EnumMiniaturasArchivos.xml.rawValue
        case .md:
            imageName = EnumMiniaturasArchivos.md.rawValue
        case .json:
            imageName = EnumMiniaturasArchivos.json.rawValue
        default:
            imageName = EnumMiniaturasArchivos.unknown.rawValue
        }

        // Intenta cargar la imagen desde el asset catalog
        if let image = UIImage(named: imageName) {
            return image
        }
        return UIImage(named: "corrupted")!
    }

    
    static func image(for fileExtension: EnumTipoArchivos) -> Image {
        switch fileExtension {
        case .epub:
            return Image(EnumMiniaturasArchivos.epub.rawValue)
        case .pdf:
            return Image(EnumMiniaturasArchivos.pdf.rawValue)
        case .cbz:
            return Image(EnumMiniaturasArchivos.cbz.rawValue)
        case .cbr:
            return Image(EnumMiniaturasArchivos.cbr.rawValue)
        case .txt:
            return Image(EnumMiniaturasArchivos.txt.rawValue)
        case .xml:
            return Image(EnumMiniaturasArchivos.xml.rawValue)
        case .md:
            return Image(EnumMiniaturasArchivos.md.rawValue)
        case .json:
            return Image(EnumMiniaturasArchivos.json.rawValue)
        default:
            return Image(EnumMiniaturasArchivos.unknown.rawValue)
        }
    }
}

//ENUM TIPO DE MINIATURA
enum EnumTipoMiniatura: String, CaseIterable {
    
    case imagenBase
    case primeraPagina
    case aleatoria
    case personaliza
    
}

enum EnumTipoMiniaturaColeccion: String {
    
    case carpeta
    case abanico
    
}

enum EnumDireccionAbanico: String {
    
    case izquierda
    case derecha
    
}
