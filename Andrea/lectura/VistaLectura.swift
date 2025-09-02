

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
    
    private var sss: EstadisticasYProgresoLectura { archivo.estadisticas }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cerrar") {
                    archivo.leyendose = false
                    cerrar()
                }
                
                Spacer()
                
                Text("Tiempo: \(TimeInterval().formatTimeMS(sss.tiempoActual))")
                
                Spacer()
                Text("Progreso: \(sss.progreso)%")
                Spacer()
                Button("Opciones") { }
            }
            .padding()
            .background(.ultraThinMaterial)
            Spacer()
        }
    }
    
}
