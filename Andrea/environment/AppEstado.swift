//
//  AppEstado.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

class AppEstado: ObservableObject {
    
    private let cpag = ClavesPersistenciaAjustesGenerales()
    
    private let uds = UserDefaults.standard
    
    @Published var isFirstTimeLaunch: Bool = false
    @Published var resolucionLogica: EnumResolucionesLogicas
    
    @Published var temaActual: EnumTemas { didSet { uds.setEnum(temaActual, forKey: cpag.temaActual ) } }
    
    @Published var tipoSistemaArchivos: EnumTipoSistemaArchivos = .tradicional
    @Published var shadows: Bool = true
    @Published var animaciones: Bool = true
    
    @Published var screenWidth: CGFloat
    @Published var screenHeigth: CGFloat
    
    @Published var constantes: Constantes
    
    init(screenWidth: CGFloat? = nil, screenHeight: CGFloat? = nil) {
        self.isFirstTimeLaunch = true
        
        let actualScreenWidth = screenWidth ?? UIScreen.main.bounds.width
        let actualScreenHeight = screenHeight ?? UIScreen.main.bounds.height
                
        var scaleFactor = min(actualScreenWidth / 820, actualScreenHeight / 1180)
        
        switch scaleFactor {
            case ..<0.5: // Dispositivos pequeños iPhone 8, 7, 6 ...
                self.resolucionLogica = .small
                scaleFactor *= 1.4
            case 0.5...1.0:
                self.resolucionLogica = .medium
                break // No hacer nada
            case let x where x > 1.0: // Valores mayores a 1.0
                self.resolucionLogica = .big
//            scaleFactor *= 1.1
            default:
                self.resolucionLogica = .medium
                break
        }
        
        self.screenWidth = actualScreenWidth
        self.screenHeigth = actualScreenHeight

        self.constantes = Constantes(scaleFactor: scaleFactor)
        
        self.temaActual = uds.getEnum(forKey: cpag.temaActual, default: .light)
        
    }
    
    func aplicarNuevoTema(_ tema: EnumTemas) {
        temaActual = tema
    }
    
}
