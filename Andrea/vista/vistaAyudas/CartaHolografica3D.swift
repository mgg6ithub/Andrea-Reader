import SwiftUI

struct CartaHolografica3D: View {
    
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    let elemento: any ElementoSistemaArchivosProtocolo
    
    var archivo: Archivo {
        if let archivo = elemento as? Archivo {
            return archivo
        } else {
            return Archivo()
        }
    }
    
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @State private var mostrarMiniatura = false
    
    @State var vertical: Double = 0
    @State var horizontal: Double = 0
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.3), value: ap.vistaPrevia)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) { ap.vistaPrevia = false }
                }
            
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                // Carta con efecto holográfico
                ZStack {
                    // Imagen base
                    if let img = viewModel.miniatura {
                        Image(uiImage: img)
                            .resizable()
                            .frame(width: 320, height: 450)
                            .clipped()
                            .scaleEffect(mostrarMiniatura ? 1 : 1.05)
                            .opacity(mostrarMiniatura ? 1 : 0)
                            .animation(.easeOut(duration: 0.25), value: mostrarMiniatura)
                    } else {
                        ProgressView()
                            .frame(width: 320, height: 450)
                    }
                    
                    // Efecto de reflejo holográfico superpuesto
                    holographicReflection()
                }
                .mask(RoundedRectangle(cornerRadius: 24)) // Máscara aplicada al conjunto
                .rotation3DEffect(.degrees(vertical), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(.degrees(horizontal), axis: (x: 0, y: 1, z: 0))
                .shadow(color: .white.opacity(0.3), radius: 20, x: horizontal * 2, y: vertical * 2)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
                                vertical = min(max(Double(value.translation.height / 10), -25), 25)
                                horizontal = min(max(Double(value.translation.width / 10), -20), 20)
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                vertical = 0
                                horizontal = 0
                            }
                        }
                )
                .onAppear {
                    viewModel.loadThumbnail(color: vm.color, for: archivo)
                    withAnimation(.easeOut(duration: 0.5)) {
                        mostrarMiniatura = true
                    }
                }
                .onDisappear {
                    viewModel.unloadThumbnail(for: archivo)
                }
                
                Spacer()
            }
        }
    }
    
    // Efecto de reflejo holográfico mejorado
    func holographicReflection() -> some View {
        ZStack {
            // Reflejo principal que se mueve
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(0.8),
                            .cyan.opacity(0.6),
                            .blue.opacity(0.4),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .offset(x: horizontal * 8, y: vertical * 8)
                .blur(radius: 15)
                .opacity(min(sqrt(vertical * vertical + horizontal * horizontal) / 15, 0.7))
            
            // Reflejo secundario más sutil
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.4),
                            .purple.opacity(0.3),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 150, height: 300)
                .rotationEffect(.degrees(45 + horizontal * 2))
                .offset(x: horizontal * -4, y: vertical * -4)
                .blur(radius: 20)
                .opacity(min(sqrt(vertical * vertical + horizontal * horizontal) / 20, 0.5))
            
            // Brillo en los bordes
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.6),
                            .cyan.opacity(0.4),
                            .clear,
                            .purple.opacity(0.3),
                            .white.opacity(0.6)
                        ],
                        startPoint: UnitPoint(x: 0.5 + horizontal/40, y: 0.5 + vertical/40),
                        endPoint: UnitPoint(x: 0.5 - horizontal/40, y: 0.5 - vertical/40)
                    ),
                    lineWidth: 2
                )
                .frame(width: 320, height: 450)
                .opacity(min(sqrt(vertical * vertical + horizontal * horizontal) / 10, 0.8))
        }
        .blendMode(.screen) // Modo de mezcla para efecto holográfico
    }
}
