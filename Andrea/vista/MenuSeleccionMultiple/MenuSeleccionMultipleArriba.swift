

import SwiftUI

struct MenuSeleccionMultipleArriba: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    // --- VARIABLES CALCULADAS ---
    private let constantes = ConstantesPorDefecto()
    
    // --- ESTADO ---
    @State var isActive: Bool = true
    
    var body: some View {
        HStack(spacing: 15) {
            
            let totalElementos = vm.elementos.count
            if totalElementos > 0 {
                Text("\(totalElementos) \(totalElementos == 1 ? "elemento" : "elementos")")
                    .font(.system(size: ap.constantes.titleSize))
                    .minimumScaleFactor(0.7)
            } else {
                Text("El estante está listo, falta el primer libro.")
                    .font(.system(size: ap.constantes.subTitleSize))
                    .minimumScaleFactor(0.7)
            }
            
            let totalSeleccioandos = me.elementosSeleccionados.count
            if !me.elementosSeleccionados.isEmpty {
                HStack(spacing: 3.5) {
                    Text("\(totalSeleccioandos)")
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
                    .font(.system(size: ap.constantes.subTitleSize))
            }
            
            Button(action: {
                withAnimation { me.seleccionMultiplePresionada = false }
            }) {
                Text("Cancelar")
                    .font(.system(size: ap.constantes.subTitleSize))
                
                Image(systemName: "xmark.square.fill")
                    .font(.system(size: 25))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(ap.temaActual.colorContrario, Color.red)
            }
            .fondoBoton(pH: ConstantesPorDefecto().horizontalPadding * 0.8, pV: 5, isActive: true, color: .gray, borde: false)

        }
        .padding(.horizontal, constantes.horizontalPadding)
    }
}
