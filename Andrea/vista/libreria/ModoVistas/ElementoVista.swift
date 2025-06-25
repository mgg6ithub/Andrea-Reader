
import SwiftUI

struct ElementoVista<Content: View>: View {
    
    let element: any ElementoSistemaArchivosProtocolo
    @ViewBuilder let content: () -> Content
    
    var body: some View {

        content()
        
    }
    
}
