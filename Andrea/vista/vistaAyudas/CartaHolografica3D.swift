import SwiftUI

struct CartaHolografica3D: View {
    
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    @ObservedObject var archivo: Archivo
    
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @State private var mostrarMiniatura = false
    @State private var mostrar = true
    
    @State var vertical: Double = 0
    @State var horizontal: Double = 0
    
    init(vm: ModeloColeccion, archivo: Archivo) {
        self.vm = vm
        self.archivo = archivo
    }
    
    private let imageW: CGFloat = 340
    private let imageH: CGFloat = 490
    
    @State private var selectedOption = "Aleatoria"
    let options = ["Imagen base", "Primera imagen", "Aleatoria", "Personalizada"]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial) // desenfoque real
                .ignoresSafeArea()
                
            Color.black.opacity(0.55) // capa oscura encima
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        ap.vistaPrevia = false
                    }
                }
            
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 8) {
                        ForEach(EnumTipoMiniatura.allCases, id: \.self) { option in
                            let isSel = archivo.tipoMiniatura == option
                            Label(option.title, systemImage: option.iconName)
                                .foregroundColor(isSel ? .white : .gray)
                                .font(.system(size: 14, weight: .medium))
                                .if(isSel) { v in v.bold() }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    ZStack {
                                        if isSel {
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(vm.color)
                                                .matchedGeometryEffect(id: "selector", in: namespace)
                                        }
                                    }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        archivo.tipoMiniatura = option // 👈 guardamos el enum directamente
                                    }
                                }
                        }
                    }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding(.top, 30)
                .padding(.bottom, 80)
                
                // Carta con efecto holográfico
                ZStack {
                    ZStack {
                        if let img = viewModel.miniatura {
                            Image(uiImage: img)
                                .resizable()
                                .frame(width: imageW, height: imageH)
                                .clipped()
                                .scaleEffect(mostrarMiniatura ? 1 : 1.05)
                                .opacity(mostrarMiniatura ? 1 : 0)
                                .animation(.easeOut(duration: 0.25), value: mostrarMiniatura)
                        } else {
                            ProgressView()
                                .frame(width: imageW, height: imageH)
                        }
                        
                        // Efecto de reflejo holográfico superpuesto
                        holographicReflection()
                    }
                    .mask(RoundedRectangle(cornerRadius: 24)) // 👈 solo aquí
                    
                    let tiltAmount = min(sqrt(horizontal*horizontal + vertical*vertical) / 25, 1)

                    let glowColor: Color = tiltAmount > 0.3 ? .white : vm.color

                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: tiltAmount > 0.3
                                    ? [Color.white, Color.white] // inclinado = borde blanco
                                    : [vm.color, .blue, .purple, .pink, vm.color], // reposo = holográfico
                                startPoint: UnitPoint(x: 0.5 + horizontal/40, y: 0.5 + vertical/40),
                                endPoint: UnitPoint(x: 0.5 - horizontal/40, y: 0.5 - vertical/40)
                            ),
                            lineWidth: 2
                        )
                        .frame(width: imageW, height: imageH)
                        // Glow dinámico: blanco al arrastrar, vm.color en reposo
                        .shadow(color: glowColor.opacity(0.9), radius: 20)
                        .shadow(color: glowColor.opacity(0.7), radius: 40)
                        .shadow(color: glowColor.opacity(0.4), radius: 60)


                }
                .rotation3DEffect(.degrees(vertical), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(.degrees(horizontal), axis: (x: 0, y: 1, z: 0))
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
                .onChange(of: archivo.tipoMiniatura) {
                    viewModel.cambiarMiniatura(color: vm.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
                }
                
                Spacer()
                
                // Panel inferior con información
                VStack(alignment: .leading, spacing: 12) {
                    infoRow("Ruta:", "/Documentos/Comics/Ivy23.pdf")
                    infoRow("Tipo:", "Miniatura generada")
                    infoRow("Dimensiones:", "400 x 600 px")
                    infoRow("Calidad:", "Alta")
                    infoRow("Ruta:", "/Documentos/Comics/Ivy23.pdf")
                    infoRow("Tipo:", "Miniatura generada")
                    infoRow("Dimensiones:", "400 x 600 px")
                    infoRow("Calidad:", "Alta")
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
            } //7FIN ZSTACK

        }
    }
    
    @Namespace private var namespace
    
    // helper para filas de texto
    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 16))
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
                .frame(width: imageW, height: imageH)
                .opacity(min(sqrt(vertical * vertical + horizontal * horizontal) / 10, 0.8))
        }
        .blendMode(.screen) // Modo de mezcla para efecto holográfico
    }
}
