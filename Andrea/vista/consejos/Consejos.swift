

import TipKit
import SwiftUI

//Al mostrar el icono 3 veces
struct ConsejoSeleccionMultiple: Tip {


    static let seMuestra: Event = Event(id: "iconoSeleccionMultiple")
    
    var title: Text {
        Text("Selección multiple")
    }

    var message: Text? {
        Text("Puedes seleccionar multiples elementos a la vez para aplicar acciones sobre ellos.")
    }

    var image: Image? {
        Image("custom.hand.grid")
    }
    
    var rules: [Rule] {
        #Rule(Self.seMuestra) {
            $0.donations.count >= 3
        }
    }
    
    var options: [TipOption] {
        return [MaxDisplayCount(1)]
    }
    
}

//Al indexar desde modeloColeccion, al borrar un elemento desde sa
struct ConsejoImportarElementos: Tip {
    
    @Parameter
    static var coleccionVacia: Bool = false
    
    @Parameter
    static var mostrarConsejoCrearColeccion: Bool = false

    
    var title: Text {
        Text("Importar archivos")
    }
    
    var message: Text? {
        Text("Presiona en el icono de la bandeja con la flecha entrando para importar archivos.")
    }
    
    var image: Image? {
        Image(systemName: "tray.and.arrow.down.fill")
    }
    
    var rules: [Rule] {
        [
            #Rule(Self.$coleccionVacia) { $0 == true },
            #Rule(Self.$mostrarConsejoCrearColeccion) { $0 == true }
        ]
    }
    
    var options: [TipOption] {
        return [MaxDisplayCount(1)]
    }

    
}

//En pilacoleccion al actualizar la coleccion actual si es home
struct ConsejoCrearColeccion: Tip {
    
    @Parameter
    static var estamosHome: Bool = false
    
    @Parameter
    static var noTieneColeccion: Bool = false
    
    var title: Text {
        Text("Crear una nueva colección")
    }

    var message: Text? {
        Text("Presiona en el icono de la carpeta con un plus para crear una nueva colección.")
    }

    var image: Image? {
        Image(systemName: "folder.fill.badge.plus")
    }
    
    var rules: [Rule] {
        [
            #Rule(Self.$estamosHome) { $0 == true },
            #Rule(Self.$noTieneColeccion) { $0 == true }
        ]
    }
    
}

struct ConsejoSmartSorting: Tip {
    
    @Parameter
    static var menuAbierto: Bool = false
    
    var title: Text {
        Text("Smart Sorting")
    }

    var message: Text? {
        Text("Utiliza regex para renombrar y reordenar tu coleccion con un solo click.")
    }

    var image: Image? {
        Image(systemName: "brain.fill")
    }
    
    var rules: [Rule] {
        [
            #Rule(Self.$menuAbierto) { $0 == true }
        ]
    }
    
    var actions: [Action] {
        return [
            .init(id: "learn", title: "Más información", perform: {
                if let url = URL(string: "https://www.youtube.com/watch?v=-Uo38dWXGt8&list=RDMM&start_radio=1&rv=Oqgkg19yWEA") {
                    UIApplication.shared.open(url)
                }
            })
        ]
    }
    
//    var options: [TipOption] {
//        return [MaxDisplayCount(1)]
//    }
    
}

