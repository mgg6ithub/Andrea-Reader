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
    private var tema: EnumTemas { ap.temaResuelto }
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                //Espacio vertical para respetar cuando no hay barra de estado. No habra espacio en seleccion multiple.
                Color.clear
                    .frame(height: (me.seleccionMultiplePresionada && me.barraEstado)
                                    ? 0
                                    : me.statusBarTopInsetBaseline)
                
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
                coleccionMostrada = pc.getColeccionActual() // <- necesario
            }
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
                if let elemento = elementoSelecionado as? ElementoSistemaArchivos {
                    MasInformacion(pantallaCompleta: $ap.pantallaCompleta, vm: pc.getColeccionActual(), elemento: elemento)
                        .ignoresSafeArea()
                        .zIndex(1)
                }
            }
            
            // --- MAS INFORMACION DE UNA COLECCION ---
            if ap.masInformacionColeccion, let coleccionseleccionada = ap.coleccionseleccionada {
                MasInfoCol(pantallaCompleta: $ap.pantallaCompleta, vm: coleccionseleccionada)
            }
            
            
            // --- VISTA PREVIA DE UNA MINIATURA ---
            if ap.vistaPrevia, let elementoSelecionado = ap.elementoSeleccionado, let archivo = elementoSelecionado as? Archivo {
                CartaHolografica3D(vm: pc.getColeccionActual(), archivo: archivo)
                    .ignoresSafeArea()
                    .zIndex(5)
            }
            
        }
        .fullScreenCover(item: $ap.archivoEnLectura) { archivo in
            ContenedorLector(archivo: archivo)
                .background(tema.backgroundGradient) // tu color
                .ignoresSafeArea()
                .presentationBackground(.clear)            // <- quita el blanco del presentador
                .statusBar(hidden: me.barraEstado)
        }
        .foregroundColor(tema.textColor)
        .animation(.easeInOut, value: tema)
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

                    if ap.historialColecciones {
                        HistorialColecciones()
                            .frame(height: 50)
                    }
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
        self.ignoresSafeArea()
            .zIndex(10)
    }
}


