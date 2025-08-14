import SwiftUI
import TipKit

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
//            ap.temaActual.backgroundColor.edgesIgnoringSafeArea(.all)
            ap.temaActual.backgroundGradient.edgesIgnoringSafeArea(.all)
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
        .fullScreenCover(item: $ap.archivoEnLectura) { archivo in
            ContenedorLector(archivo: archivo)
//                .background(ap.temaActual.backgroundColor) // tu color
                .background(ap.temaActual.backgroundGradient) // tu color
                .ignoresSafeArea()
                .presentationBackground(.clear)            // <- quita el blanco del presentador
        }
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
//            ap.temaActual.backgroundColor.ignoresSafeArea()
            ap.temaActual.backgroundGradient.ignoresSafeArea()
            switch archivo.fileType {
            case .cbr, .cbz:
                if let comic = archivo as? any ProtocoloComic {
                    LectorComic(comic: comic)
                } else {
                    ArchivoIncompatibleView(archivo: archivo)
                }
            default:
                Text("Tipo no soportado")
            }
            
            if mostrarMenu {
                MenuLectura(
                    archivo: archivo,
                    cerrar: {
                        mostrarMenu = false
                        withAnimation {
                            ap.archivoEnLectura = nil
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



