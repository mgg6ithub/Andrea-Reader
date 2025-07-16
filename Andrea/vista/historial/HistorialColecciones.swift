
import SwiftUI

// Versión alternativa con transición más elaborada
struct HistorialColecciones: View {
    
    @Namespace private var breadcrumb
    @EnvironmentObject var pc: PilaColecciones
    @EnvironmentObject var appEstado: AppEstado
    
    @State private var esVerColeccionPresionado: Bool = false
    @State private var colorTemporal: Color = .clear
    
    private var iconSize: CGFloat  { appEstado.constantes.iconSize }
    
    var body: some View {
        HStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    
                    if pc.getColeccionActual().coleccion.name == "HOME" {
                        ColeccionRectanguloAvanzado(
                            textoSize: 21,
                            colorPrimario: .primary,
                            color: Color.gray,
                            isActive: true,
                            animationDelay: Double(1.5) * 0.1
                        ) {
                            Image(systemName: "house")
                                .opacity(0.75)
                        }
                        //                        .matchedGeometryEffect(id: 3123131321, in: breadcrumb)
                    }
                    else {
                        
                        Button(action: {
                            pc.conservarSoloHome()
                        }) {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: iconSize * 0.65))
                        }
                        
                        ForEach(Array(pc.colecciones.enumerated()).filter { $0.1.coleccion.name != "HOME" }, id: \.1.coleccion.url) { index, vm in
                            
                            if pc.esColeccionActual(coleccion: vm.coleccion) {
                                
                                ColeccionRectanguloAvanzado(
                                    textoSize: 21,
                                    colorPrimario: .primary,
                                    color: vm.color,
                                    isActive: true,
                                    animationDelay: Double(index) * 0.1
                                ) {
                                    Text(vm.coleccion.name)
                                }
                                .animation(.easeInOut(duration: 0.4), value: vm.color)
                                //                                .matchedGeometryEffect(id: vm.coleccion.url, in: breadcrumb)
                                
                            } else {
                                Button(action: {
                                    //                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    pc.sacarHastaEncontrarColeccion(coleccion: vm.coleccion)
                                    //                                    }
                                }) {
                                    
                                    ColeccionRectanguloAvanzado(
                                        textoSize: 14,
                                        colorPrimario: .secondary,
                                        color: vm.color,
                                        isActive: false,
                                        animationDelay: Double(index) * 0.1
                                    )
                                    {
                                        Text(vm.coleccion.name)
                                    }
                                    //                                    .matchedGeometryEffect(id: vm.coleccion.url, in: breadcrumb)
                                    
                                }
                                .buttonStyle(ColeccionButtonStyle())
                            }
                        }
                    } //FIN ELSE empty
                    
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation { self.esVerColeccionPresionado.toggle() }
            }) {
                Text("Ver coleccion")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3), value: esVerColeccionPresionado)
            }
            .sheet(isPresented: $esVerColeccionPresionado, onDismiss: {
                // aplicar el nuevo color al cerrar la hoja
                pc.getColeccionActual().color = colorTemporal
            }) {
                MasInformacionColeccion(coleccionVM: pc.getColeccionActual(), colorTemporal: $colorTemporal)
            }
        }
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { self.appEstado.historialCargado = true }
//        }
    }
}

struct AnimatableFontModifier: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular

    // Este property hace que SwiftUI anime el cambio de `size`
    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight))
    }
}

extension View {
    func animatableFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(AnimatableFontModifier(size: size, weight: weight))
    }
}

struct ColeccionRectanguloAvanzado<Content: View>: View {
    
    let textoSize: CGFloat
    let colorPrimario: Color
    let color: Color
    let isActive: Bool
    let animationDelay: Double
    let content: () -> Content

    @State private var isVisible: Bool = false
    @State private var scale: CGFloat = 0.8
    @State private var offset: CGFloat = 20

    var body: some View {
        content()
            .animatableFont(size: textoSize, weight: isActive ? .semibold : .regular)
                .foregroundColor(colorPrimario)
                .fixedSize()               // ¡importante!
                .layoutPriority(1)         // o al menos mayor que 0
                .padding(.horizontal, 11)
                .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(isActive ? 0.4 : 0.2),
                                color.opacity(isActive ? 0.2 : 0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(color.opacity(isActive ? 0.7 : 0.4).gradient, lineWidth: isActive ? 2 : 1)
                    )
                    .shadow(color: color.opacity(0.3), radius: isActive ? 4 : 2, x: 0, y: 2)
            )
            .scaleEffect(scale)
            .offset(x: offset)
            .opacity(isVisible ? 1.0 : 0.0)
            .onAppear {
                withAnimation(
                    .spring(response: 0.3, dampingFraction: 0.5)
                    .delay(animationDelay)
                ) {
                    isVisible = true
                    scale = 1.0
                    offset = 0
                }
            }
            .onDisappear {
                withAnimation(.easeIn(duration: 0.1)) {
                    isVisible = false
                    scale = 0.8
                    offset = -20
                }
            }
    }
}


// Estilo de botón personalizado para mejor interacción
struct ColeccionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

