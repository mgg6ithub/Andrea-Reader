
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
    
    //TEMAS
    public let temaActual: String = "TemaActual"
    
    //COLORES
    public let colorPersonalizado: String = "ColorPersonalizado"
    public let ajusteColor: String = "ajusteColor"
    
    //SISTEMA DE ARCHIVOS
    public let sistemaArchivos: String = "SistemaArchivos"
    
    //RENDIMIENTO
    public let shadows: String = "shadows"
    public let animaciones: String = "animaciones"
    
    //MENU
    public let barraEstado: String = "barraEstado"
    
    public let menuLateral: String = "menuLateral"
    public let flechaAtras: String = "flechaAtras"
    public let seleccionMultiple: String = "seleccionMultiple"
    public let notificaciones: String = "notificaciones"
    
    public let iconosDobleColor: String = "iconocDobleColor"
    public let iconosColorGris: String = "iconosColorGris"
    public let iconosColorAuto: String = "iconosColorAuto"
    
    public let iconSize: String = "iconSize"
    public let iconoFuente: String = "iconoFuente"
    
    public let fondoMenu: String = "fondoMenu"
    public let colorFondoMenu: String = "colorFondoMenu"
    
    //HISTORIAL
    public let historiaclColecciones: String = "historialColecciones"
    public let historialEstilo: String = "historialEstilo"
    public let historialSize: String = "historialSize"
    
}


struct AjustesGeneralesPredeterminados {
    
    //TEMAS
    public let temaP: EnumTemas = .dayNight
    
    //COLORES
    public let colorP: Color = .gray
    public let ajusteColorP: EnumAjusteColor = .colorColeccion
    
    //SISTEMA DE ARCHIVOS
    public let saP: EnumTipoSistemaArchivos = .tradicional
    
    //RENDIMIENTO
    public let shadows: Bool = true
    public let animaciones: Bool = true
    
    //MENU
    public let barraEstado: EnumBarraEstado = .auto
    
    public let menuLateral: Bool = true
    public let flechaAtras: Bool = true
    public let seleccionMultiple: Bool = true
    public let notificaciones: Bool = true
    
    public let iconosDobleColor: Bool = true
    public let iconosColorGris: Bool = false
    public let iconosColorAuto: Bool = true
    
    public let iconSize: Double = 24
    public let iconoFuente: EnumFuenteIcono = .thin
    
    public let fondoMenu: Bool = true
    public let colorFondoMenu: EnumFondoMenu = .transparente
    
    //HISTORIAL
    public let historialColecciones: Bool = true
    public let historialEstilo: EnumEstiloHistorialColecciones = .basico
    public let historialSize: Double = 18.0
    
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
    
    var tituloAjustes: CGFloat { resLog == .small ? titleSize : titleSize * 0.75 }
    var descripcionAjustes: CGFloat { resLog == .small ? titleSize : subTitleSize }
    
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
