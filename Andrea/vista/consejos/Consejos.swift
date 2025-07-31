

import TipKit
import SwiftUI


struct ConsejoSeleccionMultiple: Tip {

    
    var title: Text {
        Text("Selección multiple")
    }

    var message: Text? {
        Text("Puedes seleccionar multiples elementos a la vez para aplicar acciones sobre ellos.")
    }

    var image: Image? {
        Image("custom.hand.grid")
    }
    
    
}

struct ConsejoImportarElementos: Tip {
    
    @Parameter
    static var coleccionVacia: Bool = false
    
    @Parameter
    static var ultimaVezMostrado: Date = Date.distantPast
    
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
               #Rule(Self.$coleccionVacia) { $0 == true }
           ]
    }
    
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }

    
}

struct ConsejoCrearColeccion: Tip {
    
    @Parameter
    static var estamosHome: Bool = false
    
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
        [#Rule(Self.$estamosHome) { $0 == true }]
    }
    
    var options: [TipOption] {
        [Tips.MaxDisplayCount(3)]
    }
    
}
