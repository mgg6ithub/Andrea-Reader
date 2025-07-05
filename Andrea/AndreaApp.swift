

import SwiftUI

@main
struct AndreaApp: App {
    
    init() { var _ = SistemaArchivos.getSistemaArchivosSingleton }
    
    var body: some Scene {
        WindowGroup {
            AndreaAppView()
        }
    }
}
