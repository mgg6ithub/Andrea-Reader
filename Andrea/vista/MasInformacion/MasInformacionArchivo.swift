

import SwiftUI

struct MasInformacionArchivo: View {
    
    @ObservedObject var vm: ModeloColeccion
    
    let elemento: any ElementoSistemaArchivosProtocolo
    
    var body: some View {
        
        Text(elemento.nombre)
        
    }
    
}
