

import SwiftUI

struct MasInformacionColeccion: View {
    
    @ObservedObject var coleccionVM: ModeloColeccion
    @Binding var colorTemporal: Color

    var body: some View {
        VStack(spacing: 20) {
            
            Text(coleccionVM.coleccion.name)
                .font(.title)
            
            ColorPicker("Selecciona un color", selection: $colorTemporal)
                .padding()
                .onChange(of: colorTemporal) { nuevoColor in
                    print("Has seleccionado color: \(nuevoColor)")
                    // --- VISTA ---
//                    coleccionVM.color = nuevoColor
                    
                    // --- PERSISTENCIA ---
                    PersistenciaDatos().guardarAtributoColeccion(coleccion: coleccionVM.coleccion, atributo: "color", valor: nuevoColor)
                }
            
            RoundedRectangle(cornerRadius: 10)
                .fill(colorTemporal)
                .frame(height: 100)
                .padding()
        }
        .padding()
    }
}


