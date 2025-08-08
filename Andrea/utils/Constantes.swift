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
    
    // --- RECNTAGULO ZSTACK FONDO ---
    
    var altoRectanguloFondo: CGFloat = 230 //Alto del rectangulo de fondo para los ajustes general
    var altoRectanguloPeke: CGFloat = 140 //Ancho del rectangulo peke que contiene una opcion (por ejemñplo el de un tema)
    var anchoRectangulo: CGFloat = 100 //Ancho del rectangulo peke que contiene una opcion (por ejemplo el de un tema)
    
    
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
    
    //MARK: - RECTANGULO FONDO
    var altoRectanguloFondo: CGFloat
    var anchoRectangulo: CGFloat
    var altoRectanguloPeke: CGFloat
    
    var cAnchoRect: CGFloat { resLog == .big ? anchoRectangulo : anchoRectangulo * 0.8 }
    var cAlturaRect: CGFloat { resLog == .big ? altoRectanguloPeke : altoRectanguloPeke * 0.8 }
    
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
        
        self.altoRectanguloFondo = cpd.altoRectanguloFondo * scaleFactor
        self.anchoRectangulo = cpd.altoRectanguloPeke * scaleFactor
        self.altoRectanguloPeke = altoRectanguloFondo * 0.9
        
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
