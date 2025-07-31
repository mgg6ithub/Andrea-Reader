
import SwiftUI

struct HistorialColecciones: View {
    @Namespace private var breadcrumb
    @EnvironmentObject var pc: PilaColecciones
    @EnvironmentObject var appEstado: AppEstado

    @State private var esVerColeccionPresionado: Bool = false
    @State private var colorTemporal: Color = .clear
    @State private var primeraCarga: Bool = true

    private var iconSize: CGFloat { appEstado.constantes.iconSize }

    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    if pc.getColeccionActual().coleccion.nombre == "HOME" {
                        ColeccionRectanguloAvanzado(
                            textoSize: 21,
                            colorPrimario: appEstado.temaActual.textColor,
                            color: Color.gray,
                            isActive: true,
                            horizontalPadding: 11,
                            animationDelay: delay(0)
                        ) {
                            HStack(spacing: 10) {
                                Image(systemName: "house").opacity(0.75)
                                
                                Text("Home")
                                    .font(.system(size: 20))
                                    .bold()
                            }
                        }
                        .padding(.trailing, 4)
                        
                    } else {
                        Button(action: {
                            pc.conservarSoloHome()
                        }) {
                            ColeccionRectanguloAvanzado(
                                textoSize: 14,
                                colorPrimario: appEstado.temaActual.textColor,
                                color: Color.gray,
                                isActive: false,
                                horizontalPadding: 11,
                                animationDelay: delay(0)
                            ) {
                                Image(systemName: "house").opacity(0.75)
                            }
                        }
                        .padding(.trailing, 4)
                        
                        let coleccionesFiltradas = pc.colecciones.filter { $0.coleccion.nombre != "HOME" }

                        ForEach(Array(coleccionesFiltradas.enumerated()), id: \.element.coleccion.url) { index, vm in
                            Group {
                                if pc.esColeccionActual(coleccion: vm.coleccion) {
                                    HStack(spacing: 5) {
                                        Image(systemName: "chevron.forward")
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                            .transition(.opacity.combined(with: .scale)) // animación al aparecer/desaparecer
                                            .animation(.easeInOut(duration: 1.5), value: pc.getColeccionActual().coleccion)
                                        
                                        ColeccionRectanguloAvanzado(
                                            textoSize: 21,
                                            colorPrimario: appEstado.temaActual.textColor,
                                            color: vm.color,
                                            isActive: true,
                                            horizontalPadding: 11,
                                            animationDelay: delay(Double(index))
                                        ) {
                                            Text(vm.coleccion.nombre)
                                        }
                                    }
                                } else {
                                    Button(action: {
                                        pc.sacarHastaEncontrarColeccion(coleccion: vm.coleccion)
                                    }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "chevron.forward")
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray.opacity(0.8))
                                                .transition(.opacity.combined(with: .scale)) // animación al aparecer/desaparecer
                                                .animation(.easeInOut(duration: 1.5), value: pc.getColeccionActual().coleccion)
                                            
                                            ColeccionRectanguloAvanzado(
                                                textoSize: 14,
                                                colorPrimario: appEstado.temaActual.secondaryText,
                                                color: vm.color,
                                                isActive: false,
                                                horizontalPadding: 11,
                                                animationDelay: delay(Double(index))
                                            ) {
                                                Text(vm.coleccion.nombre)
                                            }
                                        }
                                        .padding(.trailing, 4)
                                    }
                                    .buttonStyle(ColeccionButtonStyle())
                                }
                            }
                        }
                    }
                }
                .padding(.leading, 3.5)
            }

            Spacer()

            if pc.getColeccionActual().coleccion.nombre != "HOME" {
                Button(action: {
                    
                    self.colorTemporal = pc.getColeccionActual().color
                    
                    if appEstado.animaciones {
                        withAnimation {
                            esVerColeccionPresionado.toggle()
                        }
                    } else {
                        esVerColeccionPresionado.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
//                        if let tiempo = pc.getColeccionActual().tiempoCarga {
//                            Text("⏱ Carga en \(String(format: "%.2f", tiempo)) segundos")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                                .padding(.top, 4)
//                        }
                        Image(systemName: "info.circle")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(appEstado.temaActual.secondaryText)
                            .font(.system(size: 16))
                            .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)

                        Text("Ver colección")
                            .font(.system(size: 14))
                            .foregroundColor(appEstado.temaActual.secondaryText)
                            .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)
                    }
                }
                .sheet(isPresented: $esVerColeccionPresionado, onDismiss: {
                    pc.getColeccionActual().color = colorTemporal //Al cerrar asignamos el color seleccionado
                }) {
                    MasInformacionColeccion(coleccionVM: pc.getColeccionActual(), colorTemporal: $colorTemporal)
                }
                .padding(.trailing, 2.5)
            }
        }
        .onAppear {
            // Desactivamos primeraCarga luego de un breve delay para evitar lag inicial
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.linear(duration: 0.15)) {
                    primeraCarga = false
                }
            }
        }
    }

    private func delay(_ index: Double) -> Double {
        if primeraCarga { return 0 }
        let hayMasDeUna = pc.colecciones.count > 1
        return appEstado.animaciones && hayMasDeUna ? index * 0.1 : 0
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
    let horizontalPadding: CGFloat
    let animationDelay: Double
    let content: () -> Content
    
    @EnvironmentObject var appEstado: AppEstado
    @State private var isVisible: Bool = false
    @State private var scale: CGFloat = 0.8
    @State private var offset: CGFloat = 20

    var body: some View {
        content()
            .animatableFont(size: textoSize, weight: isActive ? .semibold : .regular)
            .foregroundColor(colorPrimario)
            .fixedSize()
            .layoutPriority(1)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(isActive ? 0.4 : 0.2),
                            color.opacity(isActive ? 0.2 : 0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(color.opacity(isActive ? 0.7 : 0.4).gradient, lineWidth: isActive ? 2 : 1)
                    )
                    .shadow(color: color.opacity(0.275), radius: isActive ? 4 : 2, x: 0, y: 2)
            )
            .scaleEffect(scale)
            .offset(x: offset)
            .opacity(isVisible ? 1.0 : 0.0)
            .onAppear {
                if appEstado.animaciones {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(animationDelay)) {
                        isVisible = true
                        scale = 1.0
                        offset = 0
                    }
                } else {
                    isVisible = true
                    scale = 1.0
                    offset = 0
                }
            }
            .onDisappear {
                if appEstado.animaciones {
                    withAnimation(.easeIn(duration: 0.1)) {
                        isVisible = false
                        scale = 0.8
                        offset = -20
                    }
                } else {
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

