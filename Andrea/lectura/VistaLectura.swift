

import SwiftUI

#Preview {
    PreviewMasInformacion1()
}
//
private struct PreviewMasInformacion1: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MenuLectura(archivo: Archivo.preview, estadisticas: Archivo.preview.estadisticas, vm: ModeloColeccion(), cerrar: {})
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct ContenedorLector: View {
    @ObservedObject var archivo: Archivo    // <- así
    @ObservedObject var vm: ModeloColeccion
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
                    estadisticas: archivo.estadisticas,
                    vm: vm,
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
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @ObservedObject var vm: ModeloColeccion
    var cerrar: () -> Void
    
    @State private var miniatura: UIImage?
    @State private var isPressed: Bool = false
    
    private var sss: EstadisticasYProgresoLectura { estadisticas }
    private var const: Constantes { ap.constantes }
    
    private func actualizarMiniatura() {
        miniatura = ModeloMiniatura.modeloMiniatura
            .obtenerMiniaturaPaginaActual(archivo: archivo, color: vm.color)
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .center, spacing: 10) {
                            
                            HStack(spacing: 2) {
                                Text("miniatura de la página")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.white)
                                
                                Text("\(estadisticas.paginaActual)")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.white)
                                    .frame(width: 30, alignment: .leading)
                                    .contentTransition(.numericText())
                                    .animation(.easeInOut(duration: 0.25), value: estadisticas.paginaActual)
                            }
                            
                            if let miniatura {
                                Image(uiImage: miniatura)
                                    .resizable()
                                    .frame(width: 190, height: 260)
                                    .cornerRadius(15)
                                    .contentTransition(.interpolate)
                                    .animation(.easeInOut(duration: 0.25), value: estadisticas.paginaActual)
                            }
                        }
                        .onAppear {
                           actualizarMiniatura()
                       }
                       .onChange(of: estadisticas.paginaActual) {
                           actualizarMiniatura()
                       }
                        
                        Text(archivo.nombre)
                            .font(.title)
                            .bold()
                            .frame(width: 190, alignment: .center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.6)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 10) {
                        
                        Text("ajustes")
                            .font(.system(size: 11))
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            isPressed = true
                            archivo.leyendose = false
                            cerrar()
                        }) {
                            Image(systemName: "book.and.wrench")
                                .font(.system(size: ap.constantes.iconSize * 0.95))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(vm.color, Color.black)
                                .symbolEffect(.bounce, value: isPressed)
                                .fontWeight(.thin)
                        }
                        .padding(7.4)
                        .background(Color.gray.opacity(0.5).gradient)
                        .shadow(color: Color.black.opacity(0.25),
                                radius: 2.5,
                                x: 0, y: 2)
                        .cornerRadius(5)
                    }
                    .padding(.trailing, 35)
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text("salir")
                            .font(.system(size: 11))
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            isPressed = true
                            archivo.leyendose = false
                            cerrar()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: ap.constantes.iconSize * 1.1))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.black)
                                .symbolEffect(.bounce, value: isPressed)
                        }
                        .padding(7.5)
                        .background(Color.red.gradient)
                        .cornerRadius(5)
                        .contentShape(Rectangle())
                    }
                    
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 10) {
                                                
                        Text("colección")
                            .font(.system(size: 11))
                            .foregroundColor(.white)
                        
                        Text(vm.coleccion.nombre)
                            .font(.title)
                            .bold()
                            .padding(.bottom, 60)
                        
                        HStack {
                           Image(systemName: "arrow.backward")
                                .font(.system(size: const.iconSize))
                               .symbolRenderingMode(.palette)
                               .foregroundStyle(Color.gray.gradient)
                           
                           ZStack {
                               Image(systemName: "sidebar.right")
                                   .font(.system(size: const.iconSize * 0.9))
                                   .symbolRenderingMode(.palette)
                                   .foregroundStyle(.black)
//                                   .symbolEffect(.bounce.down.byLayer, value: sideMenuVisible)
                                   .fontWeight(.thin)
                           }
                           .padding(.horizontal, 7.5)
                           .frame(height: const.iconSize * 1.5)
                           .background(Color.gray.opacity(0.5).gradient)
                           .shadow(color: Color.black.opacity(0.25), radius: 2.5, x: 0, y: 2)
                           .cornerRadius(5)
                       }
                        .offset(x: -8)
                        
                    }
                    
                }
                
                Spacer()
                
                ZStack{
                        //MARK: - CUSTOM SLIDER
                    VistaProgresoLectura(estadisticas: estadisticas, vm: vm)
                    
                }
                .frame(height: 45)
                
                
            } //FIN VSTACK
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 35)
            .padding(.horizontal, 25)
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
