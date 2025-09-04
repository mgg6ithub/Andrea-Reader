
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

//MARK: - --- PERSISTENCIA DATOS DE ELEMENTOS ---
struct ClavesPersistenciaElementos {
    
    //al importar
    public let fechaImportacion: String = "fechaImportacion"
    public let fechaPrimeraVezEntrado: String = "fechaPrimeraVezEntrado"
    public let nombreOriginal: String = "nombreOriginal"
    
    //Datos basicos
    public let autor: String = "autor"
    public let descripcion: String = "descripcion"
    
    public let puntuacion: String = "puntuacion"
    public let favoritos: String = "favotiros"
    public let protegidos: String = "Protegidos"
    
    public let imagenPersonalizada: String = "imagenPersonalizada"
    
    //MARK: - --- SOLO COLECCIONES ---
    //COLOR (normalmente para el color de una coleccion)
    public let colorGuardado: String = "colorGuardado"
    public let icono: String = "icono"
    public let desplazamientoColeccion: String = "desplazamientoColeccion"
    public let enumModoVista: String = "enumModoVista"
    public let enumModoOrdenacion: String = "enumModoOrdenacion"
    public let ordenPersonalizado: String = "ordenPersonalizado"
    public let esInvertido: String = "esInvertido"
    public let columnas: String = "columnas"
    public let altura: String = "altura"
    
    //MARK: - --- SOLO COLECCIONES ---
    
    //PROGRESO DE UN ELEMENTO
    public let progresoElemento: String = "progreso_archivo"
    
    //MINIATURA DE UN ELEMENTO
    public let miniaturaElemento: String = "miniatura_archivo"
    
    //ESTADISTICAS
    //tiempo total de lectura
    public let tiempoLecturaTotal: String = "tiempoLecturaTotal"
    
    //tiempos por pagina
    public let tiemposPorPagina: String = "tiemposPorPagina"
    
    //visitas por pagina
    public let visitasPorPagina: String = "visitasPorPagina"
    
    //sesiones lectura
    public let sesionesLecturas: String = "sesionesLecturas"
    
    
    //ARRAY DE CLAVES PARA PODER ACTUALIZAR EN PERSISTENCIA DEL TIRON
    public var arrayClavesPersistenciaElementos: [String] {
            [
                fechaImportacion,
                fechaPrimeraVezEntrado,
                nombreOriginal,
                
                autor,
                descripcion,
                
                puntuacion,
                favoritos,
                protegidos,
                
                imagenPersonalizada,
                
                colorGuardado,
                icono,
                desplazamientoColeccion,
                enumModoVista,
                enumModoOrdenacion,
                ordenPersonalizado,
                esInvertido,
                columnas,
                altura,
                
                progresoElemento, //pagina actual
                miniaturaElemento, //tipo de miniatura
                tiempoLecturaTotal,
                tiemposPorPagina,
                visitasPorPagina,
                sesionesLecturas
                
            ]
        }
}

struct ValoresElementoPredeterminados {
    
    public let fechaImportacion: Date? = nil
    
    //Primera vez que se entra a leer el archivo
    public let fechaPrimeraVezEntrado: Date? = nil
    public let nombreOriginal: String? = nil
    
    //Datos basicos
    public let autor: String = ""
    public let descripcion: String = ""
    
    public let puntuacion: Double = 0.0
    public let favoritos: Bool = false
    public let protegidos: Bool = false
    
    public let imagenPersonalizada: String = "" // <- imagen personalizada
    
    //COLOR
    public let colorGuardado: Color = .gray
    public let icono: String = "" // <- icono personalizado
    public let desplazamientoColeccion: Int = 0
    public let enumModoVista: EnumModoVista = .cuadricula
    public let enumModoOrdenacion: EnumOrdenaciones = .nombre
    public let ordenPersonalizado: [String : Int] = [:]
    public let esInvertido: Bool = false
    public let columnas: Int = 4
    public let altura: CGFloat = 180
    
    //PROGRESO DE UN ELEMENTO
    public let progresoElemento: Int = 0
    
    //MINIATURA DE UN ELEMENTO
    public let miniaturaElemento: EnumTipoMiniatura = .primeraPagina
    
    //ESTADISTICAS
    //tiempo total de lectura
    public let tiempoLecturaTotal: TimeInterval = 0
    
    //tiempos por pagina
    public let tiemposPorPagina: [String:TimeInterval] = [:]
    
    //visitas por pagina
    public let visitasPorPagina: [String:Int] = [:]
    
    //sesiones
    public let sesionesLecturas: [SesionDeLectura] = []
    
    
}
//MARK: - --- PERSISTENCIA DATOS DE ELEMENTOS ---

struct ClavesPersistenciaAjustesGenerales {
    
    //MARK: - --- PILA COLECCIONES ---
    var pilaGuardada: String = "pilaGuardada"
    //MARK: - --- PILA COLECCIONES ---
    
    //MARK: - --- AJUSTES GENERALES ---
    public let seccionSeleccionada: String = "seccionSeleccionada"
    
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
    
    //LIBRERIA
    public let barraBusqueda: String = "barraBusqueda"
    //porcentaje
    public let porcentaje: String = "porcentaje"
    
    public let porcentajeNumero: String = "porcentajeNumero"
    public let porcentajeNumeroSize: String = "porcentajeNumeroSize"
    
    public let porcentajeBarra: String = "porcentajeBarra"
    
    public let porcentajeEstilo: String = "porcentajeEstilo"
    
    //fondo carta
    public let fondoCarta: String = "fondoCarta"
    
    //desplazamiento
    public let despAutoGurdado: String = "despAutoGurdado"
    
    //MARK: - --- AJUSTES GENERALES ---
    
}


struct AjustesGeneralesPredeterminados {
    
    //MARK: - --- PILA COLECCIONES ---
    public let pilaGuardada: [String]? = [SistemaArchivosUtilidades.sau.home.path]
    
    //MARK: - --- AJUSTES GENERALES ---
    public let seccionSeleccionada: String = "TemaPrincipal"
    
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
    
    //LIBRERIA
    public let barraBusqueda: Bool = true
    
    //porcentaje
    public let porcentaje: Bool = true
    
    public let porcentajeNumero: Bool = true
    public let porcentajeNumeroSize: Double = ConstantesPorDefecto().subTitleSize
    
    public let porcentajeBarra: Bool = true
    
    public let porcentajeEstilo: EnumPorcentajeEstilo = .dentroCarta
    
    //fondo carta
    public let fondoCarta: Bool = true
    
    //desplazamiento
    public let despAutoGurdado: Bool = true
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
