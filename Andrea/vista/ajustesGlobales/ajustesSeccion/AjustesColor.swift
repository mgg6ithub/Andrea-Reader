
import SwiftUI

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

struct AjustesColor: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var isSection: Bool
    
    //VARIABLES PARA EL TEMA
    @State private var isColorExpanded: Bool = false
    
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Color principal")
                .capaTituloPrincipal(s: const.tituloAjustes, c: tema.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Hay tres opciones generales para seleccionar un color.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            TituloInformacion(titulo: "Personalizado", isSection: isSection)
            
            Text("Escoge un color fijo que se usará en iconos y acciones por defecto. El color que elijas aquí se aplicará de manera global, independientemente del tema o la colección.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
                
            VStack(spacing: 0) {
                TogglePersonalizado(
                    titulo: "Color personalizado",
                    descripcion: "Escoge el color que quieras.",
                    opcionBinding: Binding(
                        get: { ap.ajusteColorSeleccionado == .colorPersonalizado },
                        set: { isOn in
                            if isOn { ap.ajusteColorSeleccionado = .colorPersonalizado }
                        }
                    ),
                    opcionTrue: "Deshabilitar color personalizado",
                    opcionFalse: "Habilitar color personalizado",
                    isInsideToggle: true,
                    isDivider: true
                )
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Colores mas usados")
                        .font(.system(size: ap.constantes.titleSize))
                        .foregroundColor(tema.colorContrario)
                    
                    Text("Selecciona un color para establecerlo como principal.")
                        .font(.system(size: ap.constantes.subTitleSize))
                        .foregroundColor(tema.secondaryText)
                    
                    // Recorrer los colores principales y crear botones circulares
                    let circleSize = const.iconSize * 2
                    let spacing: CGFloat = 10

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: circleSize, maximum: circleSize), spacing: spacing)],
                        alignment: .leading,
                        spacing: spacing
                    ) {
                        ForEach(ConstantesPorDefecto().listaColores, id: \.self) { color in
                            let current = colorsEqual(ap.colorPersonalizadoActual, color)
                            Button {
                                ap.colorPersonalizadoActual = color
                            } label: {
                                Circle()
                                    .fill(color.gradient)
                                    .opacity(current ? 1 : 0.3)
                                    .frame(width: circleSize, height: circleSize)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                } // FIN VSTACK COLORES MAS USADOS
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows, pV: false)
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    if ap.animaciones {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.isColorExpanded.toggle()
                        }
                    }
                    else {
                        self.isColorExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 5) {
                        Text("Paleta de colores")
                            .font(.system(size: const.descripcionAjustes))
                            .foregroundColor(tema.colorContrario)
                            .bold()
    
                        Image(systemName: "chevron.forward")
                            .font(.system(size: const.iconSize * 0.45))
                            .foregroundColor(tema.colorContrario)
                            .bold()
                            .rotationEffect(.degrees(isColorExpanded ? 90 : 0))
                            .animation(ap.animaciones ? .interpolatingSpring(stiffness: 400, damping: 25) : .none, value: isColorExpanded)
                        
                        Spacer() // Esto asegura que se empuje hacia la izquierda
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, const.padding15)
                
                if self.isColorExpanded {
                        
                    VStack(alignment: .leading) {
                        // ColorPicker personalizado
                        ColorPicker("Escoge tu color", selection: $ap.colorPersonalizadoActual)
                            .foregroundColor(tema.colorContrario)
                    }
                    .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows, pV: false)
                    .animacionVStackSaliente(isExpanded: isColorExpanded, animaciones: ap.animaciones)
                }
            }
            
            DividerDentroSeccion(pH: 25, pV: 25)
            
            TituloInformacion(titulo: "Neutral", isSection: isSection)
            
            Text("Un color adaptable que cambia según el tema actual. Al activar esta opción, los iconos y acciones usarán el color adaptado al tema actual.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            VStack(spacing: 0) {
                // MARK: - Color neutral
                TogglePersonalizado(
                    titulo: "Color neutral",
                    opcionBinding: Binding(
                        get: { ap.ajusteColorSeleccionado == .colorNeutral },
                        set: { isOn in
                            if isOn { ap.ajusteColorSeleccionado = .colorNeutral }
                        }
                    ),
                    opcionTrue: "Deshabilitar color neutral",
                    opcionFalse: "Habilitar color neutral",
                    isInsideToggle: true,
                    isDivider: false
                )
                
            } //FIN VSTACK
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows, pV: false)
            
            DividerDentroSeccion(pH: 25, pV: 25)
            
//            Text("Colección")
//                .capaDescripcion(s: const.descripcionAjustes, c: tema.colorContrario, pH: 0, pW: 0, b: true)
//                .underline(isSection, color: ap.colorActual)
//                .padding(.bottom, 8)
            
            HStack(spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "info.bubble")
                        .foregroundColor(tema.colorContrario)
                        .font(.system(size: const.iconSize * 0.55,
                                          weight: isSection ? .bold : .regular))
                    
                    Text("Colección")
                        .capaDescripcion(s: const.descripcionAjustes, c: tema.colorContrario, pH: 0, pW: 0, b: true)
                        .underline(isSection, color: ap.colorActual)
                }

                Text("Recomendado")
                    .font(.system(size: const.descripcionAjustes * 0.55))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 6)
            
            Text("Usa el color propio de cada colección como color principal. Al activar esta opción, los iconos y acciones usarán el color de la colección en la que te encuentres.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            VStack(spacing: 0) {
                // MARK: - Color del directorio (colección)
                TogglePersonalizado(
                    titulo: "Color de la colección",
                    opcionBinding: Binding(
                        get: { ap.ajusteColorSeleccionado == .colorColeccion },
                        set: { isOn in
                            if isOn { ap.ajusteColorSeleccionado = .colorColeccion }
                        }
                    ),
                    opcionTrue: "Deshabilitar color del directorio",
                    opcionFalse: "Habilitar color del directorio",
                    isInsideToggle: true,
                    isDivider: false
                )
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows, pV: true)
        }
        
    }
    
}
