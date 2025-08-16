
import SwiftUI

//#Preview {
//    AjustesGlobales()
////        .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667))
//        .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852))
////        .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
////        .environmentObject(AppEstado(screenWidth: 834, screenHeight: 1194)
////        .environmentObject(AppEstado(screenWidth: 1024, screenHeight: 1366))
//        .environmentObject(MenuEstado())
//}

#Preview {
    AjustesGlobales()
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}


extension AppEstado {
    static var preview: AppEstado {
        let ap = AppEstado(screenWidth: 393, screenHeight: 852)
        ap.temaActual = .dark
        ap.sistemaArchivos = .tradicional
        return ap
    }
}

extension MenuEstado {
    static var preview: MenuEstado {
        let me = MenuEstado()
        me.iconSize = 24
        return me
    }
}

struct AjustesMenu: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    var isSection: Bool
    
    private let cpd = ConstantesPorDefecto()
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var esOscuro: Bool { ap.temaActual == .dark }
    
    // Rango del slider
    private let minIcon: Double = 16
    private let maxIcon: Double = 44
    // Marca recomendada al 35% del rango
    private let recommendedSize: Double = 24 // <-- recomendado fijo
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Menu") //TITULO
                .capaTituloPrincipal(s: const.titleSize, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            //                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("El menu son los iconos de arriba del todo y puedes personalizarlos como mas te guste.")
                .capaDescripcion(s: const.titleSize, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            //                .frame(maxWidth: .infinity, alignment: .leading)
            
            //MARK: --- TAMAÑO ---
            AjustesBarraEstado()
            
            CirculoActivoVista(isSection: isSection, nombre: "Modificar iconos del menu", titleSize: const.titleSize, color: ap.temaActual.secondaryText)
            
            //MARK: --- ICONOS ---
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Menu lateral", iconoEjemplo: "sidebar.trailing", opcionBinding: $me.iconoMenuLateral, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: true)
                
                TogglePersonalizado(titulo: "Flecha atras", iconoEjemplo: "arrow.backward", opcionBinding: $me.iconoFlechaAtras, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: false)
                
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            VStack(spacing: 0) {
//                TogglePersonalizado(titulo: "Seleccion multiple", iconoEjemplo: PilaColecciones.pilaColecciones.getColeccionActual().modoVista == .cuadricula ?  "custom.hand.grid" : "custom.hand.list", opcionBinding: $me.iconoSeleccionMultiple, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: false)
                
                TogglePersonalizado(titulo: "Seleccion multiple", iconoEjemplo: "custom.hand.list", opcionBinding: $me.iconoSeleccionMultiple, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: false)
                
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Notificaciones", iconoEjemplo: "notificaciones", opcionBinding: $me.iconoNoticicaciones, opcionTrue: "Deshabilitar icono", opcionFalse: "Habilitar icono", isInsideToggle: true, isDivider: false)
                
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            //MARK: --- COLORES ---
            CirculoActivoVista(isSection: isSection, nombre: "Colores de los iconos", titleSize: const.titleSize, color: ap.temaActual.secondaryText)
            
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Doble color", descripcion: "Habra dos colores por icono.", opcionBinding: $me.dobleColor, opcionTrue: "Deshabilitar opcion", opcionFalse: "Habilitar opcion", isInsideToggle: true, isDivider: false)
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Adaptar al tema", descripcion: "El color de los iconos se adaptara al tema.", opcionBinding: $me.colorAutomatico, opcionTrue: "Deshabilitar opcion", opcionFalse: "Habilitar opcion", isInsideToggle: true, isDivider: true)
                    .onChange(of: me.colorAutomatico) { newValue in
                        if newValue {
                            me.colorGris = false
                        }
                    }
                
                TogglePersonalizado(titulo: "Color gris", descripcion: "Se aplicara un color neutro.", opcionBinding: $me.colorGris, opcionTrue: "Deshabilitar opcion", opcionFalse: "Habilitar opcion", isInsideToggle: true, isDivider: false)
                    .onChange(of: me.colorGris) { newValue in
                        if newValue {
                            me.colorAutomatico = false
                        }
                    }
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            // MARK: --- TAMAÑO DE ICONOS ---
            CirculoActivoVista(
                isSection: isSection,
                nombre: "Tamaño de los iconos",
                titleSize: const.titleSize,
                color: ap.temaActual.secondaryText
            )
            
            VStack(spacing: 12) {
                HStack {
                    Text("Tamaño")
                        .font(.headline)
                        .foregroundColor(ap.temaActual.colorContrario)
                    Spacer()
                    Text("\(Int(me.iconSize)) pt")
                        .font(.subheadline)
                        .foregroundColor(ap.temaActual.secondaryText)
                }

                ZStack {
                    Slider(value: $me.iconSize, in: minIcon...maxIcon, step: 1)

                    GeometryReader { geo in
                        // Posición horizontal de la muesca para 24 pt
                        let t = CGFloat((recommendedSize - minIcon) / (maxIcon - minIcon)) // 0...1
                        let x = t * geo.size.width

                        VStack(spacing: 2) {
                            Triangle()
                                .fill(ap.temaActual.colorContrario.opacity(0.85))
                                .frame(width: 10, height: 6)
                                .rotationEffect(.degrees(180)) // punta hacia abajo

                            Rectangle()
                                .fill(ap.temaActual.colorContrario.opacity(0.85))
                                .frame(width: 2, height: 12)

                            // Etiqueta opcional
                            Text("24 pt")
                                .font(.caption2)
                                .foregroundColor(ap.temaActual.secondaryText)
                                .padding(.top, 2)
                        }
                        .padding(8) // área táctil más cómoda
                        .background(Color.clear.contentShape(Rectangle()))
                        .position(x: x, y: geo.size.height / 2)
                        .onTapGesture {
                            if me.iconSize != recommendedSize {
                                withAnimation(.easeInOut) {
                                    me.iconSize = recommendedSize
                                }
                            }
                        }
                        .accessibilityLabel("Tamaño recomendado 24 puntos")
                        .accessibilityAddTraits(.isButton)
                    }
                    // importante: NO desactivar los gestos aquí, para que el tap en la muesca funcione
                    // .allowsHitTesting(false)
                }
                .frame(height: 40)

                // Vista previa rápida
                HStack(spacing: 20) {
                    Image(systemName: "sidebar.trailing")
                    Image(systemName: "arrow.backward")
                    Image(systemName: "bell")
                }
                .font(.system(size: me.iconSize))
                .foregroundColor(ap.temaActual.colorContrario)
                
                HStack {
                    Text("Fuente")
                        .font(.headline)
                        .foregroundColor(ap.temaActual.colorContrario)
                    Spacer()
                    Text(".light")
                        .font(.subheadline)
                        .foregroundColor(ap.temaActual.secondaryText)
                }
                
                HStack(spacing: paddingHorizontal) {
                    BotonBE(titulo: "UltraLight", icono: "textformat.alt", coloresIcono: [.black], opcionSeleccionada: .on, opcionActual: $ap.modoBarraEstado, fuente: .ultraLight)
                    Spacer()
                    BotonBE(titulo: "Thin", icono: "textformat.alt", coloresIcono: [.black], opcionSeleccionada: .off, opcionActual: $ap.modoBarraEstado, fuente: .thin)
                    Spacer()
                    BotonBE(titulo: "Light", icono: "textformat.alt", coloresIcono: [.black], opcionSeleccionada: .auto, opcionActual: $ap.modoBarraEstado, fuente: .light)
                }
                .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                
            }
//            .padding(.horizontal, paddingHorizontal)
//            .padding(.vertical, paddingVertical / 1.5)
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}
