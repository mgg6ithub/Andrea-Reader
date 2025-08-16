
import SwiftUI
import ZIPFoundation

//MARK: --- PERSISTENCIA PARA LOS AJUSTES GENERALES DE USUARIO ---
/**
 Modificacion para poder guardar enums en UserDefaults
 */
//extension UserDefaults {
//    func setEnum<T: RawRepresentable>(_ value: T, forKey key: String) where T.RawValue == String {
//        set(value.rawValue, forKey: key)
//    }
//
//    func getEnum<T: RawRepresentable>(forKey key: String, default defaultValue: T) -> T where T.RawValue == String {
//        guard let rawValue = string(forKey: key), let value = T(rawValue: rawValue) else {
//            return defaultValue
//        }
//        return value
//    }
//    
//    // Si también usas enums con Int
//    func getEnum<T: RawRepresentable>(forKey key: String, default defaultValue: T) -> T where T.RawValue == Int {
//        let rawValue = self.integer(forKey: key)
//        return T(rawValue: rawValue) ?? defaultValue
//    }
//}



//MARK: - MODELO HERENCIA PARA EL SISTEMA DE ARCHVIOS

// Extensión para cumplir con el protocolo Transferable en la clase **ElementoSistemaArchivos**
extension ElementoSistemaArchivos: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.url)
    }
}


//MARK: - VISTAS

//Modificador para agregar un shimmering a una vista concreta
extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}


//MARK: - ANIMACION TEXTO

extension View {
    /// Le pasas tu Int, internamente se convierte a Double
    func animatedProgressText1(_ intValue: Int) -> some View {
        let doubleValue = Double(intValue)
        return self.modifier(ProgressTextModifier1(value: doubleValue))
    }
}

struct ProgressTextModifier1: AnimatableModifier {
    /// Este es el valor animable
    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        Text("% \(Int(value))")
    }
}

//MARK: - BOTON FONDO
extension View {
    func fondoBoton(pH: CGFloat, pV: CGFloat, isActive: Bool, color: Color, borde: Bool) -> some View {
        self.padding(.horizontal, pH)
            .padding(.vertical, pV)
            .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        color.opacity(isActive ? 0.4 : 0.2),
                        color.opacity(isActive ? 0.2 : 0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .if(borde) { view in
                    view.overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(color.opacity(isActive ? 0.7 : 0.4).gradient, lineWidth: isActive ? 2 : 1)
                    )
                }
                .shadow(color: color.opacity(0.275), radius: isActive ? 4 : 2, x: 0, y: 2)
        )
    }
}

// MARK: - BOTON FONDO
extension View {
    func fondoBoton1(pH: CGFloat, pV: CGFloat, isActive: Bool, color: Color) -> some View {
        self.padding(.horizontal, pH)
            .padding(.vertical, pV)
            .background(
                RoundedRectangle(cornerRadius: 6) // un poco más suave
                    .fill(
                        color.opacity(isActive ? 0.48 : 0.124) // color sólido suave
                    )
                    // Sin borde
                    .shadow(
                        color: Color.black.opacity(0.08), // sombra muy suave
                        radius: 3,
                        x: 0,
                        y: 1
                    )
            )
    }
}


//MARK: - EXTENSION ANIMACION APARICION STIFFNESS
extension View {
    func aparicionStiffness(show: Binding<Bool>, delay: Double = 0.1) -> some View {
        self
            .scaleEffect(show.wrappedValue ? 1 : 0.8)
            .opacity(show.wrappedValue ? 1 : 0)
            .animation(
                .interpolatingSpring(stiffness: 100, damping: 10)
                    .delay(delay),
                value: show.wrappedValue
            )
            .onAppear {
                show.wrappedValue = true
            }
            .onDisappear {
                show.wrappedValue = false
            }
    }
}

//MARK: - EXTENSION ANIMACION APARICION BLUR
extension View {
    func aparicionBlur(show: Binding<Bool>) -> some View {
        self.opacity(show.wrappedValue ? 0.0 : 1.0)
        .scaleEffect(show.wrappedValue ? 0.95 : 1.0)
//        .offset(y: show.wrappedValue ? -10 : 0)
        .blur(radius: show.wrappedValue ? 2 : 0)
        .animation(.easeInOut(duration: 0.4), value: show.wrappedValue)
        .onAppear {
            show.wrappedValue = false
        }
        .onDisappear {
            show.wrappedValue = true
        }
    }
}



//PARA PODER PONER IF EN UNA VISTA
//ejemplo: vista.if(coindicion) { view in (hacer cosas)}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


//MARK: - --- EXTENSION PARA ADAPTAR EL TEXTO A LA VISTA ---
// t = tamaño
// a = tamaño adaptativo
// l = lineas maximas
// b = bold o no (bool)
//
extension View {
    func textoAdaptativo(t: CGFloat, a: Double, l: Int, b: Bool = false, c: Color = .primary, alig: TextAlignment, s: Bool = false, mW: CGFloat? = nil, mH: CGFloat? = nil, fAlig: Alignment = .center) -> some View {
        self.font(.system(size: t))
            .minimumScaleFactor(a)
            .lineLimit(l)
            .if(b) { v in
                v.bold()
            }
            .foregroundColor(c)
            .multilineTextAlignment(alig)
            .if(s) { v in
                v.shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
            .frame(maxWidth: mW, maxHeight: mH, alignment: fAlig)
    }
}
