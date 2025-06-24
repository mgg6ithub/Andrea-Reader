
import SwiftUI

// Versión alternativa con transición más elaborada
struct HistorialColecciones: View {
    
    @Namespace private var breadcrumb
    @EnvironmentObject var pc: PilaColecciones
    @EnvironmentObject var appEstado: AppEstado1
    
    private var iconSize: CGFloat  { appEstado.constantes.iconSize }
    
    var body: some View {
        HStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    
                    if pc.colecciones.isEmpty {
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
                        .matchedGeometryEffect(id: 3123131321, in: breadcrumb)
                    }
                    else {
                        
                        Button(action: {
                            pc.sacarTodasColecciones()
                        }) {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: iconSize * 0.65))
                        }
                        
                        ForEach(Array(pc.colecciones.enumerated()), id: \.1.url) { index, coleccion in
                            
                            if pc.esColeccionActual(coleccion: coleccion) {
                                
                                ColeccionRectanguloAvanzado(
                                    textoSize: 21,
                                    colorPrimario: .primary,
                                    color: coleccion.directoryColor,
                                    isActive: true,
                                    animationDelay: Double(index) * 0.1
                                ) {
                                    Text(coleccion.name)
                                }
                                .matchedGeometryEffect(id: coleccion.url, in: breadcrumb)
                                
                            } else {
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        pc.sacarHastaEncontrarColeccion(coleccion: coleccion)
                                    }
                                }) {
                                    
                                    ColeccionRectanguloAvanzado(
                                        textoSize: 14,
                                        colorPrimario: .secondary,
                                        color: coleccion.directoryColor,
                                        isActive: false,
                                        animationDelay: Double(index) * 0.1
                                    )
                                    {
                                        Text(coleccion.name)
                                    }
                                    .matchedGeometryEffect(id: coleccion.url, in: breadcrumb)
                                    
                                }
                                .buttonStyle(ColeccionButtonStyle())
                            }
                        }
                    } //FIN ELSE empty

                }
                .padding(.horizontal)
            }
        }
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
            .font(.system(size: textoSize, weight: isActive ? .semibold : .regular))
            .foregroundColor(colorPrimario)
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
                    .spring(response: 0.7, dampingFraction: 0.8)
                    .delay(animationDelay)
                ) {
                    isVisible = true
                    scale = 1.0
                    offset = 0
                }
            }
            .onDisappear {
                withAnimation(.easeIn(duration: 0.2)) {
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

