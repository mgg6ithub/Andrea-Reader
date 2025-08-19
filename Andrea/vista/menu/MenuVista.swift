import SwiftUI

extension View {
    /// Aplica el fondo según el estilo elegido.
    @ViewBuilder
    func fondoMenu(_ estilo: EnumFondoMenu,
                   enabled: Bool,          // ← activo global (me.fondoMenu)
                   desactivar: Bool,       // ← desactivar para un caso concreto (izquierda)
                   color: Color,
                   opacidad: CGFloat,
                   pH: CGFloat = 3,
                   pV: CGFloat = 3,
                   isActive: Bool = false) -> some View {
        if !enabled || desactivar {
            self
        } else {
            switch estilo {
            case .liquido:
                self.fondoBotonGlass(pH: pH, pV: pV, isActive: isActive, color: color.opacity(opacidad))
            case .metalico:
                self.fondoBotonMetalDark(pH: pH, pV: pV, isActive: isActive, color: color.opacity(opacidad))
            case .transparente:
                self.fondoBoton1(pH: pH, pV: pV, isActive: isActive, color: color.opacity(opacidad))
            }
        }
    }
}


struct MenuVista: View {
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    @State private var menuCentroWidth: CGFloat = 0
    
    private var colorFondo: Color { ap.temaResuelto.fondoMenus }
    let opacidad: CGFloat = 0.65
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                    let desactivarFondo =
                        (ap.sistemaArchivos == .tradicional && !me.iconoMenuLateral && !me.iconoFlechaAtras) ||
                        (ap.sistemaArchivos == .tradicional && !me.iconoMenuLateral && pc.getColeccionActual().coleccion.nombre == "HOME")
                    
                    MenuIzquierda()
                        .fondoMenu(me.colorFondoMenu,
                           enabled: me.fondoMenu,          // ← solo si está activado
                           desactivar: desactivarFondo,     // ← desactivar en izquierda según condición
                           color: colorFondo,
                           opacidad: opacidad,
                           isActive: me.seleccionMultiplePresionada)
                        .padding(0)
                    Spacer()
                    MenuDerecha()
                        .fondoMenu(me.colorFondoMenu,
                           enabled: me.fondoMenu,          // ← solo si está activado
                           desactivar: false,     // ← desactivar en izquierda según condición
                           color: colorFondo,
                           opacidad: opacidad,
                           isActive: me.seleccionMultiplePresionada)
                }
                .padding(0)
                
                GeometryReader { geo in
                    MenuCentro(coleccionActualVM: pc.getColeccionActual())
                        .fondoMenu(me.colorFondoMenu,
                           enabled: me.fondoMenu,          // ← solo si está activado
                           desactivar: false,     // ← desactivar en izquierda según condición
                           color: colorFondo,
                           opacidad: opacidad,
                           isActive: me.seleccionMultiplePresionada)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .onAppear {
                            menuCentroWidth = geo.size.width
                        }
                }
            }
        }
        .frame(height: 40)
    }
}
