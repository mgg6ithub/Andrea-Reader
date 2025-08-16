import SwiftUI

struct RectangleFormView<T: Equatable>: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado

    // --- PARAMETROS ---
    @State var titulo: String
    @State var icono: String
    @State var coloresIcono: [Color] // Array de colores
    var opcionSeleccionada: T                     // Valor que representa esta opción
    @Binding var opcionActual: T                  // Valor actualmente seleccionado
    var isCustomImage: Bool? = nil                // Imagen personalizada o no

    // --- VARIABLES ESTADO ---
    @State private var isBouncing = false         // Estado para controlar el rebote

    // --- VARIABLES CALCULADAS ---
    var isSelected: Bool { return opcionActual == opcionSeleccionada }
    var const: Constantes { ap.constantes }
    private var iconSize: CGFloat { ap.constantes.iconSize + 20 }

    var body: some View {
        VStack {
            Text(titulo)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.subheadline)
                .foregroundColor(isSelected ? ap.temaActual.textColor : ap.temaActual.secondaryText.opacity(0.3))

            Button(action: {
                isBouncing.toggle()
                withAnimation {
                    opcionActual = opcionSeleccionada
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: const.cAnchoRect, height: const.cAlturaRect)
                        .foregroundColor(isSelected ? Color.gray.opacity(1.0) : Color.gray.opacity(0.3))
                        .shadow(color: ap.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225),
                                radius: ap.shadows ? 5 : 0,
                                x: 0,
                                y: ap.shadows ? 2 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    isSelected
                                        ? (ap.temaActual == .dark ? Color.white : Color.black)
                                        : Color.clear,
                                    lineWidth: 1.5
                                )
                        )

                    ZStack {
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: iconSize))
                            .scaleEffect(x: 1.1, y: 1.3, anchor: .center)
                            .foregroundColor(isSelected ? Color.gray.opacity(0.8) : Color.clear)
                            .zIndex(0)
                            .shadow(color: .black.opacity(0.1),
                                    radius: ap.shadows ? 2.5 : 0,
                                    x: 0,
                                    y: ap.shadows ? 2.5 : 0)

                        if isCustomImage != nil {
                            Image(icono)
                                .zIndex(1)
                                .font(.system(size: iconSize))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    isSelected ? coloresIcono[0] : coloresIcono[0].opacity(0.6),
                                    coloresIcono.dropFirst().first ?? coloresIcono[0]
                                )
                                .shadow(
                                    color: isSelected ? coloresIcono[0].opacity(0.5) : .clear,
                                    radius: ap.shadows ? 5 : 0,
                                    x: 0,
                                    y: ap.shadows ? 5 : 0
                                )
                                .symbolEffect(.bounce, value: isBouncing)
                        } else {
                            Image(systemName: icono)
                                .zIndex(1)
                                .font(.system(size: iconSize))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    isSelected ? coloresIcono[0] : coloresIcono[0].opacity(0.6),
                                    coloresIcono.dropFirst().first ?? coloresIcono[0]
                                )
                                .shadow(
                                    color: isSelected ? coloresIcono[0].opacity(0.5) : .clear,
                                    radius: ap.shadows ? 5 : 0,
                                    x: 0,
                                    y: ap.shadows ? 5 : 0
                                )
                                .symbolEffect(.bounce, value: isBouncing)
                        }
                    }
                }
            }
        }
    }
}
