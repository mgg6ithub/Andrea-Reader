

import SwiftUI

@MainActor
class ModeloColeccion: ObservableObject {
    
  let coleccion: Coleccion
  var tipoSA: EnumTipoSistemaArchivos?
    
  @Published var elementos: [ElementoSistemaArchivos] = []
  @Published var isLoading = false
    
  @Published var color: Color
  @Published var scrollPosition: Int
  @Published var modoVista: EnumModoVista
  @Published var ordenacion: EnumOrdenaciones
  @Published var columnas: Int = 4
  @Published var altura: CGFloat = 180
    @Published var tiempoCarga: Double? = nil


  @Published var elementosCargados: Bool = false

    
  @Published var isPerformingAutoScroll = false

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
        
        let datos = PersistenciaDatos().obtenerAtributos(url: coleccion.url)

        if let scroll = datos?["scrollPosition"] as? Int {
            self.scrollPosition = scroll
        } else {
            self.scrollPosition = 0
        }

        if let hexColor = datos?["color"] as? String {
            self.color = Color(hex: hexColor)
        } else {
            self.color = .blue // default color
        }

        if let tipoVistaRaw = PersistenciaDatos().obtenerAtributoConcreto(url: coleccion.url, atributo: "tipoVista") as? String,
           let modo = EnumModoVista(rawValue: tipoVistaRaw) {
            self.modoVista = modo
        } else {
            self.modoVista = .lista
        }
        
        if let ordenacionString = PersistenciaDatos().obtenerAtributoConcreto(url: coleccion.url, atributo: "ordenacion") as? String, let ordenacion = EnumOrdenaciones(rawValue: ordenacionString) {
            self.ordenacion = ordenacion
        } else {
            self.ordenacion = .nombre
        }
        
        switch self.modoVista {
        case .cuadricula:
            if let columnasGuardadas = PersistenciaDatos().obtenerAtributoVista(coleccion: coleccion, modo: .cuadricula, atributo: "columnas") as? Int {
                self.columnas = columnasGuardadas
            } else {
                self.columnas = 4 // valor por defecto
            }
        case .lista:
            if let altura = PersistenciaDatos().obtenerAtributoVista(coleccion: coleccion, modo: .lista, atributo: "altura") as? CGFloat {
                self.altura = altura
            } else {
                self.altura = 180 // valor por defecto
            }
        default:
            break
        }
        
    }
    
    //Inyectamos appEstado desde CuadriculaVista
    func setSistemaArchivos(_ tipo: EnumTipoSistemaArchivos) {
        guard self.tipoSA == nil else { return }
        self.tipoSA = tipo
    }

    func cargarElementos() {
        guard !elementosCargados else { return }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        isLoading = true

        // 1. Obtener y filtrar URLs
        let allURLs = SistemaArchivos.sa.obtenerURLSDirectorio(coleccionURL: coleccion.url)
        var filteredURLs = allURLs.filter { url in
            SistemaArchivosUtilidades.sau.filtrosIndexado.allSatisfy {
                $0.shouldInclude(url: url)
            }
        }
        if self.tipoSA == .arbol {
            filteredURLs = filteredURLs.filter { url in
                !SistemaArchivosUtilidades.sau.isDirectory(elementURL: url)
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
            let elementosOrdenados = EnumOrdenaciones.ordenarElementos(
                todosLosElementos.map { $0.1 }, por: ordenacion
            )

            await MainActor.run {
//                withAnimation(.easeInOut(duration: 0.1)) {
                    self.elementos = elementosOrdenados
                    self.isLoading = false
                    self.elementosCargados = true
//                }
                let endTime = CFAbsoluteTimeGetCurrent()
                self.tiempoCarga = endTime - startTime
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
        PersistenciaDatos().guardarAtributoColeccion(coleccion: self.coleccion, atributo: "scrollPosition", valor: nuevo)
    }

    
    //MARK: --- ordenar los elementos pasandolo un modo de ordenacion ---
    func ordenarElementos(modoOrdenacion: EnumOrdenaciones) {
        self.ordenacion = modoOrdenacion
        let tempElementos = EnumOrdenaciones.ordenarElementos(self.elementos, por: modoOrdenacion)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { self.elementos = tempElementos }
        
        //guardamos en persistencia el modo de ordenacion
        PersistenciaDatos().guardarAtributoColeccion(coleccion: self.coleccion, atributo: "ordenacion", valor: modoOrdenacion)
    }
    
}

