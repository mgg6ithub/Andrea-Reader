import SwiftUI
import TipKit

struct Rotate3DModifier: ViewModifier {
    var angle: Double
    func body(content: Content) -> some View {
        content.rotation3DEffect(
            Angle(degrees: angle),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}

struct Rotate180Modifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isActive ? 180 : 0))
    }
}

struct BlurTransition: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 10 : 0)
    }
}

struct FlipModifier: ViewModifier {
    let angle: Double
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 1, y: 0, z: 0)
            )
    }
}

extension AnyTransition {
    static var flip: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: FlipModifier(angle: 90),
                identity: FlipModifier(angle: 0)
            ),
            removal: .modifier(
                active: FlipModifier(angle: -90),
                identity: FlipModifier(angle: 0)
            )
        )
    }
}



struct VistaPrincipal: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    // --- ESTADO ---
    @State private var coleccionMostrada: ModeloColeccion? = nil
    @State private var animacionesInicialesActivadas = false
    
    // --- VARIABLES CALCULADAS ---
    private let cpd = ConstantesPorDefecto()
    private var escala: CGFloat { ap.constantes.scaleFactor }
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            
//            // 1. MOVE FROM BOTTOM
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: ap.archivoEnLectura)
//                .transition(.move(edge: .bottom))
//                .zIndex(1)
//            }
//
//            // 2. SCALE & FADE
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.easeInOut(duration: 0.4), value: ap.archivoEnLectura)
//                .transition(.scale.combined(with: .opacity))
//                .zIndex(1)
//            }
//
//            // 3. BOOK FLIP
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: ap.archivoEnLectura)
//                .transition(.asymmetric(
//                    insertion: .scale(scale: 0.1).combined(with: .modifier(
//                        active: Rotate3DModifier(angle: -90),
//                        identity: Rotate3DModifier(angle: 0)
//                    )),
//                    removal: .opacity
//                ))
//                .zIndex(1)
//            }
//
//            // 4. SLIDE FROM RIGHT
            if let archivo = ap.archivoEnLectura {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    ContenedorLector(archivo: archivo)
                }
                .animation(.interpolatingSpring(stiffness: 100, damping: 15), value: ap.archivoEnLectura)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .zIndex(1)
            }

            // 5. BOUNCE SCALE
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.interpolatingSpring(stiffness: 200, damping: 10), value: ap.archivoEnLectura)
//                .transition(.scale(scale: 0.3).combined(with: .opacity))
//                .zIndex(1)
//            }

//            // 6. UNFOLD FROM CENTER
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.easeInOut(duration: 0.5), value: ap.archivoEnLectura)
//                .transition(.scale(scale: 0.01, anchor: .center).combined(with: .opacity))
//                .zIndex(1)
//            }
//
//            // 7. SLIDE FROM TOP
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.spring(response: 0.7, dampingFraction: 0.6), value: ap.archivoEnLectura)
//                .transition(.move(edge: .top).combined(with: .opacity))
//                .zIndex(1)
//            }
//
//            // 8. ROTATE & SCALE
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: ap.archivoEnLectura)
//                .transition(.modifier(
//                    active: Rotate180Modifier(isActive: true),
//                    identity: Rotate180Modifier(isActive: false)
//                ))
//                .zIndex(1)
//            }
//
//            // 9. BLUR TO FOCUS
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.easeInOut(duration: 0.6), value: ap.archivoEnLectura)
//                .transition(.modifier(
//                    active: BlurTransition(isActive: true),
//                    identity: BlurTransition(isActive: false)
//                ))
//
//                .zIndex(1)
//            }
//
//            // 10. FLIP CARD
//            if let archivo = ap.archivoEnLectura {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .animation(.easeInOut(duration: 0.5), value: ap.archivoEnLectura)
//                .transition(.flip)
//                .zIndex(1)
//            }
            
