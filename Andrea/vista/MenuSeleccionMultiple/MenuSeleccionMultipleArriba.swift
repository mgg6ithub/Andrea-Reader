

import SwiftUI

struct MenuSeleccionMultipleArriba: View {
    
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    private let constantes = ConstantesPorDefecto()
    
    var body: some View {
        HStack(spacing: 15) {
            
            let totalElementos = vm.elementos.count
            if totalElementos > 0 {
                Text("\(totalElementos) \(totalElementos == 1 ? "elemento" : "elementos")")
            } else {
                Text("El estante está listo, falta el primer libro.")
            }
            
            let totalSeleccioandos = me.elementosSeleccionados.count
            if !me.elementosSeleccionados.isEmpty {
                HStack(spacing: 3.5) {
//                    withAnimation(.easeOut(duration: 0.3)) {
                        Text("\(totalSeleccioandos)")
//                    }
                    Text("\(totalSeleccioandos == 1 ? "seleccionado" : "seleccionados")")
                }
            }
            
            Spacer()
            
            Button(action: {
                if !me.todosSeleccionados {
                    me.seleccionarTodos()
                } else {
                    me.deseleccionarTodos()
                }
            }) {
                Text(me.todosSeleccionados ? "Deseleccionar todos" : "Seleccionar todos")
            }
            
            Button(action: {
                withAnimation { me.seleccionMultiplePresionada = false }
            }) {
                Text("Cancelar")
                
                Image(systemName: "xmark.square.fill")
                    .font(.system(size: 25))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color.red)
            }
            .padding(5.9) // Añade relleno dentro del botón
            .background(
                RoundedRectangle(cornerRadius: 12) // Fondo con bordes redondeados
                    .fill(Color.gray.opacity(0.1)) // Cambia el color del fondo aquí
                )

        }
        .padding(.horizontal, constantes.horizontalPadding)
    }
}
