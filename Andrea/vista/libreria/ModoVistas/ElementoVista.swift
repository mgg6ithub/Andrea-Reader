
import SwiftUI

struct ElementoVista<Content: View>: View {
    
    let element: any ElementoSistemaArchivosProtocolo
    @ViewBuilder let content: () -> Content
    
    var body: some View {

        content()
            .contextMenu {
                Section(header: Text(element.name)) {
                    
                    Text("Mostrar informacion")
                    
                    Text("Completar lectura")
                    
                    Menu {
                        
                        
                        
                    } label: {
                        Label("Cambiar portada", systemImage: "paintbrush")
                    }
                    
                }
            }
        
    }
    
}
