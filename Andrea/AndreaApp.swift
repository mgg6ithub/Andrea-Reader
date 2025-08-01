

import SwiftUI
import TipKit

@main
struct AndreaApp: App {
    
    init() { 
         //Creamos la instancia de TipKit en la vista padre
        var _ = SistemaArchivos.sa //Inicializamos el sistema de archivos
    }
    
    var body: some Scene {
        WindowGroup {
            AndreaAppView()
                .task {
//                    try? Tips.resetDatastore()
//                    try? Tips.configure(
//                        [   .displayFrequency(.immediate),
//                            .datastoreLocation(.applicationDefault)
//                        ]
//                    )
                    try? Tips.resetDatastore()
                    try? Tips.configure(
                        [
                            .datastoreLocation(.applicationDefault)
                        ]
                    )
                }
        }
    }
}
