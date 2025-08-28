//
//  Enums.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

import SwiftUI

// MARK: - Tipo de dispositivo según resolución lógica
enum EnumDispositivoActual: String, CaseIterable {
    case iphoneGen3
    case iphone15
    case ipadMini
    case ipad
    case ipadGen10
    case ipad12
    
    /// Ícono asociado en SF Symbols
    var iconoDispositivo: String {
        switch self {
        case .iphoneGen3, .iphone15:
            return "iphone"       // 📱
        case .ipadMini, .ipad, .ipadGen10, .ipad12:
            return "ipad"         // 📝
        }
    }
    
    /// Nombre legible (opcional para mostrar en UI)
    var nombreDispositivo: String {
        switch self {
        case .iphoneGen3: return "iPhone (1ª Gen)"
        case .iphone15:  return "iPhone"
        case .ipadMini:   return "iPad mini"
        case .ipad:       return "iPad"
        case .ipadGen10:  return "iPad 10th Gen"
        case .ipad12:     return "iPad Pro 12\""
        }
    }
}

extension EnumDispositivoActual {
    var esIPad: Bool {
        switch self {
        case .ipadMini, .ipad, .ipadGen10, .ipad12:
            return true
        default:
            return false
        }
    }
}



//MARK: - FILTROS DE ARCHIVOS NO DESEADOS
enum EnumFiltroArchivos {
    case excludeTrash
    case excludeHiddenFiles
    case none  // Puedes agregar más filtros en el futuro
    
    // Método que evalúa si un archivo o directorio debe ser excluido según los filtros aplicados
    func shouldInclude(url: URL) -> Bool {
        switch self {
        
        case .excludeTrash:
            return url.lastPathComponent != ".Trash"
        
        case .excludeHiddenFiles:
            return !url.lastPathComponent.hasPrefix(".")  // Filtra archivos ocultos
        
        case .none:
            return true
        }
    }
}


//MARK: - TIPOS DE SISTEMA DE ARCHIVOS
enum EnumTipoSistemaArchivos: String, CaseIterable {
    case tradicional
    case arbol
}


//MARK: --- MODOS DE VISTA PARA LA LIBRERIA ---
enum EnumModoVista: String, Codable {
    case cuadricula
    case lista
    case cartas
    case pasarela
}

//MARK: --- MODOS DE ORDENACION ---
enum EnumOrdenaciones: String, Codable {
    case aleatorio
    case personalizado
    case nombre
    case porcentaje
    case tamano
    case paginas
    case progreso
    case fechaImportacion
    case fechaModificacion
}


//MARK: - RESOLUCIONES LOGICAS
enum EnumResolucionesLogicas {
    case small
    case medium
    case big
}


extension Color {
    static let fixedSystemGray6_light: Color = {
        let traits = UITraitCollection(userInterfaceStyle: .light)
        let color = UIColor.systemGray6.resolvedColor(with: traits)
        return Color(color)
    }()

    static let fixedSystemGray5_dark: Color = {
        let traits = UITraitCollection(userInterfaceStyle: .dark)
        let color = UIColor.systemGray5.resolvedColor(with: traits)
        return Color(color)
    }()

    static let fixedSecondaryGray_light = Color(red: 242/255, green: 242/255, blue: 247/255) // Aproximado a systemGray6 (modo claro)
    static let fixedSecondaryGray_dark = Color(red: 28/255, green: 28/255, blue: 30/255)     // Aproximado a systemGray6 (modo oscuro)
    
    func darken(by percentage: Double) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0

        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return Color(hue: hue,
                     saturation: saturation,
                     brightness: max(brightness - CGFloat(percentage), 0),
                     opacity: Double(alpha))
    }
    
    static let fixedBlack = Color(red: 0/255, green: 0/255, blue: 0/255)
    static let fixedWhite = Color(red: 255/255, green: 255/255, blue: 255/255)
    
    func shade(by percentage: Double) -> Color {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return Color(
            red: Double(max(min(r * (1 - percentage), 1), 0)),
            green: Double(max(min(g * (1 - percentage), 1), 0)),
            blue: Double(max(min(b * (1 - percentage), 1), 0)),
            opacity: Double(a)
        )
    }
    

    func tones() -> (light: Color, base: Color, dark: Color) {
        let uiColor = UIColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        // Jugamos con brillo para variar
        let light = Color(hue: h, saturation: s * 0.8, brightness: min(b * 1.2, 1), opacity: Double(a))
        let base  = Color(hue: h, saturation: s, brightness: b, opacity: Double(a))
        let dark  = Color(hue: h, saturation: s * 1.1, brightness: max(b * 0.7, 0), opacity: Double(a))
        
        return (light, base, dark)
    }


    
}

