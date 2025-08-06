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
    
    var paddingCorto: CGFloat = 14.5
    
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
    
    //MARK: - COLORES
    let lista: [Color] = [
        .blue,
        .green,
        .orange,
        .pink,
        .purple,
        .red,
        .teal,
        .yellow,
        .mint,
        .indigo
    ]
    
    //MARK: - IMAGENES
    public let dComicSize: CGSize = CGSize(width: 190, height: 260)
        
    public let dNotFoundUIImage: UIImage = UIImage(systemName: "exclamationmark.triangle.fill")! //Fallo al cargar la UIImage
    public let dNotFoundImage: Image = Image(systemName: "exclamationmark.triangle.fill") //Fallo al cargar la Image
    public let dFolderIcon: Image = Image("folder-icon") //ICONO CARPETA
    
}


struct ClavesPersistenciaAjustesGenerales {
    
    public let temaActual: String = "TemaActual"
    public let sistemaArchivos: String = "SistemaArchivos"
    
}


struct Constantes {
    
    var scaleFactor: CGFloat
    var resLog: EnumResolucionesLogicas
    
    //MARK: - ICONOS
    
    var iconSize: CGFloat
    var iconWeight: Font.Weight
    var iconColor: Color
    
    //MARK: - TIPOGRAFIA
    
    var titleSize: CGFloat
    var subTitleSize: CGFloat
    var smallTitleSize: CGFloat
    
    init(scaleFactor: CGFloat, resLog: EnumResolucionesLogicas) {
        
        self.scaleFactor = scaleFactor
        self.resLog = resLog
        
        let cpd = ConstantesPorDefecto()
        
        if resLog == .small {
            self.iconSize = cpd.iconSize * scaleFactor + 5
        } else {
            self.iconSize = cpd.iconSize * scaleFactor + 2.5
        }
        
        self.iconWeight = cpd.iconWeight
        self.iconColor = cpd.iconColor
        
        self.titleSize = cpd.titleSize * scaleFactor
        self.subTitleSize = cpd.subTitleSize * scaleFactor
        self.smallTitleSize = cpd.smallTitleSize * scaleFactor
    }
    
}
