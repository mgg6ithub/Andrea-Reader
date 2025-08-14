
import SwiftUI

struct ConstantesPorDefecto {
    
    //MARK: - PADDING GENERAL
    var padding5: CGFloat = 5
    var padding10: CGFloat = 10
    var padding15: CGFloat = 15
    var padding20: CGFloat = 20
    var padding25: CGFloat = 25
    var padding30: CGFloat = 30
    var padding35: CGFloat = 35
    var padding40: CGFloat = 40
    
    var horizontalPadding: CGFloat = 15
    var verticalPadding: CGFloat = 20
    
    var paddingCorto: CGFloat = 14.5
    
    // --- RECNTAGULO ZSTACK FONDO ---
    
    var altoRectanguloFondo: CGFloat = 230 //Alto del rectangulo de fondo para los ajustes general
    var altoRectanguloPeke: CGFloat = 140 //Ancho del rectangulo peke que contiene una opcion (por ejemñplo el de un tema)
    var anchoRectangulo: CGFloat = 100 //Ancho del rectangulo peke que contiene una opcion (por ejemplo el de un tema)
    
    
    //MARK: - ICONO
    var iconSize: CGFloat = 22
    var iconWeightUltraThin: Font.Weight = .ultraLight
    var iconWeightThin: Font.Weight = .thin
    var iconWeightLight: Font.Weight = .light
    var iconColor: Color = .gray
    
    //MARK: - TIPOGRAFIA
    var titleSize: CGFloat = 21
    var subTitleSize: CGFloat = 16
    var smallTitleSize: CGFloat = 10
    
    //MARK: - --- PERSISTENCIA ---
    var pilaColeccionesClave: String = "pilaGuardada"
    
    //MARK: - COLORES
    let listaColores: [Color] = [
        .red,
        .green,
        .blue,
        .yellow,
        .orange,
        .purple,
        .pink,
        .teal,
        .mint,
        .indigo
    ]
    //MARK: - --- PERSISTENCIA ---
    
    //MARK: - --- IMAGENES ---
    public let dComicSize: CGSize = CGSize(width: 190, height: 260)
        
    public let dNotFoundUIImage: UIImage = UIImage(systemName: "exclamationmark.triangle.fill")! //Fallo al cargar la UIImage
    public let dNotFoundImage: Image = Image(systemName: "exclamationmark.triangle.fill") //Fallo al cargar la Image
    public let dFolderIcon: Image = Image("folder-icon") //ICONO CARPETA
    
    //MARK: - --- IMAGENES ---
}


struct ClavesPersistenciaAjustesGenerales {
    
    public let temaActual: String = "TemaActual"
    public let sistemaArchivos: String = "SistemaArchivos"
    
}

//MARK: - --- TODAS LAS COSNTANTES MULTIPLICADAS POR LA ESCALA ---
struct Constantes {
    
    var scaleFactor: CGFloat
    var resLog: EnumResolucionesLogicas
    
    //MARK: - PADDINGS
    var padding5: CGFloat    
    var padding10: CGFloat
    var padding15: CGFloat
    var padding20: CGFloat
    var padding25: CGFloat
    var padding30: CGFloat
    var padding35: CGFloat
    var padding40: CGFloat
    
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
        
        //PADDINGS
        self.padding5 = cpd.padding5 * scaleFactor
        self.padding10 = cpd.padding10 * scaleFactor
        self.padding15 = cpd.padding15 * scaleFactor
        self.padding20 = cpd.padding20 * scaleFactor
        self.padding25 = cpd.padding25 * scaleFactor
        self.padding30 = cpd.padding30 * scaleFactor
        self.padding35 = cpd.padding35 * scaleFactor
        self.padding40 = cpd.padding40 * scaleFactor
        
        //RECTANGULO
        self.altoRectanguloFondo = cpd.altoRectanguloFondo * scaleFactor
        self.anchoRectangulo = cpd.altoRectanguloPeke * scaleFactor
        self.altoRectanguloPeke = altoRectanguloFondo * 0.9
        
        //ICONOS
        if resLog == .small {
            self.iconSize = cpd.iconSize * scaleFactor + 5
        } else {
            self.iconSize = cpd.iconSize * scaleFactor + 2.5
        }
        self.iconWeight = cpd.iconWeightLight
        self.iconColor = cpd.iconColor
        
        //TEXTO
        self.titleSize = cpd.titleSize * scaleFactor
        self.subTitleSize = cpd.subTitleSize * scaleFactor
        self.smallTitleSize = cpd.smallTitleSize * scaleFactor
    }
    
}