// MARK: - FUENTES
enum EnumFuenteIcono: String, CaseIterable, Identifiable {
    case ultraLight = "UltraLight"
    case thin       = "Thin"
    case light      = "Light"
    case regular    = "Regular"  // nuevo
    case medium     = "Medium"   // nuevo

    var id: String { rawValue }

    /// Retorna el Font.Weight correspondiente
    var weight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular     // nuevo
        case .medium:     return .medium      // nuevo
        }
    }

    /// Texto legible
    var displayName: String { rawValue }
}


//MARK: - COLORES
enum EnumAjusteColor: String, CaseIterable {
    case colorPersonalizado
    case colorNeutral
    case colorColeccion
}

enum EnumFondoMenu: String, CaseIterable {
    case transparente
    case liquido
    case metalico
}

enum EnumPorcentajeEstilo: String, CaseIterable {
    case dentroCarta
    case contorno
}


//MARK: - HISTORIAL
enum EnumEstiloHistorialColecciones: String, CaseIterable {
    case basico
    case degradado
}


//MARK: - TEMAS
// TEMAS ESPECIALES QUE DEPENDEN DE UN CALCULO ANTES DE PODER SER UTILIZADOS
extension EnumTemas {
    func resolved(for scheme: ColorScheme, date: Date = Date()) -> EnumTemas {
        switch self {
        case .sistema:
            return scheme == .dark ? .dark : .light
        case .dayNight:
            let hour = Calendar.current.component(.hour, from: date)
            return (7..<21).contains(hour) ? .light : .dark
        default:
            return self // <-
        }
    }
}

//extension EnumTemas {
//    func resolved(for scheme: ColorScheme, date: Date = Date()) -> EnumTemas {
//        switch self {
//        case .sistema:
//            return scheme == .dark ? .dark : .light
//
//        case .dayNight:
//            let hour = Calendar.current.component(.hour, from: date)
//            let minute = Calendar.current.component(.minute, from: date)
//
//            // Día = desde 07:00 hasta 21:09 inclusive
//            // Noche = a partir de 21:10 o antes de 07:00
//            if (hour > 7 && hour < 21) || (hour == 7 && minute >= 0) || (hour == 21 && minute < 10) {
//                return .light
//            } else {
//                return .dark
//            }
//
//        default:
//            return self
//        }
//    }
//}



enum EnumTemas: String, CaseIterable {
    case light, dark, sistema, dayNight, blue, green, red, orange
    
    var gradientColors: (Color, Color) {
        switch self {
        case .light:   return (.fixedSystemGray6_light, .fixedSystemGray6_light)
        case .dark:    return (.fixedSystemGray5_dark, .fixedSystemGray5_dark)
        case .sistema: return (.clear, .clear)
        case .dayNight:return (.clear, .clear)
        case .blue:    return (.blue.opacity(0.5), .blue.opacity(0.8))
        case .green:   return (.teal, .green)
        case .red:     return (.purple, .red)
        case .orange:  return (.indigo, .black)
        }
    }
    
    var nombreTema: String {
        switch self {
        case .light:
            return "Claro"
        case .dark:
            return "Oscuro"
        case .sistema:
            return "Sistema"
        case .dayNight:
            return "Dia/Noche"
        case .blue:
            return "Océano"
        case .green:
            return "Esmeralda"
        case .red:
            return "Aurora"
        case .orange:
            return "Naraja oscuro"
        }
    }
    
