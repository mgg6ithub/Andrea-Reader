
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
    
    @State private var colorNeutral: Bool = false
    
    @State private var selectedColor: Color = Color.blue
    @State private var isColorPersonalizado: Bool = false
    
    //VARIABLES PARA EL TEMA
    @State private var isColorExpanded: Bool = false
    
    let colors: [Color] = [
        .red, .green, .blue, .yellow, .orange, .purple, .pink
    ]
  
    var const: Constantes { ap.constantes }
    private let cpd = ConstantesPorDefecto()
    
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * const.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * const.scaleFactor} // 20
    private var paddingCorto: CGFloat { cpd.paddingCorto }
    private var iconSize: CGFloat { ap.constantes.iconSize }
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
                
                Text("Color principal")
                .capaTituloPrincipal(s: const.titleSize, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("El color principal se aplicará en los iconos del menu y todas aquellas acciones que no tengan un color seleccionado. Es decir, se establecerá como predeterminado.")
                .capaDescripcion(s: const.titleSize, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Color personazalido", titleSize: const.titleSize, color: ap.temaActual.secondaryText)
                
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Color personalizado", descripcion: "Escoge el color que quieras.", opcionBinding: $isColorPersonalizado, opcionTrue: "Deshabilitar color personalizado", opcionFalse: "Habilitar color personalizado", isInsideToggle: true, isDivider: true)
                    .onChange(of: isColorPersonalizado) { newValue, _ in
                        if newValue {
                            colorNeutral = false
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
                    HStack(spacing: 15) {
                        ForEach(colors, id: \.self) { color in
                            Button(action: {
                                // Cambiar el color seleccionado
                                ap.currentColor = color
                            }) {
                                Circle()
                                    .fill(color.gradient)
                                    .frame(width: const.iconSize * 2, height: const.iconSize * 2)
                                    .overlay(
                                        Circle()
                                            .stroke(ap.temaActual == .dark ? (ap.currentColor == color ? Color.white : Color.clear) : (ap.currentColor == color ? Color.black : Color.clear), lineWidth: 1.5)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
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
                            .font(.system(size: const.titleSize))
                            .foregroundColor(ap.temaActual.colorContrario)
                            .bold()
    
                        Image(systemName: "chevron.forward")
                            .font(.system(size: const.iconSize * 0.65))
                            .foregroundColor(ap.temaActual.colorContrario)
                            .bold()
                            .rotationEffect(.degrees(isColorExpanded ? 90 : 0))
                            .animation(ap.animaciones ? .interpolatingSpring(stiffness: 400, damping: 25) : .none, value: isColorExpanded)
                        
                        Spacer() // Esto asegura que se empuje hacia la izquierda
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, paddingCorto)
                
                if self.isColorExpanded {
                        
                    VStack(alignment: .leading) {
                        // ColorPicker personalizado
                        ColorPicker("Escoge tu color", selection: $selectedColor)
                            .foregroundColor(ap.temaActual.colorContrario)
                    }
                    .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                    .transition(.opacity)  // Transición de opacidad cuando se muestra o esconde
                    .animation(ap.animaciones ? .easeInOut(duration: 0.5) : .none, value: isColorExpanded)
                }
            }
            .padding(.bottom, 15)
            
            CirculoActivoVista(isSection: isSection, nombre: "Color automatico", titleSize: const.titleSize, color: ap.temaActual.secondaryText)
            
            VStack(spacing: 0) {
                VStack {
                    TogglePersonalizado(titulo: "Color neutral", descripcion: "Un color neutral que se ajustará al tema", opcionBinding: $colorNeutral, opcionTrue: "Deshabilitar color neutral", opcionFalse: "Habilitar color neutral", isInsideToggle: true, isDivider: true)
                        .onChange(of: colorNeutral) { newValue, _ in
                            if newValue {
                                isColorPersonalizado = false
                                ap.aplicarColorDirectorio = false
                            }
                       }
                }
                
                TogglePersonalizado(titulo: "Color del directorio", descripcion: "Activa o desactiva el color del directorio", opcionBinding: $ap.aplicarColorDirectorio, opcionTrue: "Deshabilitar color del directorio", opcionFalse: "Habilitar color del directorio", isInsideToggle: true, isDivider: false)
                    .onChange(of: ap.aplicarColorDirectorio) { newValue, _ in
                        if newValue {
                            colorNeutral = false
                            isColorPersonalizado = false
                        }
                    }
                
            } //FIN VSTACK
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
        }// FIN COLOR PRINCIPAL
        .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
        
    }
    
}
