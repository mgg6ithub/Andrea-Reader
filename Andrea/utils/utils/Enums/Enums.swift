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
}



//MARK: - TEMAS

enum EnumTemas: String, CaseIterable {
    case light, dark, dayNight, blue, green
    
    var backgroundColor: Color {
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.2)
        case .green: return .green.opacity(0.2)
        }
    }
    
    var cardColor: Color {
        
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        }
        
    }
    
    var iconColor: Color {
        switch self {
        case .light: return .fixedSystemGray6_light
        case .dark: return .fixedSystemGray5_dark
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        }
    }
    
    var textColor: Color {
        switch self {
        case .light: return .fixedSystemGray5_dark
        case .dark: return .fixedSystemGray6_light
        case .dayNight: return .white
        case .blue: return .blue
        case .green: return .green
        }
    }
    
    var secondaryText: Color {
        switch self {
        case .light: return .gray
        case .dark: return .gray
        case .dayNight: return .white
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        }
    }
}

//MARK: - COLOR PRINCIPAL



