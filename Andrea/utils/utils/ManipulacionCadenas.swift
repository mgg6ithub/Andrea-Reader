/*-----------------------------------------------------------------------------------------------------*/
/** MANIPULACION DE CADENAS **/
/*-----------------------------------------------------------------------------------------------------*/

import SwiftUI


struct ManipulacionCadenas {
    
    private let sau: SistemaArchivosUtilidades = SistemaArchivosUtilidades.sau
    
    /**
     Metodo para calcular la altura del texto usado
     */
    
    func updateTextHeight(name: String) -> CGFloat {
        let uiFont = UIFont.systemFont(ofSize: 22.5)
        let width = UIScreen.main.bounds.width * 0.9
        let boundingSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: uiFont]
        let rect = name.boundingRect(with: boundingSize,
                                            options: .usesLineFragmentOrigin,
                                            attributes: attributes,
                                            context: nil)
        return max(40, rect.height + 20) // Ajuste de margen
    }
    
    /**
     Metodo para unir un path con una extension. Ambos tienen que ser string y  path + .extension
     */
    
    public func joinNameWithExtension(name: String, ext: String) -> String{
        return name + "." + ext
    }
    
    public func eliminarExtension(name: String) -> String {
        
        if let lastDotIndex = name.lastIndex(of: ".") {
            return String(name[..<lastDotIndex]) // Devuelve la parte antes del punto
        }
        return name // Si no hay punto, devuelve el nombre tal cual
        
    }
    
    /**
     *Este metodo se encarga de crear un numero nombre duplicado
     *HAY OTRO ELEMENTO CON EL MISMO NOMBRE
     *Si se introduce: batman Y ya hay uno se renombra con un numero al final -> batman (1)*
     */
    
    public func handleDuplicateElement(elementURL: URL, directoryURL: URL) -> String {
        
        let elementExtension = elementURL.pathExtension
        var newName = ManipulacionCadenas().eliminarExtension(name: elementURL.lastPathComponent)
        
        if self.extractNumberFromString(newName) != nil {
            newName = self.deleteDuplicateNumberFromString(newName)
        }
        
        var highestDuplicate = getHighestDuplicate(newName, sau.getListSubdirectoryContentsWithNoExtensions(urlPath: directoryURL))
        highestDuplicate += 1
        
        return ManipulacionCadenas().joinNameWithExtension(name: newName + " (" + String(highestDuplicate) + ")", ext: elementExtension)
    }
    
    /**
     *Este metodo obtiene el numero mas alto de todos los lementos duplicados*
     */
    
    private func getHighestDuplicate(_ elementName: String,_ listOfElements: [String]) -> Int {
        
        var highestNumber = 0
        
        // Filtramos los archivos que tienen el mismo nombre base y un número al final
        for file in listOfElements {

            // Verificamos si el archivo tiene el mismo nombre base y termina en un número
            if file.hasPrefix(elementName), let number = extractNumberFromString(file) {
                highestNumber = max(highestNumber, number)  // Guardamos el número más alto encontrado
            }
        }
        
        return highestNumber
    }

    /**
     *Este metodo extrae el numero de un archivo duplicado
     *Si se le pasa un string "batman (1)" el metodo devolvera 1*
     */

    private func extractNumberFromString(_ input: String) -> Int? {
        // Definir la expresión regular para buscar un número entre paréntesis con un espacio antes
        let regexPattern = "\\s+\\((\\d+)\\)$"
        
        do {
            // Crear la expresión regular
            let regex = try NSRegularExpression(pattern: regexPattern)
            
            // Buscar una coincidencia en la cadena de entrada
            if let match = regex.firstMatch(in: input, range: NSRange(input.startIndex..., in: input)) {
                // Extraer el número capturado en el grupo de paréntesis
                if let range = Range(match.range(at: 1), in: input) {
                    let numberString = String(input[range])
                    return Int(numberString) // Convertir la subcadena a un número (Int?)
                }
            }
        } catch {
            print("Error al crear la expresión regular: \(error)")
        }
        
        // Si no se encuentra un número, retornar nil
        return nil
    }

    /**
     *Este metodo sirve para elimar el numero indice de un duplicado
     *Si se le pasa "batman (1)" este metodo devolverá "batman"*
     */
    private func deleteDuplicateNumberFromString(_ input: String) -> String {
        // Definir la expresión regular para buscar un número entre paréntesis con un espacio antes
        let regexPattern = "\\s+\\(\\d+\\)$"
        
        do {
            // Crear la expresión regular
            let regex = try NSRegularExpression(pattern: regexPattern)
            
            // Reemplazar las coincidencias con una cadena vacía
            let result = regex.stringByReplacingMatches(in: input, range: NSRange(input.startIndex..., in: input), withTemplate: "")
            
            return result
        } catch {
            print("Error al crear la expresión regular: \(error)")
            return input // Si hay un error, devuelve la cadena original
        }
    }
    
    
    /**
     Metodo para normalizar una URL eliminando de su path la palabra "private"
     */
    
    func normalizarURL(_ url: URL) -> URL {
        
        if url.path.hasPrefix("/private") {
            // Eliminar el prefijo "/private" de la ruta
            let newPath = url.path.replacingOccurrences(of: "/private", with: "")
            return URL(fileURLWithPath: newPath)
        }
        return url
        
    }
    
    /**
        Metodo apra agregar private al path
     */
    
    func agregarPrivate(_ url: URL) -> URL {
        if !url.path.hasPrefix("/private") {
            return URL(fileURLWithPath: "/private" + url.path)
        }
        return url
    }
    
    func relativizeURL(elementURL: URL) -> String {
        if let range = elementURL.path.range(of: "/Documents") {
            return String(elementURL.path[range.lowerBound...])
        }
        return ""
    }
    
    func relativizeURLNOextension(elementURL: URL) -> String {
        
        let noExtElementURL: URL = elementURL.deletingPathExtension()
        
        if let range = noExtElementURL.path.range(of: "/Documents") {
            return String(noExtElementURL.path[range.lowerBound...])
        }
        return ""
    }
    
    func absolutivizeURL(elementSTRING: String) -> URL {
        let rootPath = ManipulacionCadenas().agregarPrivate(sau.getRootDirectoryPath())
        return URL(fileURLWithPath: rootPath.deletingLastPathComponent().path).appendingPathComponent(elementSTRING)
    }

    
    /**
     Metodo para quitar la parte de la URL local del sistem de la URL
     */
    public func borrarURLLOCAL(url: URL) -> String {
        
        let homeURL = sau.home.deletingLastPathComponent().path
        return self.normalizarURL(url).path.replacingOccurrences(of: homeURL, with: "").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
    }
    
    
    func getFirstChars(pdfName: String, max: Int) -> String {
        
        return String("\(pdfName.prefix(max))")
    }
    
    /// Extrae si el archivo tiene una etiqueta de formato (ej: "digital")
    func extraerFormatoEscaneo(from text: String) -> String? {
        let pattern = #"\((digital|Digital|scan|HD|4K|remastered|Webrip)\)"#  // Ajustable para más formatos
        return extractFirstMatch(from: text, pattern: pattern)
    }
    
    /// Extrae la entidad (último elemento entre paréntesis)
    func extraerEntidad(from text: String) -> String? {
        let pattern = #"\(([^()]+)\)(?:\.[^.]+)?$"#  // Último paréntesis con contenido
        return extractFirstMatch(from: text, pattern: pattern)
    }
    
    func extraerNumeroDeLaColeccion(from text: String) -> Int? {
        // Expresión regular para capturar un número al final del nombre antes de los paréntesis (con ceros a la izquierda permitidos) o solo el número al final
        let pattern = #"\s*(\d{1,3})(?=\s?\(|\s*$)"#  // Captura un número seguido de un paréntesis o el final de la cadena

        // Intentar hacer el match con la expresión regular
        if let range = text.range(of: pattern, options: .regularExpression) {
            // Extraer el número de la cadena
            let issueNumberString = String(text[range])
            
            // Convertir el número a Int y devolverlo
            if let issueNumber = Int(issueNumberString.trimmingCharacters(in: .whitespaces)) {
                return issueNumber
            }
        }
        
        return nil  // Si no se encuentra el número, devuelve nil
    }
    
    func filterImagesWithIndex(files: [String]) -> [String] {
        
        guard let baseName = detectBaseName(files: files) else { return [] }
        
        // Escapar caracteres especiales en el baseName para usar en regex
        let escapedBaseName = NSRegularExpression.escapedPattern(for: baseName)
        
        let pattern = #"^\#(escapedBaseName)[ _-]?\d+\.(jpg|png|jpeg)$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        return files.filter { file in
            let range = NSRange(location: 0, length: file.utf16.count)
            return regex.firstMatch(in: file, options: [], range: range) != nil
        }
    }
    
    func detectBaseName(files: [String]) -> String? {
        let pattern = #"^(.*?)[ _-]?\d+\.(jpg|png|jpeg)$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        var nameCounts: [String: Int] = [:]

        for file in files {
            let range = NSRange(location: 0, length: file.utf16.count)
            if let match = regex.firstMatch(in: file, options: [], range: range),
               let nameRange = Range(match.range(at: 1), in: file) {
                let baseName = file[nameRange].trimmingCharacters(in: .whitespaces)
                nameCounts[baseName, default: 0] += 1
            }
        }

        return nameCounts.max { $0.value < $1.value }?.key
    }

    
    /// Extrae el número de issues del patrón "(of X)" en el texto.
    func extractNumberOfIssues(from text: String) -> Int? {
        // Expresión regular para buscar el patrón "(of X)" donde X es un número
        let pattern = #"\(of (\d+)\)"#
        
        // Intentar hacer el match con la expresión regular
        if let match = extractFirstMatch(from: text, pattern: pattern) {
            // Extraer el número de la coincidencia
            if let issueNumber = Int(match) {
                return issueNumber
            }
        }
        
        return nil  // Devuelve nil si no se encuentra el número
    }
    
    /// Método genérico para extraer la primera coincidencia de un patrón regex
    func extractFirstMatch(from text: String, pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(text.startIndex..., in: text)
        
        if let match = regex?.firstMatch(in: text, options: [], range: range),
           let range = Range(match.range(at: 1), in: text) {
            return String(text[range])
        }
        
        return nil
    }
    
    public func extractNumbers(from string: String) -> [Int] {
        let pattern = "\\d+"
        var numbers: [Int] = []

        if let regex = try? NSRegularExpression(pattern: pattern) {
            let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
            for match in results {
                if let range = Range(match.range, in: string) {
                    let numStr = String(string[range])
                    if let number = Int(numStr) {
                        numbers.append(number)
                    }
                }
            }
        }

        return numbers
    }
    
    //MARK: --- EXTRACCION DE NOMBRES ---
    
    func renameExpresion(originalName: String) -> String? {
            // Primera expresión regular (caso nombre numero (año) (bla)...)
            let firstPattern = #"^(.*?)(\d+)\s*\(\d{4}\)(.*)"#
            
            // Segunda expresión regular (caso nombre numero (of n) (año) (extra))
            let secondPattern = #"^(.*?)(\d+)\s*\(.*\)\s*\(\d{4}\).*"#
            
            // Tercera expresión regular (caso solo nombre sin número)
            let thirdPattern = #"^(.*?)(\s*\(\d{4}\).*)?$"#
            
            // Intenta la primera expresión regular
            if let renamedFirst = tryMatch(pattern: firstPattern, originalName: originalName) {
                return renamedFirst
            }
            
            // Si no coincide con la primera expresión regular, intenta la segunda
            if let renamedSecond = tryMatch(pattern: secondPattern, originalName: originalName) {
                return renamedSecond
            }
            
            // Si no coincide con ninguna de las anteriores, intenta la tercera expresión regular
            if let renamedThird = tryMatch(pattern: thirdPattern, originalName: originalName) {
                return renamedThird
            }
            
            // Si no coincide con ninguno de los patrones, retorna nil o el nombre original
            return originalName
        }

        // Función auxiliar para aplicar la expresión regular y hacer la conversión
        func tryMatch(pattern: String, originalName: String) -> String? {
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            if let match = regex?.firstMatch(in: originalName, options: [], range: NSRange(location: 0, length: originalName.utf16.count)) {
                
                if let nameRange = Range(match.range(at: 1), in: originalName) {
                    let name = originalName[nameRange].trimmingCharacters(in: .whitespaces)
                    
                    // Si tiene un número en el nombre, intentamos extraerlo y eliminar ceros a la izquierda
                    if let numberRange = Range(match.range(at: 2), in: originalName),
                       let number = Int(originalName[numberRange]) {
                        return "\(name) \(number)"
                    } else {
                        // Si no tiene número, simplemente devolvemos el nombre
                        return name
                    }
                }
            }
            
            return nil
        }
    
}
