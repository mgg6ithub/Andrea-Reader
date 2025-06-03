//
//  DefaultConstants.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

struct ConstantesPorDefecto {
    
    /**
            VALORES POR DEFECTO DE LAS VARIABLES MAS USADAS
     */
    
    //MARK: - PADDING GENERAL
    var horizontalPadding: CGFloat = 15
    var verticalPadding: CGFloat = 20
    
    var paddingCorto: CGFloat = 4.5
    
    //MARK: - ICONO
    var iconSize: CGFloat = 25
    var iconWeight: Font.Weight = .thin
    var iconColor: Color = .gray
    
    //MARK: - TIPOGRAFIA
    var titleSize: CGFloat = 21
    var subTitleSize: CGFloat = 16
    var smallTitleSize: CGFloat = 10
    
    /**
            PERSISTENCIA
     */
    
    //MARK: - Nombres clave para los archivos de la persistencia
    //MARK: - USERDEFAULTS
    
    //almacena las url de las colecciones de la pila en el mismo orden.
    var pilaColeccionesClave: String = "pilaGuardada"
}


struct Constantes {
    
    var scaleFactor: CGFloat
    
    //MARK: - ICONOS
    
    var iconSize: CGFloat
    var iconWeight: Font.Weight
    var iconColor: Color
    
    //MARK: - TIPOGRAFIA
    
    var titleSize: CGFloat
    var subTitleSize: CGFloat
    var smallTitleSize: CGFloat
    
    init(scaleFactor: CGFloat) {
        
        self.scaleFactor = scaleFactor
        
        let cpd = ConstantesPorDefecto()
        
        self.iconSize = cpd.iconSize * scaleFactor
        self.iconWeight = cpd.iconWeight
        self.iconColor = cpd.iconColor
        
        self.titleSize = cpd.titleSize * scaleFactor
        self.subTitleSize = cpd.subTitleSize * scaleFactor
        self.smallTitleSize = cpd.smallTitleSize * scaleFactor
    }
    
}
