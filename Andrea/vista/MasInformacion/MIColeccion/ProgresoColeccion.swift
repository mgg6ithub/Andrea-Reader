

import SwiftUI

struct ProgresoColeccion: View {
    
    @ObservedObject var vm: ModeloColeccion
    @Binding var pantallaCompleta: Bool
    let escala: CGFloat
    
    var body: some View {
        Text("test")
    }
}
