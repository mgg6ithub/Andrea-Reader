
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
//        let ap = AppEstado(screenWidth: 393, screenHeight: 852)
        let ap = AppEstado(screenWidth: 820, screenHeight: 1180)
        ap.temaActual = .dark
        ap.sistemaArchivos = .tradicional
        return ap
    }
}

extension MenuEstado {
    static var preview: MenuEstado {
        let me = MenuEstado()
        me.iconSize = 24
        me.fuente = .light
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
    let minIcon = 16.0
    let maxIcon = 44.0
    let recommended = 24.0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Menu") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: ap.temaActual.colorContrario, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("El menu son los iconos de arriba del todo y puedes personalizarlos como mas te guste.")
                .capaDescripcion(s: const.descripcionAjustes, c: ap.temaActual.secondaryText, pH: paddingVertical, pW: 0)
            
            //MARK: --- TAMAÑO ---
            AjustesBarraEstado(isSection: isSection)
                .padding(.bottom, 20)
            
            CirculoActivoVista(isSection: isSection, nombre: "Modificar iconos del menu", titleSize: const.descripcionAjustes, color: ap.colorActual)
            
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
            CirculoActivoVista(isSection: isSection, nombre: "Colores de los iconos", titleSize: const.descripcionAjustes, color: ap.colorActual)
            
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
                titleSize: const.descripcionAjustes,
                color: ap.colorActual
            )
            
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Tamaño")
                            .font(.headline)
                            .foregroundColor(ap.temaActual.colorContrario)
                        Spacer()
                        Text("\(Int(me.iconSize)) pt")
                            .font(.subheadline)
                            .foregroundColor(ap.temaActual.secondaryText)
                    }

                    IconSizeSlider(
                        value: $me.iconSize,
                        min: minIcon,
                        max: maxIcon,
                        recommended: recommended,
                        trackColor: ap.temaActual.colorContrario,     // base
                        fillColor: .blue,                             // progreso
                        markerColor: ap.temaActual.colorContrario,    // muesca
                        textColor: ap.temaActual.secondaryText        // “24 pt”
                    )
                    
                    Text("Escoge el tamaño que quieras para los iconos del menu.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Fuente")
                            .font(.headline)
                            .foregroundColor(ap.temaActual.colorContrario)
                        Spacer()
                        Text("\(me.fuente.displayName)")
                            .font(.subheadline)
                            .foregroundColor(ap.temaActual.secondaryText)
                    }
                    
                    HStack(spacing: paddingHorizontal) {
                        BotonBE(titulo: "UltraLight", icono: "textformat.alt", coloresIcono: [.black], opcionSeleccionada: .ultraLight, opcionActual: $me.fuente, fuente: .ultraLight)
                        Spacer()
                        BotonBE(titulo: "Thin", icono: "textformat.alt", coloresIcono: [.black], opcionSeleccionada: .thin, opcionActual: $me.fuente, fuente: .thin)
                        Spacer()
                        BotonBE(titulo: "Light", icono: "textformat.alt", coloresIcono: [.black], opcionSeleccionada: .light, opcionActual: $me.fuente, fuente: .light)
                    }
                    .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                }
                
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
        }
    }
}

struct IconSizeSlider: View {
    @Binding var value: Double
    let min: Double
    let max: Double
    let recommended: Double
    var trackColor: Color
    var fillColor: Color
    var markerColor: Color
    var textColor: Color

    // qué tan “cerca” para ocultar marcador y snap
    private let epsilon: Double = 0.5

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height

            // progreso actual 0...1
            let t = CGFloat((value - min) / (max - min))
            let xThumb = Swift.max(0, Swift.min(width, t * width))

            // posición del recomendado
            let tRec = CGFloat((recommended - min) / (max - min))
            let xRec = Swift.max(0, Swift.min(width, tRec * width))

            ZStack(alignment: .leading) {
                // Track
                Capsule().fill(trackColor.opacity(0.25)).frame(height: 4)

                // Relleno hasta el thumb
                Capsule().fill(fillColor).frame(width: Swift.max(8, xThumb), height: 4)

                // Muesca recomendada (si no estamos prácticamente en 24)
                if abs(value - recommended) > epsilon {
                    VStack(spacing: 2) {
                        Triangle()
                            .fill(markerColor.opacity(0.9))
                            .frame(width: 10, height: 6)
                            .rotationEffect(.degrees(180))
                        Rectangle()
                            .fill(markerColor.opacity(0.9))
                            .frame(width: 2, height: 12)
                        Text("\(Int(recommended)) pt")
                            .font(.caption2)
                            .foregroundColor(textColor)
                            .padding(.top, 2)
                    }
                    .padding(8) // área táctil
                    .contentShape(Rectangle())
                    .position(x: xRec, y: height/2)
                    .onTapGesture {
                        withAnimation(.easeInOut) { value = recommended }
                    }
                    .accessibilityLabel("Tamaño recomendado \(Int(recommended)) puntos")
                    .accessibilityAddTraits(.isButton)
                }

                // Thumb
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(Circle().stroke(fillColor, lineWidth: 2))
                    .frame(width: 22, height: 22)
                    .position(x: xThumb, y: height/2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { g in
                                let x = Swift.max(0, Swift.min(width, g.location.x))
                                let nt = x / width
                                value = min + Double(nt) * (max - min)
                            }
                            .onEnded { _ in
                                if abs(value - recommended) <= epsilon {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                        value = recommended
                                    }
                                }
                            }
                    )
            }
            .contentShape(Rectangle())
            // tap sobre la pista
            .onTapGesture { location in
                let x = location.x
                let nt = Swift.max(0, Swift.min(1, x / width))
                let newVal = min + Double(nt) * (max - min)
                withAnimation(.easeInOut) { value = newVal }
            }
        }
        .frame(height: 44)
    }
}

// Triángulo para la muesca
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: .init(x: rect.midX, y: rect.minY))
            p.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            p.addLine(to: .init(x: rect.minX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}

