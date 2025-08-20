

import SwiftUI

@MainActor
extension ModeloColeccion {
    /// Elementos que la UI debe pintar según el modo de sistema de archivos
    func elementosParaMostrar(segun modo: EnumTipoSistemaArchivos) -> [ElementoSistemaArchivos] {
        if modo == .arbol {
            // En modo árbol solo mostramos archivos (y opcionalmente placeholders si los usas)
            return elementos.filter { $0 is Archivo || $0 is ElementoPlaceholder }
        } else {
            return elementos
        }
    }

    /// ¿Hay al menos un archivo entre los elementos?
    var tieneArchivos: Bool {
        elementos.contains { $0 is Archivo }
    }
}


@MainActor
class ModeloColeccion: ObservableObject {
    
    let coleccion: Coleccion

    @Published var elementos: [ElementoSistemaArchivos] = []
    @Published var isLoading = false

    @Published var color: Color
    @Published var scrollPosition: Int
    @Published var modoVista: EnumModoVista
    @Published var ordenacion: EnumOrdenaciones
    @Published var esInvertido: Bool = false

    @Published var columnas: Int = 4
    @Published var altura: CGFloat = 145 {
        didSet {
            ajusteHorizontal = actualizarAjusteHorizontal(altura: altura)
        }
    }

    @Published var ajusteHorizontal: CGFloat = 40
    @Published var tiempoCarga: Double? = nil

    @Published var elementosCargados: Bool = false

    @Published var isPerformingAutoScroll = false

    @Published var menuRefreshTrigger: UUID = UUID()

    func actualizarAjusteHorizontal(altura: CGFloat) -> CGFloat {
        // Punto base: 140 -> 55 ajuste
        // Cada 10 puntos de altura extra, sumar 5 al ajuste
        let baseAltura: CGFloat = 145
        let baseAjuste: CGFloat = 40
        
        let diferencia = altura - baseAltura
        let ajusteExtra = (diferencia / 10) * 5
        let nuevoAjuste = baseAjuste + ajusteExtra
        
        // Limitar para que no sea negativo ni muy grande
        return max(20, min(nuevoAjuste, 120))
    }

    
    //MARK: - CONSTRUCTOR VACIO
    //crear un constrcutor por defecto con valores nulos para crear una instancia de ModeloColeccion vacia para tests
    init() {
            // Colección mínima para poder inicializar
        self.coleccion = Coleccion(directoryName: "TEST", directoryURL: URL(fileURLWithPath: ""), fechaImportacion: Date(), fechaModificacion: Date(), favorito: true, protegido: true)
            
//            self.tipoSA = nil
            self.elementos = []
            self.isLoading = false
            self.color = .gray
            self.scrollPosition = 0
            self.modoVista = EnumModoVista.cuadricula
            self.ordenacion = EnumOrdenaciones.nombre
            self.esInvertido = false
            self.columnas = 4
            self.altura = 180
            self.tiempoCarga = nil
            self.elementosCargados = false
            self.isPerformingAutoScroll = false
        }
    
    
    init(_ coleccion: Coleccion) {
        self.coleccion = coleccion
        
        //Llamamos a la persistencia para obtener los datos de la coleccion
        //DATOS
        // - Color
        // - posicion scroll
        // - Ordenamiento
        // - Tipo de vista
        //    - Cuadricula
        //    - Lista
        
        let pd = PersistenciaDatos()
        
        let datos = pd.obtenerAtributos(url: coleccion.url)

        if let scroll = datos?["scrollPosition"] as? Int {
            self.scrollPosition = scroll
        } else {
            self.scrollPosition = 0
        }

        if let hexColor = datos?["color"] as? String {
            self.color = Color(hex: hexColor)
        } else {
            self.color = .gray // default color
        }

        if let tipoVistaRaw = pd.obtenerAtributoConcreto(url: coleccion.url, atributo: "tipoVista") as? String,
           let modo = EnumModoVista(rawValue: tipoVistaRaw) {
            self.modoVista = modo
        } else {
            self.modoVista = .cuadricula
        }
        
        if let ordenacionString = pd.obtenerAtributoConcreto(url: coleccion.url, atributo: "ordenacion") as? String, let ordenacion = EnumOrdenaciones(rawValue: ordenacionString) {
            self.ordenacion = ordenacion
        } else {
            self.ordenacion = .nombre
        }
        
        if let raw = pd .obtenerAtributoConcreto(url: coleccion.url, atributo: "esInvertido") {
            if let boolVal = raw as? Bool {
                self.esInvertido = boolVal
            }
            else if let strVal = raw as? String, let parsed = Bool(strVal) {
                self.esInvertido = parsed
            } else {
                self.esInvertido = false
            }
        } else {
            self.esInvertido = false
        }
        
        switch self.modoVista {
        case .cuadricula:
            if let columnasGuardadas = pd.obtenerAtributoVista(coleccion: coleccion, modo: .cuadricula, atributo: "columnas") as? Int {
                self.columnas = columnasGuardadas
            } else {
                self.columnas = 4 // valor por defecto
            }
        case .lista:
            if let altura = pd.obtenerAtributoVista(coleccion: coleccion, modo: .lista, atributo: "altura") as? CGFloat {
                self.altura = altura
            } else {
                self.altura = 180 // valor por defecto
            }
        default:
            break
        }
        
    }