    var descripcionTema: String {
        switch self {
        case .light:
            return "Un tema claro y luminoso, ideal para ambientes con buena iluminación."
        case .dark:
            return "Un tema oscuro que cuida la vista, ideal para la noche."
        case .sistema:
            return "Se adapta automáticamente al tema del dispositivo."
        case .dayNight:
            return "Cambia solo: claro durante el día y oscuro por la noche."
        case .blue:
            return "Un estilo moderno con un gradiente en tonos azules."
        case .green:
            return "Un tema fresco con matices verdes y turquesa."
        case .red:
            return "Un estilo intenso en tonos rojos y púrpura."
        case .orange:
            return "Un tema oscuro con matices anaranjados."
        }
    }
    
    var backgroundGradient: LinearGradient {
        let (c1, c2) = gradientColors
        return LinearGradient(colors: [c1, c2], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var reversedBackgroundGradient: LinearGradient {
        let (c1, c2) = gradientColors
        return LinearGradient(colors: [c2, c1], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var surfaceGradient: LinearGradient {
        let (c1, c2) = gradientColors
        return LinearGradient(colors: [c1.opacity(0.5), c2.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var reversedsurfaceGradient: LinearGradient {
        let (c1, c2) = gradientColors
        return LinearGradient(colors: [c2.opacity(0.3), c1.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    
    var backgroundColor: Color {
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .blue.opacity(0.2)
        case .green: return .teal.opacity(0.5)
        case .red: return .red.opacity(0.2)
        case .orange: return .orange.opacity(0.2)
        }
    }
    
    var menuIconos: Color {
        switch self {
        case .light: return .black.opacity(1.0)
        case .dark: return .white.opacity(1.0)
        case .green: return .black.opacity(0.5)
        default: return .white.opacity(1.0)
        }
    }
    
    var fondoMenus: Color {
        switch self {
        case .light: return .gray
        case .dark: return .gray
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .gray
        case .green: return .black
        case .red: return .black
        case .orange: return .orange
        }
    }
    
    var lineaColor: Color {
        switch self {
        case .light: return .gray
        case .dark: return .gray
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .white.opacity(0.7)
        case .green: return .black.opacity(0.5)
        case .red: return .black.opacity(0.5)
        case .orange: return .white.opacity(0.7)
        }
    }
    
    var cardColorFixed: Color {
        switch self {
        case .light, .dark, .sistema, .dayNight:
            return self.backgroundColor
        default:
            let (c1, c2) = gradientColors
            return c1.opacity(0.7) // o mezcla de c1 y c2 si quieres
        }
    }


    
    var colorContrario: Color {
        switch self {
        case .light: return .black
        case .dark: return .white
        case .blue: return .white
        case .green: return .black.opacity(0.7)
        case .red: return .black.opacity(0.7)
        default: return .white
        }
    }
    
    var cardColor: Color {
        
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
//        case .dark: return .black.opacity(0.3)
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .blue.opacity(0.5)
        case .green: return .teal.opacity(0.5)
        case .red: return .red.opacity(0.5)
        case .orange: return .indigo.opacity(0.5)
        }
        
    }
    
    var iconColor: Color {
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .blue.opacity(0.5)
        case .green: return .black.opacity(0.7)
        case .red: return .black.opacity(0.7)
        case .orange: return .orange.opacity(0.5)
        }
    }
    
    var tituloColor: Color {
        switch self {
        case .light: return .fixedSystemGray5_dark
        case .dark: return .fixedSystemGray6_light
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .white
        case .green: return .black
        case .red: return .black
        case .orange: return .white
        }
    }
    
    var textColor: Color {
        switch self {
        case .light: return .fixedSystemGray5_dark
        case .dark: return .fixedSystemGray6_light
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .white
        case .green: return .black.opacity(0.7)
        case .red: return .black.opacity(0.7)
        case .orange: return .white
        }
    }
    
    var secondaryText: Color {
        switch self {
        case .light: return .gray
        case .dark: return .gray
        case .sistema: return .clear
        case .dayNight: return .clear
        case .blue: return .white.opacity(0.5)
        case .green: return .black.opacity(0.5)
        case .red: return .black.opacity(0.5)
        case .orange: return .orange.opacity(0.7)
        }
    }
    
}

//MARK: - IDIOMAS

enum EnumIdiomas: String {
    
    case castellano
    case latino
    case ingles
    
}



