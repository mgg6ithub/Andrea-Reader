import SwiftUI

struct RectangleFormView<T: Equatable>: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado

    // Parámetros externos
    @State var titulo: String
    @State var icono: String
    @State var coloresIcono: [Color] // Array de colores

    var opcionSeleccionada: T                     // Valor que representa esta opción
    @Binding var opcionActual: T                  // Valor actualmente seleccionado

    var isCustomImage: Bool? = nil                // Imagen personalizada o no

    // Estado interno
    @State private var isBouncing = false         // Estado para controlar el rebote

    // Estado calculado: está seleccionada esta opción
    var isSelected: Bool { return opcionActual == opcionSeleccionada }

    // Constantes visuales
    private var anchoConstante: CGFloat { menuEstado.anchoRectanguloSmall }
    private var altoConstante: CGFloat { menuEstado.altoRectanguloSmall }
    private var scala: CGFloat { appEstado.constantes.scaleFactor }

    private var ancho: CGFloat { appEstado.resolucionLogica == .big ? anchoConstante : anchoConstante * scala }
    private var alto: CGFloat { appEstado.resolucionLogica == .big ? altoConstante : altoConstante * scala }

    private var iconSize: CGFloat { (ConstantesPorDefecto().iconSize + 20) * scala }

    var body: some View {
        VStack {
            Text(titulo)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.subheadline)
                .foregroundColor(isSelected ? .primary : .secondary.opacity(0.3))

            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isBouncing.toggle()
                    opcionActual = opcionSeleccionada
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: ancho, height: alto)
                        .foregroundColor(isSelected ? Color.gray.opacity(1.0) : Color.gray.opacity(0.3))
                        .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225),
                                radius: appEstado.shadows ? 5 : 0,
                                x: 0,
                                y: appEstado.shadows ? 2 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    isSelected
                                        ? (appEstado.temaActual == .dark ? Color.white : Color.black)
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
                                    radius: appEstado.shadows ? 2.5 : 0,
                                    x: 0,
                                    y: appEstado.shadows ? 2.5 : 0)

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
                                    radius: appEstado.shadows ? 5 : 0,
                                    x: 0,
                                    y: appEstado.shadows ? 5 : 0
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
                                    radius: appEstado.shadows ? 5 : 0,
                                    x: 0,
                                    y: appEstado.shadows ? 5 : 0
                                )
                                .symbolEffect(.bounce, value: isBouncing)
                        }
                    }
                }
            }
//            .if(!appEstado.animaciones) { view in
//                view.buttonStyle(PlainButtonStyle())
//            }
        }
    }
}