//            if let archivo = ap.archivoEnLectura {
//                
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    ContenedorLector(archivo: archivo)
//                }
//                .scaleEffect(isPresented ? 1.0 : 0.1)
//                .rotationEffect(.degrees(isPresented ? 0 : -180))
//                .opacity(isPresented ? 1 : 0)
//                .animation(.spring(
//                    response: 0.8,
//                    dampingFraction: 0.6,
//                    blendDuration: 0.3
//                ), value: isPresented)
//                .onAppear {
//                    isPresented = true
//                }
//                .onDisappear {
//                    isPresented = false
//                }
//                .zIndex(1)
//            }


            
            ap.temaActual.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                
                barraSuperior()
                    .animation(.easeInOut(duration: 0.2), value: me.seleccionMultiplePresionada)
                
                Spacer()
                
                if let coleccion = coleccionMostrada {
                    Libreria(vm: coleccion)
                    // --- ANIMACIONES DE CAMBIO DE COLECCION ---
                        .id(coleccion.coleccion.id)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
                
                barraInferior()
                    .animation(.easeInOut(duration: 0.2), value: me.seleccionMultiplePresionada)
                
                //MARK: - --- CONSEJO SMART SORTING DE UNA COLECCION ---
//                TipView(ConsejoSmartSorting())
                //MARK: - --- CONSEJO SMART SORTING DE UNA COLECCION ---
                
            }
            .onAppear {
                coleccionMostrada = pc.getColeccionActual()
            }
            .padding(0)
            .onChange(of: pc.coleccionActualVM?.coleccion.id) {
                guard pc.coleccionActualVM?.coleccion.id != coleccionMostrada?.coleccion.id else { return }

                withAnimation(.easeOut(duration: 0.15)) {
                    coleccionMostrada = nil
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        coleccionMostrada = pc.getColeccionActual()
                    }
                }
            }
            
            // --- MAS INFORMACION ---
            if ap.masInformacion, let elementoSelecionado = ap.elementoSeleccionado {
                MasInformacion(pantallaCompleta: $ap.pantallaCompleta, vm: pc.getColeccionActual(), elemento: elementoSelecionado)
                    .capaSuperior()
            }
            // --- VISTA PREVIA DE UN ELEMENTO ---
            if ap.vistaPrevia, let elementoSelecionado = ap.elementoSeleccionado {
                CartaHolografica3D(vm: pc.getColeccionActual(), elemento: elementoSelecionado)
                    .capaSuperior()
            }
            
        }
//        .animation(.easeInOut, value: ap.archivoEnLectura)
//        .fullScreenCover(item: $ap.archivoEnLectura) { archivo in
//            ContenedorLector(archivo: archivo)
//        }

    
        .foregroundColor(ap.temaActual.textColor)
        .animation(.easeInOut, value: ap.temaActual)
    }

    // --- FUNCIONES ---
    private func barraSuperior() -> some View {
        Group {
            if me.seleccionMultiplePresionada, let coleccion = coleccionMostrada {
                MenuSeleccionMultipleArriba(vm: coleccion)
                    .capaSeleccionMultiple()
            } else {
                VStack(spacing: 0) {
                    MenuVista()
                        .padding(.vertical, 8 * escala)
                        .padding(.bottom, 12.5 * escala)

                    HistorialColecciones()
                        .frame(height: 50)
                }
                .padding(.horizontal, cpd.padding15)
            }
        }
    }

    private func barraInferior() -> some View {
        Group {
            if me.seleccionMultiplePresionada {
                MenuSeleccionMultipleAbajo()
                    .capaSeleccionMultiple()
            } else {
                EmptyView()
            }
        }
    }

}

extension View {
    func capaSeleccionMultiple() -> some View {
        self.frame(width: .infinity, height: 50)
        .background(.gray.opacity(0.2))
    }
}

extension View {
    func capaSuperior() -> some View {
        self.edgesIgnoringSafeArea(.all)
            .zIndex(10)
    }
}


struct ContenedorLector: View {
    var archivo: Archivo
    @State private var mostrarMenu = false
    @EnvironmentObject var ap: AppEstado // <- necesario

    var body: some View {
        ZStack {
            switch archivo.fileType {
            case .cbr, .cbz:
                let comic = archivo as! any ProtocoloComic
                LectorComic(comic: comic)
            default:
                Text("Tipo no soportado")
            }
            
            if mostrarMenu {
                MenuLectura(
                    archivo: archivo,
                    cerrar: {
                        withAnimation {
                            ap.archivoEnLectura = nil
                            mostrarMenu = false
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation {
                mostrarMenu.toggle()
            }
        }
    }
}


struct MenuLectura: View {
    var archivo: Archivo
    var cerrar: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button("Cerrar") { cerrar() } // ← ya no toca el menú
                Spacer()
                Text("Progreso: \(archivo.progreso)%")
                Spacer()
                Button("Opciones") { }
            }
            .padding()
            .background(.ultraThinMaterial)
            Spacer()
        }
    }
}



