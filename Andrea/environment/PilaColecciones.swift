
//MARK: --- SINGLETON ---

import SwiftUI

@MainActor
class PilaColecciones: ObservableObject {

    //MARK: --- Instancia singleton totalmente segura, lazy, thread-safe ---
    static let pilaColecciones: PilaColecciones = PilaColecciones()

    //MARK: --- Variables publicas para las vistas ---
    @Published private(set) var colecciones: [ModeloColeccion] = []
    @Published private(set) var coleccionActualVM: ModeloColeccion?

    //MARK: --- Variables privadas para esta clase ---
    private(set) var homeURL: URL = SistemaArchivosUtilidades.sau.home
    private let sa: SistemaArchivos = SistemaArchivos.sa

    //MARK: --- CONSTRUCTOR PRIVADO (solo se instancia desde el singleton) ---
    private init() {
        //1
        self.cargarPila()
        
        //2
        actualizarColeccionActual()
    }

    /**
      Carga la pila de colecciones desde `UserDefaults`.
      Si alguna URL ya no existe, se omite.
      Siempre asegura que la colección HOME esté al principio de la pila.
     */
    public func cargarPila() {
        let homeURLStripped = self.homeURL.deletingLastPathComponent()

        if let pilaGuardada = UserDefaults.standard.array(forKey: ConstantesPorDefecto().pilaColeccionesClave) as? [String] {
            let coleccionesGuardadas: [URL] = pilaGuardada.compactMap { col in
                let absolutaURL = homeURLStripped.appendingPathComponent(col)
                return ManipulacionCadenas().agregarPrivate(absolutaURL)
            }

            let cache = sa.cacheColecciones

            var vistaModelos = coleccionesGuardadas.compactMap { url in
                if FileManager.default.fileExists(atPath: url.path),
                   let coleccion = cache[url]?.coleccion {
                    return ModeloColeccion(coleccion)
                } else {
                    return nil
                }
            }

            if let home = cache[self.homeURL]?.coleccion {
                let homeVM = ModeloColeccion(home)

                // Evita duplicarla si ya estaba
                if !vistaModelos.contains(where: { $0.coleccion.url == home.url }) {
                    vistaModelos.insert(homeVM, at: 0)
                } else {
                    // O si ya estaba, la mueves al principio
                    vistaModelos.removeAll(where: { $0.coleccion.url == home.url })
                    vistaModelos.insert(homeVM, at: 0)
                }
            }

            self.colecciones = vistaModelos
        }
    }
    
    public func renombrarModeloColeccion(nuevoNombre: String) {
        print("Clecciones todas")
        for coleccion in colecciones {
            print(coleccion.coleccion.nombre)
        }
    }


    /**
     Guarda la pila de colecciones en `UserDefaults` como rutas relativas.
     */
    public func guardarPila() {
        let homeURLStripped = self.homeURL.deletingLastPathComponent().path

        let rutasRelativas = self.colecciones.map { vm in
            let normalizarURL = ManipulacionCadenas().normalizarURL(vm.coleccion.url).path
            return normalizarURL
                .replacingOccurrences(of: homeURLStripped, with: "")
                .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }

        UserDefaults.standard.set(rutasRelativas, forKey: ConstantesPorDefecto().pilaColeccionesClave)
    }
    

    /**
     Establece la colección actual como la última de la pila.
     Si la pila está vacía, usa la colección HOME.
     */
    @MainActor
    private func actualizarColeccionActual() {
        // 1. Obtén la nueva VM (la última de la pila o la HOME)
        let nuevaVM: ModeloColeccion
        if let última = colecciones.last {
            nuevaVM = última
        } else if let home = sa.cacheColecciones[homeURL]?.coleccion {
            nuevaVM = ModeloColeccion(home)
        } else {
            fatalError("No se pudo obtener la colección HOME")
        }

        // 2. Asigna la nueva VM
        coleccionActualVM = nuevaVM

        // 3. Resetea su estado de carga y vuelve a cargar
        nuevaVM.reiniciarCarga()          // elementosCargados = false
        nuevaVM.elementos = []            // limpia placeholders anteriores si quieres
        Task {                            // asegúrate de llamar en MainActor
            await nuevaVM.cargarElementos()
        }
    }


    /**
     Agrega una colección al final de la pila si no es igual a la actual.

     - Parameter coleccion: La colección a agregar.
     */
    public func meterColeccion(coleccion: Coleccion) {
        
        print("Entrando en la coleccion: ", coleccion.nombre)
        print("Su URL: ", coleccion.url)
        let vm = ModeloColeccion(coleccion)
        if colecciones.last?.coleccion == coleccion {
            return
        }
        colecciones.append(vm)
        actualizarColeccionActual()
        guardarPila()
    }

    /**
     Elimina la última colección de la pila.
     */
    public func sacarColeccion() {
        _ = colecciones.popLast()
        actualizarColeccionActual()
        guardarPila()
    }

    /**
     Retorna la colección actual (última en la pila), o la colección HOME si no hay ninguna.
     */
    public func getColeccionActual() -> ModeloColeccion {
        coleccionActualVM ?? ModeloColeccion(
            sa.cacheColecciones[self.homeURL]?.coleccion
            ?? Coleccion(
                directoryName: "Inicio",
                directoryURL: homeURL,
                creationDate: .now,
                modificationDate: .now
            )
        )
    }

    /**
     Retorna la colección actual como propiedad.
     */
    public var currentVM: ModeloColeccion {
        getColeccionActual()
    }

    /**
     Verifica si una colección dada es igual a la colección actual.

     - Parameter coleccion: La colección a comparar.
     - Returns: `true` si es la colección actual, `false` en caso contrario.
     */
    public func esColeccionActual(coleccion: Coleccion) -> Bool {
        return self.getColeccionActual().coleccion == coleccion
    }

    /**
     Saca colecciones de la pila hasta que encuentra la indicada.
     Si se encuentra, la deja como actual y guarda la pila.

     - Parameter coleccion: La colección objetivo.
     */
    public func sacarHastaEncontrarColeccion(coleccion: Coleccion) {
        while let ultima = colecciones.last {
            if ultima.coleccion == coleccion {
                actualizarColeccionActual()
                guardarPila()
                break
            }
            colecciones.removeLast()
        }
    }

    /**
     Elimina todas las colecciones excepto la HOME.
     Establece la HOME como actual y guarda la pila.
     */
    public func conservarSoloHome() {
        guard !colecciones.isEmpty else { return }

        let home = colecciones.first!
        colecciones = [home]
        actualizarColeccionActual()
        guardarPila()

        // Opcional: limpiar caché de miniaturas
        // ThumbnailService.shared.clearCache()
    }

    /**
     Elimina todas las colecciones de la pila (sin guardar).
     */
    public func sacarTodasColecciones() {
        self.colecciones.removeAll()
    }
}


