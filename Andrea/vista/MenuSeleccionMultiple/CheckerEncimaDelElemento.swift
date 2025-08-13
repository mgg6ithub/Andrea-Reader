import SwiftUI

struct CheckerEncimaDelElemento: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    let elementoURL: URL
    let topPadding: Bool
    
    var body: some View {
        if me.seleccionMultiplePresionada {
            VStack(alignment: .center, spacing: 0) {
                let seleccionado = me.elementosSeleccionados.contains(elementoURL)
                Image(systemName: seleccionado ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: ap.constantes.iconSize * 1.5))
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .transition(.scale.combined(with: .opacity))
                    .contentTransition(.symbolEffect(.replace, options: .speed(2.25)))
            }
            .if(topPadding) { v in
                v.padding(.top, 60)
            }
            .zIndex(5)
        }
    }
}
