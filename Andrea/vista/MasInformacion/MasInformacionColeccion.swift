

import SwiftUI

struct MasInformacionColeccion: View {
    
    @ObservedObject var coleccionVM: ModeloColeccion
    @Binding var colorTemporal: Color

    var body: some View {
        VStack(spacing: 20) {
            
            Text(coleccionVM.coleccion.nombre)
                .font(.title)
            
            ColorPicker("Selecciona un color", selection: $colorTemporal)
                .padding()
                .onChange(of: colorTemporal) {
                    // --- VISTA ---
                    withAnimation(.spring(duration: 0.25)) { coleccionVM.coleccion.color = colorTemporal }
                    
                    // --- PERSISTENCIA ---
                    PersistenciaDatos().guardarDatoElemento(url: coleccionVM.coleccion.url, atributo: "color", valor: colorTemporal)
                }
            
            RoundedRectangle(cornerRadius: 10)
                .fill(colorTemporal)
                .frame(height: 100)
                .padding()
        }
        .padding()
    }
}


