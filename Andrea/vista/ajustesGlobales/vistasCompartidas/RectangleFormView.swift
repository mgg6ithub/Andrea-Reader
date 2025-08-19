import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

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
    var esSistemaIcono: String? = nil

    // --- VARIABLES ESTADO ---
    @State private var isBouncing = false         // Estado para controlar el rebote

    // --- VARIABLES CALCULADAS ---
    var isSelected: Bool { return opcionActual == opcionSeleccionada }
    var const: Constantes { ap.constantes }
    private var iconSize: CGFloat { ap.constantes.iconSize + 20 }
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }

    var body: some View {
        VStack {
            Text(titulo)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.subheadline)
                .foregroundColor(isSelected ? tema.textColor : tema.secondaryText.opacity(0.3))

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
//                        .shadow(color: esOscuro ? .black.opacity(0.225) : .black.opacity(0.225),
//                                radius: ap.shadows ? 5 : 0,
//                                x: 0,
//                                y: ap.shadows ? 2 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    isSelected
                                        ? (tema == .dark ? Color.white : Color.black)
                                        : Color.clear,
                                    lineWidth: 1.5
                                )
                        )

                    ZStack {
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: iconSize * 1.15))
                            .scaleEffect(x: 1.1, y: 1.3, anchor: .center)
                            .foregroundColor(isSelected ? Color.gray.opacity(0.8) : Color.clear)
                            .zIndex(0)
//                            .shadow(
//                                color: ap.shadows
//                                    ? (isSelected
//                                       ? (esOscuro ? .black.opacity(0.15) : .black.opacity(0.1))
//                                       : .clear)
//                                    : .clear,
//                                radius: ap.shadows
//                                ? (isSelected && esOscuro ? 0.5 : 2.5)   // 👈 radio menor si oscuro
//                                    : 0,
//                                x: 0,
//                                y: ap.shadows
//                                ? (isSelected && esOscuro ? 0.5 : 2.5)   // 👈 sombra más baja en oscuro
//                                    : 0
//                            )

                        if isCustomImage != nil {
                            ZStack {
                                Image(icono)
                                    .zIndex(1)
                                    .font(.system(size: iconSize))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(
                                        isSelected ? coloresIcono[0] : coloresIcono[0].opacity(0.5),
                                        coloresIcono.dropFirst().first ?? coloresIcono[0]
                                    )
                                
                                if let iconoDispositivo = esSistemaIcono {
                                    Image(systemName: iconoDispositivo)
                                        .zIndex(2)
                                        .font(.system(size: iconSize * 0.45))
                                        .symbolRenderingMode(.palette)
//                                        .foregroundStyle( isSelected ? tema.colorContrario : tema.colorContrario.opacity(0.5), isSelected ? .gray : .gray.opacity(0.5))
                                        .foregroundStyle(.black, .gray)
                                        .offset(x: ap.dispositivoActual.esIPad ? 17.5 : 14.5, y: ap.dispositivoActual.esIPad ? 13.5 : 11.5)
                                }
                                    
                            }
//                                .shadow(
//                                    color: ap.shadows
//                                        ? (isSelected
//                                           ? (esOscuro ? coloresIcono[0].opacity(0.5) : coloresIcono[0].opacity(0.1))
//                                           : .clear)
//                                        : .clear,
//                                    radius: ap.shadows
//                                        ? (isSelected && esOscuro ? 0.5 : 3)   // 👈 en oscuro más pequeño
//                                        : 0,
//                                    x: 0,
//                                    y: ap.shadows
//                                        ? (isSelected && esOscuro ? 1.5 : 5)   // 👈 en oscuro más bajo
//                                        : 0
//                                )
                                .symbolEffect(.bounce, value: isBouncing)
                        } else {
                            Image(systemName: icono)
                                .zIndex(1)
                                .font(.system(size: iconSize))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    isSelected ? coloresIcono[0] : coloresIcono[0].opacity(0.5),
                                    coloresIcono.dropFirst().first ?? coloresIcono[0]
                                )
//                                .shadow(
//                                    color: ap.shadows
//                                        ? (isSelected
//                                           ? (esOscuro ? coloresIcono[0].opacity(0.5) : coloresIcono[0].opacity(0.1))
//                                           : .clear)
//                                        : .clear,
//                                    radius: ap.shadows
//                                        ? (isSelected && esOscuro ? 0.5 : 3)   // 👈 en oscuro más pequeño
//                                        : 0,
//                                    x: 0,
//                                    y: ap.shadows
//                                        ? (isSelected && esOscuro ? 1.5 : 5)   // 👈 en oscuro más bajo
//                                        : 0
//                                )
                                .symbolEffect(.bounce, value: isBouncing)
                        }
                    }
                }
            }
        }
    }
}
