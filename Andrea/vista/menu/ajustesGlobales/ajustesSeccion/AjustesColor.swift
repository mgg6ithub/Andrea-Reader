
import SwiftUI

#Preview {
    AjustesGlobales()
//        .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667))
        .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852))
//        .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
//        .environmentObject(AppEstado(screenWidth: 834, screenHeight: 1194)
//        .environmentObject(AppEstado(screenWidth: 1024, screenHeight: 1366))
        .environmentObject(MenuEstado())
}

struct AjustesColor: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var isSection: Bool
    
    //VARIABLES PARA EL TEMA
    @State private var isColorExpanded: Bool = false
    
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Color principal")
                .capaTituloPrincipal(s: const.tituloAjustes, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("El color principal se aplicará en los iconos del menu y todas aquellas acciones que no tengan un color seleccionado. Es decir, se establecerá como predeterminado.")
                .capaDescripcion(s: const.descripcionAjustes, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Color personazalido", titleSize: const.descripcionAjustes, color: ap.colorActual)
                
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Color personalizado", descripcion: "Escoge el color que quieras.", opcionBinding: $ap.colorPersonalizado, opcionTrue: "Deshabilitar color personalizado", opcionFalse: "Habilitar color personalizado", isInsideToggle: true, isDivider: true)
                    .onChange(of: ap.colorPersonalizado) { newValue in
                        if newValue {
                            ap.colorNeutro = false
                            ap.aplicarColorDirectorio = false
                        }
                    }
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Colores mas usados")
                        .font(.system(size: ap.constantes.titleSize))
                        .foregroundColor(ap.temaActual.colorContrario)
                    
                    Text("Selecciona un color para establecerlo como principal.")
                        .font(.system(size: ap.constantes.subTitleSize))
                        .foregroundColor(ap.temaActual.secondaryText)
                    
                    // Recorrer los colores principales y crear botones circulares
                    let circleSize = const.iconSize * 2
                    let spacing: CGFloat = 10

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: circleSize, maximum: circleSize), spacing: spacing)],
                        alignment: .leading,
                        spacing: spacing
                    ) {
                        ForEach(ConstantesPorDefecto().listaColores, id: \.self) { color in
                            let current = ap.colorPersonalizadoActual == color
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
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
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
                            .foregroundColor(ap.temaActual.colorContrario)
                            .bold()
    
                        Image(systemName: "chevron.forward")
                            .font(.system(size: const.iconSize * 0.45))
                            .foregroundColor(ap.temaActual.colorContrario)
                            .bold()
                            .rotationEffect(.degrees(isColorExpanded ? 90 : 0))
                            .animation(ap.animaciones ? .interpolatingSpring(stiffness: 400, damping: 25) : .none, value: isColorExpanded)
                        
                        Spacer() // Esto asegura que se empuje hacia la izquierda
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, const.padding15)
                
                if self.isColorExpanded {
                        
                    VStack(alignment: .leading) {
                        // ColorPicker personalizado
                        ColorPicker("Escoge tu color", selection: $ap.colorPersonalizadoActual)
                            .foregroundColor(ap.temaActual.colorContrario)
                    }
                    .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                    .transition(.opacity)  // Transición de opacidad cuando se muestra o esconde
                    .animation(ap.animaciones ? .easeInOut(duration: 0.5) : .none, value: isColorExpanded)
                }
            }
            
            CirculoActivoVista(isSection: isSection, nombre: "Color automatico", titleSize: const.descripcionAjustes, color: ap.colorActual)
            
            VStack(spacing: 0) {
                VStack {
                    TogglePersonalizado(titulo: "Color neutral", descripcion: "Un color neutral que se ajustará al tema", opcionBinding: $ap.colorNeutro, opcionTrue: "Deshabilitar color neutral", opcionFalse: "Habilitar color neutral", isInsideToggle: true, isDivider: true)
                        .onChange(of: ap.colorNeutro) { newValue in
                            if newValue {
                                ap.colorPersonalizado = false
                                ap.aplicarColorDirectorio = false
                            }
                       }
                }
                
                TogglePersonalizado(titulo: "Color del directorio", descripcion: "Activa o desactiva el color del directorio", opcionBinding: $ap.aplicarColorDirectorio, opcionTrue: "Deshabilitar color del directorio", opcionFalse: "Habilitar color del directorio", isInsideToggle: true, isDivider: false)
                    .onChange(of: ap.aplicarColorDirectorio) { newValue in
                        if newValue {
                            ap.colorNeutro = false
                            ap.colorPersonalizado = false
                        }
                    }
                
            } //FIN VSTACK
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
        }
        
    }
    
}
