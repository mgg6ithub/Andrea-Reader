//
//  Enums.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

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
        case .light: return .white.opacity(0.5)
        case .dark: return .black.opacity(0.5)
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

//MARK: COLOR PRINCIPAL

