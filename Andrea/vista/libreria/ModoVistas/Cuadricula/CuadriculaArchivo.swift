import SwiftUI

struct CuadriculaArchivo: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @ObservedObject var coleccionVM: ModeloColeccion

    @State private var isVisible = false
    
    var width: CGFloat
    var height: CGFloat
    
    @State private var mostrarMiniatura = false
    @State private var idImagen = UUID()
    
    private let constantes = ConstantesPorDefecto()
    
    var body: some View {
        VStack(spacing: 0) {

            // --- Imagen ---
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    appEstado.archivoEnLectura = archivo
                }
            }) {
                ZStack {
                    if me.seleccionMultiplePresionada {
                        VStack(alignment: .center, spacing: 0) {
                            let seleccionado = me.elementosSeleccionados.contains(archivo.url)
                            Image(systemName: seleccionado ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: constantes.iconSize * 1.5))
                                .fontWeight(.light)
                                .foregroundColor(.gray)
                                .transition(.scale.combined(with: .opacity))
                                .contentTransition(.symbolEffect(.replace, options: .speed(2.25)))
                        }
                        .padding(.top, 60)
                        .zIndex(5)
                    }
                    
                    ZStack {
                        if let img = viewModel.miniatura {
                            Image(uiImage: img)
                                .resizable()
                                .scaleEffect(mostrarMiniatura ? 1 : 1.05)
                                .opacity(mostrarMiniatura ? 1 : 0)
                                .animation(.easeOut(duration: 0.25), value: mostrarMiniatura)
                                .onAppear {
                                    mostrarMiniatura = true
                                }
                                .zIndex(1)
                        } else {
                            
                            VStack(alignment: .center) {
                                Spacer()
                                
                                ProgressView()
                                    .zIndex(1)
                                
                                Spacer()
                            }
                        }
                    }
                    .onChange(of: coleccionVM.color) { //Si se cambia de color volvemos a genera la imagen base
                        if archivo.tipoMiniatura == .imagenBase {
                            viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
                        }
                    }

                    if mostrarMiniatura {
                        VStack(spacing: 0) {
                            Spacer()
                            HStack(spacing: 3.5) {
                                
    //                            if archivo.progreso > 0 {
    //                                HStack(spacing: 0) {
    //                                    Text("%")
    //                                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.65))
    //                                        .bold()
    //                                        .foregroundColor(coleccionVM.color)
    //                                        .zIndex(3)
    //
    //                                    Text("\(archivo.progreso)")
    //                                        .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.95))
    //                                        .bold()
    //                                        .foregroundColor(coleccionVM.color)
    //                                        .zIndex(3)
    //                                }
    //                            }
                                
                                // --- ICONOS DE LOS ESTADOS DE UN ARCHIVO ---
                                if archivo.protegido {
                                    Image(systemName: "lock.shield")
                                        .font(.system(size: 15))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.red.gradient, .gray.gradient)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity))
                                        )
                                        .animation(.easeInOut(duration: 0.3), value: archivo.protegido)
                                }
                                
                                if archivo.favorito {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.yellow.gradient)
                                        .padding(.bottom, 1)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity))
                                        )
                                        .animation(.easeInOut(duration: 0.3), value: archivo.favorito)
                                }
                                
                                Spacer()
                            }
                            .frame(alignment: .leading)
                            .padding(.horizontal, archivo.tipoMiniatura == .imagenBase ? 13 : 10)
                            .padding(.bottom, -6)
                            
    //                        ProgresoCuadricula(
    //                            progreso: archivo.progreso,
    //                            coleccionColor: coleccionVM.color,
    //                            totalWidth: width - 20,
    //                            padding: archivo.tipoMiniatura == .imagenBase ? 13 : 10
    //                        )
    //                        .frame(maxHeight: 24)
                            
                        }
                        .padding(.bottom, 2)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .zIndex(3)
                        
    //                    if archivo.tipoMiniatura != .imagenBase {
    //                        VStack {
    //                            Spacer()
    //                            HStack {
    //                                RadialGradient(
    //                                    gradient: Gradient(colors: [
    //                                        Color.black,
    //                                        Color.black.opacity(0.95)
    //                                    ]),
    //                                    center: .bottomLeading,
    //                                    startRadius: 10,
    //                                    endRadius: 90
    //                                )
    //                                .frame(width: 120, height: 80)
    //                                .blur(radius: 20)
    //                                .offset(x: -20, y: 20)
    //                                .allowsHitTesting(false)
    //
    //                                Spacer()
    //                            }
    //                        }
    //                        .zIndex(2) // 🔽 Importante: para que quede detrás de la barra y texto
    //                    }
                    }
                    
                }
                .frame(width: width)
            }
            
            Spacer()
            
            // --- Titulo e informacion ---
            InformacionCuadricula(
                nombre: archivo.nombre,
                tipo: archivo.fileType.rawValue,
                tamanioMB: ManipulacionSizes().formatearSize(archivo.fileSize),
                totalPaginas: archivo.totalPaginas,
                progreso: archivo.progreso,
                coleccionColor: coleccionVM.color,
                maxWidth: width
            )
            .equatable()
            .frame(height: 58)
//            .padding(.top, -10)
            
        }
        .frame(width: width, height: height)
        .background(appEstado.temaActual.cardColor)
        .cornerRadius(15)
        .shadow(color: appEstado.temaActual == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
//        .scaleEffect(isVisible ? 1 : 0.95)
//        .opacity(isVisible ? 1 : 0)
        .onAppear {
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)
//            isVisible = true
            mostrarMiniatura = false // ← reinicia animación si se reutiliza la celda
        }
        .onDisappear { 
//            isVisible = false
            viewModel.unloadThumbnail(for: archivo)
        }
        .onChange(of: archivo.tipoMiniatura) {
            viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
        }

    }
    
}



