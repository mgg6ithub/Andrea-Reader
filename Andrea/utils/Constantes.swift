//
//  DefaultConstants.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

struct ConstantesValores {
    
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
        
        self.iconSize = ConstantesValores().iconSize * scaleFactor
        self.iconWeight = ConstantesValores().iconWeight
        self.iconColor = ConstantesValores().iconColor
        
        self.titleSize = ConstantesValores().titleSize * scaleFactor
        self.subTitleSize = ConstantesValores().subTitleSize * scaleFactor
        self.smallTitleSize = ConstantesValores().smallTitleSize * scaleFactor
    }
    
}
