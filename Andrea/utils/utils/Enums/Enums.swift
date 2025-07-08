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


//MARK: - RESOLUCIONES LOGICAS
enum EnumResolucionesLogicas {
    case small
    case medium
    case big
}

//MARK: - TEMAS

enum EnumTemas: String, CaseIterable {
    case light, dark, dayNight, blue, green
    
    var backgroundColor: Color {
        switch self {
        case .light: return Color(UIColor.systemGray6)
        case .dark: return Color(UIColor.systemGray5)
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.2)
        case .green: return .green.opacity(0.2)
        }
    }
    
    var cardColor: Color {
        
        switch self {
        case .light: return Color(UIColor.systemGray6)
        case .dark: return Color(UIColor.systemGray5)
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        }
        
    }
    
    var iconColor: Color {
        switch self {
        case .light: return Color(UIColor.systemGray5)
        case .dark: return Color(UIColor.systemGray4)
        case .dayNight: return .black.opacity(0.5)
        case .blue: return .blue.opacity(0.5)
        case .green: return .green.opacity(0.5)
        }
    }
    
    var textColor: Color {
        switch self {
        case .light: return .black
        case .dark: return .white
        case .dayNight: return .white
        case .blue: return .blue
        case .green: return .green
        }
    }
}

//MARK: - COLOR PRINCIPAL



