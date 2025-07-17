
//MARK: --- SINGLETON ---

import SwiftUI

@MainActor
class PilaColecciones: ObservableObject {

    //MARK: --- Instancia singleton totalmente segura, lazy, thread-safe ---
    static let pilaColecciones: PilaColecciones = PilaColecciones()

    //MARK: --- Variables publicas para las vistas ---
    @Published private(set) var colecciones: [ColeccionViewModel] = []
    @Published private(set) var coleccionActualVM: ColeccionViewModel?

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
                    return ColeccionViewModel(coleccion)
                } else {
                    return nil
                }
            }

            if let home = cache[self.homeURL]?.coleccion {
                let homeVM = ColeccionViewModel(home)

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
    private func actualizarColeccionActual() {
        coleccionActualVM = colecciones.last ?? {
            if let home = sa.cacheColecciones[homeURL]?.coleccion {
                return ColeccionViewModel(home)
            } else {
                fatalError("No se pudo obtener la colección HOME")
            }
        }()
    }

    /**
     Agrega una colección al final de la pila si no es igual a la actual.

     - Parameter coleccion: La colección a agregar.
     */
    public func meterColeccion(coleccion: Coleccion) {
        let vm = ColeccionViewModel(coleccion)
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
    public func getColeccionActual() -> ColeccionViewModel {
        coleccionActualVM ?? ColeccionViewModel(
            sa.cacheColecciones[self.homeURL]?.coleccion
            ?? Coleccion(
                directoryName: "Inicio",
                directoryURL: homeURL,
                creationDate: .now,
                modificationDate: .now,
                elementList: []
            )
        )
    }

    /**
     Retorna la colección actual como propiedad.
     */
    public var currentVM: ColeccionViewModel {
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