    func cargarElementos() {
        guard !elementosCargados else { return }
            
        let startTime = CFAbsoluteTimeGetCurrent()
        isLoading = true

        // 1. Obtener y filtrar URLs
        let allURLs = SistemaArchivos.sa.obtenerURLSDirectorio(coleccionURL: coleccion.url)
        let filteredURLs = allURLs.filter { url in
            SistemaArchivosUtilidades.sau.filtrosIndexado.allSatisfy {
                $0.shouldInclude(url: url)
            }
        }

        // 2. Prepara placeholders
        let total = filteredURLs.count
        if self.scrollPosition >= total || self.scrollPosition < 0 {
            self.scrollPosition = 0
        }
        elementos = (0..<total).map { _ in ElementoPlaceholder() }
        self.isPerformingAutoScroll = true

        // 3. Carga e indexado asíncrono con batching
        // Paso 3: cargar e indexar asincrónicamente
        Task.detached { [weak self] in
            guard let self = self else { return }

            let centro = await MainActor.run { self.scrollPosition }
            let urls = await MainActor.run { filteredURLs }
            let ordenacion = await MainActor.run { self.ordenacion }
            let indices = Algoritmos().generarIndicesDesdeCentro(centro, total: urls.count)

            var todosLosElementos: [(Int, ElementoSistemaArchivos)] = []

            for (_, idx) in indices.enumerated() {
                let url = urls[idx]
                let elemento = SistemaArchivos.sa.crearInstancia(elementoURL: url)
                todosLosElementos.append((idx, elemento))
            }
            
            // Ordenar todos los elementos (sin importar el orden de entrada)
            let elementosOrdenados = await Algoritmos().ordenarElementos(todosLosElementos.map { $0.1 }, por: ordenacion, esInvertido: self.esInvertido, coleccionURL: self.coleccion.url)
            
            await MainActor.run {
                
                self.elementos = elementosOrdenados
                
                //MARK: - --- CONSEJO IMPORTAR ELEMENTOS COLECCION VACIA ---
                ConsejoImportarElementos.coleccionVacia = self.elementos.isEmpty
                
                self.isLoading = false
                self.elementosCargados = true
                
                let endTime = CFAbsoluteTimeGetCurrent()
                let tiempoTotal = endTime - startTime
                self.tiempoCarga = tiempoTotal

            }
        }
    }
    
    func reiniciarCarga() {
        elementosCargados = false
    }
    
    func resetScrollState() {
        isPerformingAutoScroll = false
    }

    func actualizarScroll(_ nuevo: Int) {
        scrollPosition = nuevo
        PersistenciaDatos().guardarDatoElemento(url: self.coleccion.url, atributo: "scrollPosition", valor: nuevo)
    }
    
    //MARK: --- METODO PARA CAMBIAR EL MODO DE VISTA DE LA COLECCION
    
    func cambiarModoVista(modoVista: EnumModoVista) {
//        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {  self.modoVista = modoVista }
        withAnimation(.easeInOut(duration: 0.3)) {  self.modoVista = modoVista }
//        self.modoVista = modoVista
        PersistenciaDatos().guardarDatoElemento(url: self.coleccion.url, atributo: "tipoVista", valor: modoVista)
    }

    
    //MARK: --- ordenar los elementos pasandolo un modo de ordenacion ---
    
    func ordenarElementos(modoOrdenacion: EnumOrdenaciones) {
        self.ordenacion = modoOrdenacion
        let tempElementos = Algoritmos().ordenarElementos(self.elementos, por: modoOrdenacion, esInvertido: self.esInvertido)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { self.elementos = tempElementos }
        
        //guardamos en persistencia el modo de ordenacion
        PersistenciaDatos().guardarDatoElemento(url: self.coleccion.url, atributo: "ordenacion", valor: modoOrdenacion)
    }
    
    //MARK: --- INVERTIR ORDENACION ACTUAL ---
    
    func invertir() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {  self.esInvertido.toggle() }
        self.ordenarElementos(modoOrdenacion: self.ordenacion)
        PersistenciaDatos().guardarDatoElemento(url: self.coleccion.url, atributo: "esInvertido", valor: esInvertido)
    }
    
    //Si esta invertido lo quitamos
    private func quitarInvertido() {
        if self.esInvertido {
            self.invertir()
        }
    }
    
    //MARK: --- renombrear los elementos con regex y ordenarlos de golpe ---
    func smartSorting() {
        
        let archivos = elementos.compactMap { $0 as? Archivo }
        
        for archivo in archivos {
            if let nuevoNombre = ManipulacionCadenas().renameExpresion(originalName: archivo.nombre) {
                SistemaArchivos.sa.renombrarElemento(elemento: archivo, nuevoNombre: nuevoNombre)
            }
        }
        
        self.quitarInvertido()
        DispatchQueue.main.async { self.ordenarElementos(modoOrdenacion: .nombre) }
    }
    
    //MARK: - ORDENAMIENTO PERSONALIZADO
    func guardarOrdenPersonalizado(modoOrdenacion: EnumOrdenaciones) {
        
        self.ordenacion = .personalizado
        
        var ordenDict: [String: Int] = [:]
        
        print("Guardando diccinario de orden personzalido")
        
        for (i, elemento) in self.elementos.enumerated() {
            ordenDict[PersistenciaDatos().obtenerKey(elemento.url)] = i
        }
        
        self.quitarInvertido()

        //guardamos la ordenacion
        PersistenciaDatos().guardarDatoElemento(url: self.coleccion.url, atributo: "ordenacion", valor: modoOrdenacion)
        
        print("Guardando diccinario: ", ordenDict)
        // Guarda el diccionario completo como atributo "ordenPersonalizado"
        PersistenciaDatos().guardarDatoElemento(url: self.coleccion.url, atributo: "ordenPersonalizado", valor: ordenDict)
    }

    
}

