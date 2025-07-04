import SwiftUI

@MainActor
class PilaColecciones: ObservableObject {

    private static let pilaColeccionesQueue = DispatchQueue(label: "com.miApp.pilaColecciones")
    private static var pilaColecciones: PilaColecciones? = nil

    private(set) var coleccionHomeURL: URL = SistemaArchivosUtilidades.getSistemaArchivosUtilidadesSingleton.rootDirectory

    @Published private(set) var colecciones: [ColeccionViewModel] = []
    
    @Published private(set) var coleccionActualVM: ColeccionViewModel?

    private let sa: SistemaArchivos = SistemaArchivos.getSistemaArchivosSingleton

    private init() {
        self.cargarPila()
        
        // Inicializar coleccionActualVM tras cargar la pila
        actualizarColeccionActual()
    }

    public static var getPilaColeccionesSingleton: PilaColecciones {
        return pilaColeccionesQueue.sync {
            if pilaColecciones == nil {
                pilaColecciones = PilaColecciones()
            }
            return pilaColecciones!
        }
    }

    public func cargarPila() {
        let coleccionHomeURLStripped = self.coleccionHomeURL.deletingLastPathComponent()

        if let pilaGuardada = UserDefaults.standard.array(forKey: ConstantesPorDefecto().pilaColeccionesClave) as? [String] {
            let coleccionesGuardadas: [URL] = pilaGuardada.compactMap { col in
                let absolutaURL = coleccionHomeURLStripped.appendingPathComponent(col)
                return ManipulacionCadenas().agregarPrivate(absolutaURL)
            }

            let cache = sa.cacheColecciones

            self.colecciones = coleccionesGuardadas.compactMap { url in
                cache[url]?.coleccion
            }.map { coleccion in
                ColeccionViewModel(coleccion)
            }
        }
    }

    public func guardarPila() {
        let coleccionHomeURLStripped = self.coleccionHomeURL.deletingLastPathComponent().path

        let rutasRelativas = self.colecciones.map { vm in
            let normalizarURL = ManipulacionCadenas().normalizarURL(vm.coleccion.url).path
            return normalizarURL.replacingOccurrences(of: coleccionHomeURLStripped, with: "").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }
        UserDefaults.standard.set(rutasRelativas, forKey: ConstantesPorDefecto().pilaColeccionesClave)
    }
    
    private func actualizarColeccionActual() {
        coleccionActualVM = colecciones.last ?? {
            if let home = sa.cacheColecciones[coleccionHomeURL]?.coleccion {
                return ColeccionViewModel(home)
            } else {
                fatalError("No se pudo obtener la colección HOME")
            }
        }()
    }

    public func meterColeccion(coleccion: Coleccion) {
        let vm = ColeccionViewModel(coleccion)
        if colecciones.last?.coleccion == coleccion {
            return
        }
        colecciones.append(vm)
        actualizarColeccionActual()
        guardarPila()
        ThumbnailService.shared.clearCache()
    }

    public func sacarColeccion() {
        _ = colecciones.popLast()
        actualizarColeccionActual()
        guardarPila()
        ThumbnailService.shared.clearCache()
    }

    public func getColeccionActual() -> ColeccionViewModel {
        coleccionActualVM ?? ColeccionViewModel(sa.cacheColecciones[self.coleccionHomeURL]?.coleccion
           ?? Coleccion(directoryName: "Inicio", directoryURL: coleccionHomeURL, creationDate: .now, modificationDate: .now, elementList: []))
    }

    public var currentVM: ColeccionViewModel {
        getColeccionActual()
    }

    public func esColeccionActual(coleccion: Coleccion) -> Bool {
        return self.getColeccionActual().coleccion == coleccion
    }

    public func sacarHastaEncontrarColeccion(coleccion: Coleccion) {
        while let ultima = colecciones.last {
            if ultima.coleccion == coleccion {
                actualizarColeccionActual()
                guardarPila()
                ThumbnailService.shared.clearCache()
                break
            }
            colecciones.removeLast()
        }
    }
}


