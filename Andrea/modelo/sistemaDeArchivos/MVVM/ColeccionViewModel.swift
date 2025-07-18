

import SwiftUI

@MainActor
class ColeccionViewModel: ObservableObject {
    
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
        
        let datos = PersistenciaDatos().obtenerDatosColeccion(coleccion: coleccion)

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

        if let tipoVistaRaw = PersistenciaDatos().obtenerAtributo(coleccion: coleccion, atributo: "tipoVista") as? String,
           let modo = EnumModoVista(rawValue: tipoVistaRaw) {
            self.modoVista = modo
        } else {
            self.modoVista = .lista
        }
        
        if let ordenacionString = PersistenciaDatos().obtenerAtributo(coleccion: coleccion, atributo: "ordenacion") as? String, let ordenacion = EnumOrdenaciones(rawValue: ordenacionString) {
            self.ordenacion = ordenacion
        } else {
            self.ordenacion = .alfabeticamente
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
        isLoading = true

        // 1. Obtener las URLs y filtrarlas SINCRÓNICAMENTE para crear los placeholders
        let allURLs = SistemaArchivos.sa.obtenerURLSDirectorio(coleccionURL: coleccion.url)
        
        var filteredURLs = allURLs.filter { url in
            SistemaArchivosUtilidades.sau.filtrosIndexado.allSatisfy {
                $0.shouldInclude(url: url)
            }
        }
        
        //2.1 Si el sistema de archivos estan en modo arbol tambien hay que filtrar las urls que sean de colecciones (directorios)
        if self.tipoSA == .arbol {
            filteredURLs = filteredURLs.filter { url in
                !SistemaArchivosUtilidades.sau.isDirectory(elementURL: url)
            }
        }
        
        // --- ORDENAMIENTO LIGERO ---
        
        filteredURLs.sort { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
        
        let total = filteredURLs.count
        if self.scrollPosition >= total || self.scrollPosition < 0 {
//            print("⚠️ Scroll position fuera de rango. Reiniciando a 0.")
            self.scrollPosition = 0
        }
        
        elementos = (0..<total).map { _ in
            ElementoPlaceholder()
        }
        
        // 2. Scroll automático (lo activará la vista si isPerformingAutoScroll = true)
        self.isPerformingAutoScroll = true

        // 3. Indexado asincrónico y centrado
        Task.detached { [weak self] in
            guard let self = self else { return }
            
            let centro = await MainActor.run { self.scrollPosition }
            let urls: [URL] = await MainActor.run { filteredURLs }
            let indices = Algoritmos().generarIndicesDesdeCentro(centro, total: urls.count)

            for idx in indices {
                let url = urls[idx]
                
                //2. Si no la creamos
                let elem = SistemaArchivos.sa.crearInstancia(elementoURL: url)
                await MainActor.run {
                    var nuevos = self.elementos
                    nuevos[idx] = elem
//                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        self.elementos = nuevos
//                    }
                }
            }

            await MainActor.run {
                self.isLoading = false
                self.elementosCargados = true
            }
        }

    }
    
    
    func reiniciarCarga() {
        elementosCargados = false
    }
    
    func resetScrollState() {
        isPerformingAutoScroll = false
    }

    
    private var scrollDebounceWorkItem: DispatchWorkItem?
    

    func actualizarScroll(_ nuevo: Int) {
        scrollPosition = nuevo

        scrollDebounceWorkItem?.cancel() // Cancelar debounce anterior

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            // Aquí se ejecuta solo si el scroll ha parado por 0.5s
            print("✅ Guardando scrollPosition:", nuevo)
            PersistenciaDatos().guardarAtributo(
                coleccion: self.coleccion,
                atributo: "scrollPosition",
                valor: nuevo
            )
        }

        scrollDebounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
}

