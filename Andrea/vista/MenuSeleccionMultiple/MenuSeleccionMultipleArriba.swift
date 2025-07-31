

import SwiftUI

struct MenuSeleccionMultipleArriba: View {
    
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    private let constantes = ConstantesPorDefecto()
    
    var body: some View {
        HStack(spacing: 15) {
            
            Text("\(vm.elementos.count) elementos")
            
            if !me.elementosSeleccionados.isEmpty {
                withAnimation(.easeOut(duration: 1.5)) {
                    Text("\(me.elementosSeleccionados.count) seleccionados")
                }
            }
            
            Spacer()
            
//            HStack(spacing: 0) {
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
    //                    .font(.subheadline)
                    
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
//            }

        }
        .padding(.horizontal, constantes.horizontalPadding)
    }
}
