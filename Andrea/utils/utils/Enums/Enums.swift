//
//  Enums.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

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
}

//MARK: - FUENTES
enum EnumFuenteIcono: String, CaseIterable, Identifiable {
    case ultraLight = "UltraLight"
    case thin = "Thin"
    case light = "Light"
    
    var id: String { rawValue }
    
    /// Retorna el Font.Weight correspondiente
    var weight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        }
    }
    
    /// Texto legible
    var displayName: String {
        rawValue
    }
}

//MARK: - COLORES
enum EnumAjusteColor: String, CaseIterable {
    case colorPersonalizado
    case colorNeutral
    case colorColeccion
}


//MARK: - TEMAS

enum EnumTemas: String, CaseIterable {
    case light, dark, dayNight, blue, green, red, orange
    
    var gradientColors: (Color, Color) {
        switch self {
        case .light:   return (.fixedSystemGray6_light, .fixedSystemGray6_light)
        case .dark:    return (.fixedSystemGray5_dark, .fixedSystemGray5_dark)
        case .dayNight:return (.indigo.opacity(0.8), .black.opacity(0.8))
        case .blue:    return (.blue.opacity(0.5), .blue.opacity(0.8))
        case .green:   return (.teal, .green)
        case .red:     return (.purple, .red)
        case .orange:  return (.orange.opacity(0.4), .orange.opacity(0.7))
        }
    }

    var backgroundGradient: LinearGradient {
        let (c1, c2) = gradientColors
        return LinearGradient(colors: [c1, c2], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var surfaceGradient: LinearGradient {
        let (c1, c2) = gradientColors
        return LinearGradient(colors: [c1.opacity(0.35), c2.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var backgroundColor: Color {
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.2)
        case .green: return .green.opacity(0.2)
        case .red: return .red.opacity(0.2)
        case .orange: return .orange.opacity(0.2)
        }
    }
    
    var menuIconos: Color {
        switch self {
        case .light: return .black.opacity(1.0)
        case .dark: return .white.opacity(1.0)
        default: return .white.opacity(1.0)
        }
    }
    
    var menuIconosNeutro: Color {
        return .gray
    }
    
    
    var colorContrario: Color {
        switch self {
        case .light: return .black
        case .dark: return .white
        default: return .white
        }
    }
    
    var cardColor: Color {
        
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
//        case .dark: return .black.opacity(0.3)
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        case .red: return .red.opacity(0.5)
        case .orange: return .orange.opacity(0.5)
        }
        
    }
    
    var iconColor: Color {
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        case .red: return .red.opacity(0.5)
        case .orange: return .orange.opacity(0.5)
        }
    }
    
    var textColor: Color {
        switch self {
        case .light: return .fixedSystemGray5_dark
        case .dark: return .fixedSystemGray6_light
        case .dayNight: return .white
        case .blue: return .blue
        case .green: return .green
        case .red: return .red
        case .orange: return .orange
        }
    }
    
    var secondaryText: Color {
        switch self {
        case .light: return .gray
        case .dark: return .gray
        case .dayNight: return .white
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        case .red: return .red.opacity(0.5)
        case .orange: return .orange.opacity(0.5)
        }
    }
}

//MARK: - IDIOMAS

enum EnumIdiomas: String {
    
    case castellano
    case latino
    case ingles
    
}



