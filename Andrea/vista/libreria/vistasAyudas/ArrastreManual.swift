
import SwiftUI

struct ArrastreManual: ViewModifier {
    
    @Binding var elementoArrastrando: ElementoSistemaArchivos?
    @ObservedObject var viewModel: ColeccionViewModel
    var elemento: ElementoSistemaArchivos
    var index: Int

    func body(content: Content) -> some View {
        content
            .draggable(elemento) {
                Rectangle() // Puedes personalizar el preview aquí
                    .frame(width: 100, height: 100)
                    .opacity(0.3)
                    .background(Color.gray)
                    .onAppear {
                        elementoArrastrando = elemento
                    }
            }
            .dropDestination(for: ElementoSistemaArchivos.self) { items, location in
                guard let dragging = elementoArrastrando,
                      let fromIndex = viewModel.elementos.firstIndex(where: { $0.id == dragging.id }),
                      fromIndex != index else {
                    return false
                }

                withAnimation(.easeInOut) {
                    let item = viewModel.elementos.remove(at: fromIndex)
                    viewModel.elementos.insert(item, at: index)
                }

                elementoArrastrando = nil
                return true
            } isTargeted: { isOver in
                // Aquí puedes pintar una sombra si está encima
            }
    }
}
