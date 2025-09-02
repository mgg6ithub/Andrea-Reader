

import SwiftUI

struct ContenedorLector: View {
    @ObservedObject var archivo: Archivo    // <- así
    @State private var mostrarMenu = false
    @EnvironmentObject var ap: AppEstado // <- necesario

    var body: some View {
        ZStack {
            ap.temaResuelto.backgroundGradient.edgesIgnoringSafeArea(.all)
            switch archivo.fileType {
            case .cbr, .cbz:
                if let comic = archivo as? any ProtocoloComic {
                    LectorComic(comic: comic, paginaActual: $archivo.estadisticas.paginaActual)
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
                .ignoresSafeArea()
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
    
    @EnvironmentObject var ap: AppEstado
    
    var archivo: Archivo
    var cerrar: () -> Void
    
    @State private var isPressed: Bool = false
    
    private var sss: EstadisticasYProgresoLectura { archivo.estadisticas }
    
    var body: some View {
//        VStack {
//            HStack {
//                Button("Cerrar") {
//                    archivo.leyendose = false
//                    cerrar()
//                }
//                
//                Spacer()
//                
//                Text("Tiempo: \(TimeInterval().formatTimeMS(sss.tiempoActual))")
//                
//                Spacer()
//                Text("Progreso: \(sss.progreso)%")
//                Spacer()
//                Button("Opciones") { }
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            Spacer()
//        }
        
        ZStack {
            
            HStack {
                Spacer()
                Button(action: {
                    isPressed = true
                    archivo.leyendose = false
                    cerrar()
//                    withAnimation(.easeInOut(duration: 0.25)) { ap.masInformacion = false }
                }) {
                    Image(systemName: "xmark.square.fill")
                        .font(.system(size: ap.constantes.iconSize * 1.3))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(ap.temaResuelto.colorContrario, Color.red)
                        .symbolEffect(.bounce, value: isPressed)
                }
                .frame(width: ap.constantes.iconSize * 1.3,
                       height: ap.constantes.iconSize * 1.3) // 👈 fuerza el tamaño al del icono
                .contentShape(Rectangle())
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(
                gradient: Gradient(colors: [
//                    Color.black.opacity(0.4),
                    Color.black.opacity(0.5),
                    Color.black.opacity(0.6),
                    Color.black.opacity(0.7),
                    Color.black.opacity(0.8),
                    Color.black.opacity(0.9),
                    Color.black.opacity(1)
                ]),
                center: .center,
                startRadius: 170,
                endRadius: 650
            )
        )
    }
    
}
