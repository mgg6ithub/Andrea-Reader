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
    
    var body: some View {
        ZStack {
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
//                MasInformacion(vm: pc.getColeccionActual(), pantallaCompleta: $ap.pantallaCompleta, elemento: elementoSelecionado)
                MasInformacion(pantallaCompleta: $ap.pantallaCompleta, elemento: elementoSelecionado)
                    .capaSuperior()
            }
            // --- VISTA PREVIA DE UN ELEMENTO ---
            if ap.vistaPrevia, let elementoSelecionado = ap.elementoSeleccionado {
                CartaHolografica3D(vm: pc.getColeccionActual(), elemento: elementoSelecionado)
                    .capaSuperior()
            }
            
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

