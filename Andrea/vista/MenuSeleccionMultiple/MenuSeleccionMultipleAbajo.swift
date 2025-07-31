

import SwiftUI

struct MenuSeleccionMultipleAbajo: View {
    
    @EnvironmentObject var me: MenuEstado
    
    @State var eliminarPresionado: Bool = false
    
    private let constantes = ConstantesPorDefecto()
    
    var body: some View {
        
        HStack(spacing: 40) {
            
            AccionSeleccionMultiple(nombreBoton: "Completar") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Mover") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Copiar") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Favoritos") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Proteger") { print("completando lectura") }
            
            Spacer()
            
            MenuAcciones()
            
            Button("Eliminar", role: .destructive) {
                eliminarPresionado.toggle()
            }
            .foregroundColor(Color.red)
            
        }
        .opacity(me.elementosSeleccionados.count > 0 ? 1.0 : 0.2)
        .padding(.horizontal, constantes.horizontalPadding)
        .confirmationDialog(
            "¿Estás seguro de que quieres borrar \(me.elementosSeleccionados.count)?",
            isPresented: $eliminarPresionado, // <- o el tuyo
            titleVisibility: .visible
        ) {
            Button("Borrar", role: .destructive) {
                me.eliminarTodosLosSeleccionados()
            }
            Button("Cancelar", role: .cancel) {}
        }
        
    }
}


struct AccionSeleccionMultiple: View {
    
    @EnvironmentObject var me: MenuEstado
    
    let nombreBoton: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(nombreBoton)
//                .opacity(me.elementosSeleccionados.count > 0 ? 1.0 : 0.2)
        }
    }
}


struct MenuAcciones: View {
    var body: some View {
        Menu {
            AccionSeleccionMultiple(nombreBoton: "Completar") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Mover") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Copiar") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Favoritos") { print("completando lectura") }
            AccionSeleccionMultiple(nombreBoton: "Proteger") { print("completando lectura") }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
}
