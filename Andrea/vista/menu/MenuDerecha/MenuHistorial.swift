
import SwiftUI
import Foundation

struct AndreaAppView_Preview: PreviewProvider {
    static var previews: some View {
        // Instancias de ejemplo para los objetos de entorno
//        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
//        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
//        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
        let me = MenuEstado() // Reemplaza con inicialización adecuada
        let pc = PilaColecciones.preview

        return AndreaAppView()
            .environmentObject(ap)
            .environmentObject(me)
            .environmentObject(pc)
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


// 2) Uso en tu VStack
struct MenuHistorial: View {
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("custom-reloj")
                    .font(.system(size: ap.constantes.iconSize * 0.5))
                
                HStack(spacing: 3) {
                    Text("Indexado desde \"mi ipad\" hace")
                        .font(.system(size: ap.constantes.subTitleSize * 0.85))
                    
                    Text("2.13 s")
                        .font(.system(size: ap.constantes.subTitleSize * 0.85))
                        .bold()
                }
            }
            .padding(.leading, 15)
            .padding(.top, 15)
            .padding(.trailing, 15)

            VStack(spacing: 15) {
                ForEach(me.historialNotiticaciones) { noti in
                    // Binding temporal para controlar opacidad
                    let index = me.historialNotiticaciones.firstIndex(where: { $0.id == noti.id })!
                    SwipeToDeleteRow(
                        isDeleted: Binding(
                            get: { false },
                            set: { deleted in
                                if deleted {
                                    // Eliminar elemento del array
                                    me.historialNotiticaciones.removeAll { $0.id == noti.id }
                                }
                            }
                        ),
                        onDelete: {
                            // También puedes manejar aquí la eliminación
                        }
                    ) {
                        NotificacionLogVista(logMensaje: noti.mensaje,
                                             icono: noti.icono,
                                             color: noti.color)
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
}
