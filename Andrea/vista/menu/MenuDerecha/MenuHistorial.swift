
import SwiftUI
import Foundation

// 2) Uso en tu VStack
struct MenuHistorial: View {
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var ne: NotificacionesEstado
    
    @ObservedObject private var coleccionActualVM: ModeloColeccion
    
    init() {
        _coleccionActualVM = ObservedObject(initialValue: PilaColecciones.pilaColecciones.getColeccionActual())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("custom-reloj")
                    .font(.system(size: ap.constantes.iconSize * 0.7))
                
                if let tiempo = coleccionActualVM.tiempoCarga {
                HStack(spacing: 3) {
                    Text("Coleccion \"\(coleccionActualVM.coleccion.nombre)\" indexada en")
                        .font(.headline)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                        Text(String(format: "%.2f", tiempo) + "s")
                                .font(.caption2)
                                .bold()
                    }
                }
                
            }
            .padding(.leading, 15)
            .padding(.top, 15)
            .padding(.trailing, 15)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(ne.historialNotificacionesEstado.reversed(), id: \.id) { noti in
                        SwipeToDeleteRow(
                            isDeleted: Binding(
                                get: { false },
                                set: { deleted in
                                    if deleted {
                                        ne.historialNotificacionesEstado.removeAll { $0.id == noti.id }
                                    }
                                }
                            ),
                            onDelete: {}
                        ) {
                            NotificacionLogVista(
                                logMensaje: noti.mensaje,
                                icono: noti.icono,
                                color: noti.color
                            )
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            .frame(maxHeight: 400) // 👈 Ajusta este valor según lo que desees



        }
    }
}

// 1) Wrapper genérico para cada fila swipeable
struct SwipeToDeleteRow<Content: View>: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @Binding var isDeleted: Bool
    let onDelete: () -> Void
    let content: () -> Content

    // Estado de desplazamiento
    @State private var offsetX: CGFloat = 0
    @GestureState private var isDragging = false

    // Umbral tras el cual se activa la eliminación
    private let deleteThreshold: CGFloat = 100

    var body: some View {
        ZStack(alignment: .trailing) {
            // Fondo rojo + icono de basura cuando se desliza
            Color.red
                .cornerRadius(10)
            
            Button {
                withAnimation {
                    performDelete()
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }
            .opacity(offsetX < -20 ? 1 : 0) // aparece solo al deslizar
            .animation(.easeInOut, value: offsetX)

            // La propia fila, desplazable
            content()
                .background(ap.temaActual.backgroundColor)
                .cornerRadius(10)
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .updating($isDragging) { value, state, _ in
                            state = true
                        }
                        .onChanged { value in
                            // Solo permitir deslizar hacia la izquierda
                            if value.translation.width < 0 {
                                offsetX = value.translation.width
                            }
                        }
                        .onEnded { value in
                            if -value.translation.width > deleteThreshold {
                                // Si pasa umbral, borra
                                withAnimation(.spring()) {
                                    performDelete()
                                }
                            } else {
                                // Vuelve a posición original
                                withAnimation(.spring()) {
                                    offsetX = 0
                                }
                            }
                        }
                )
        }
        .frame(height: 60)
        .padding(.horizontal, 15)
        .opacity(isDeleted ? 0 : 1)
    }

    private func performDelete() {
        // desplazamos fuera de pantalla
        offsetX = -500
        // marcamos eliminado para quitar del VStack
        isDeleted = true
        // llamamos al closure de borrado del array
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDelete()
        }
    }
}
