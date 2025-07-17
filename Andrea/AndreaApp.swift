

import SwiftUI

@main
struct AndreaApp: App {
    
    init() { var _ = SistemaArchivos.sa }
    
    var body: some Scene {
        WindowGroup {
            AndreaAppView()
        }
    }
}
