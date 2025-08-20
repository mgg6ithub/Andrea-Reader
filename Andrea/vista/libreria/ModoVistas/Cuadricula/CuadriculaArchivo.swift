import SwiftUI

struct CuadriculaArchivo: View {
    
    @EnvironmentObject var ap: AppEstado
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
    @State private var progresoMostrado: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // --- Imagen ---
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    ap.archivoEnLectura = archivo
                }
            }) {
                ZStack {
                    CheckerEncimaDelElemento(elementoURL: archivo.url, topPadding: true)
                    
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
                    .overlay(alignment: .bottom) {
                        if archivo.tipoMiniatura != .imagenBase && viewModel.miniatura != nil {
                            LinearGradient(
                                colors: [Color.black.opacity(0.9), .clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .frame(height: 80)
//                            .opacity(viewModel.miniatura == nil ? 0 : 1)           // <- clave
                            //                        .animation(.easeInOut(duration: 0.2), value: viewModel.miniatura != nil)
                            .allowsHitTesting(false)
                        }
                    }
                    .onChange(of: coleccionVM.color) { //Si se cambia de color volvemos a genera la imagen base
                        if archivo.tipoMiniatura == .imagenBase {
                            viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
                        }
                    }

                    if mostrarMiniatura {
                        VStack(spacing: 3) {
                            Spacer()
                            HStack(alignment: .bottom, spacing: 2.5) {
                                if archivo.progreso > 0 {
                                    HStack(spacing: 0) {
                                        Text("%")
                                            .font(.system(size: ConstantesPorDefecto().subTitleSize * 0.75))
                                            .bold()
                                            .foregroundColor(coleccionVM.color)
                                            .offset(y: 1.5)
                                        Color.clear
                                            .animatedProgressText1(progresoMostrado)
                                            .font(.system(size: ConstantesPorDefecto().subTitleSize * 1.1))
                                            .bold()
                                            .foregroundColor(coleccionVM.color)
                                    }
                                    //NECESARIOS PARA ANIMACION DEL PROGRESO
                                    .onAppear { progresoMostrado = archivo.progreso }
                                    .onChange(of: ap.archivoEnLectura) {
                                        withAnimation(.easeOut(duration: 0.6)) {
                                            progresoMostrado = archivo.progreso
                                        }
                                    }
                                    //NECESARIOS PARA ANIMACION DEL PROGRESO
                                }
                                
                                // --- ICONOS DE LOS ESTADOS DE UN ARCHIVO ---
                                if archivo.favorito {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.yellow.gradient)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity))
                                        )
                                        .alignmentGuide(.bottom) { d in d[.bottom] + 3 }
                                        .animation(.easeInOut(duration: 0.3), value: archivo.favorito)
                                }
                                
                                if archivo.protegido {
                                    Image(systemName: "lock.shield")
                                        .font(.system(size: 15))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.red.gradient, .gray.gradient)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity))
                                        )
                                        .alignmentGuide(.bottom) { d in d[.bottom] + 2 }
                                        .animation(.easeInOut(duration: 0.3), value: archivo.protegido)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, archivo.tipoMiniatura == .imagenBase ? 13 : 10)
                            .onChange(of: archivo.completado) {
                                withAnimation(.easeOut(duration: 0.6)) {
                                    progresoMostrado = archivo.progreso
                                }
                            }
                            
                            ProgresoCuadricula(
                                progresoMostrado: $progresoMostrado,
                                coleccionColor: coleccionVM.color,
                                totalWidth: width - 20,
                                padding: archivo.tipoMiniatura == .imagenBase ? 13 : 10
                            )
                            
                        }
                        .padding(.bottom, 4.5)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .zIndex(3)
                    }
                    
                }
                .frame(width: width)
            }
            .disabled(me.seleccionMultiplePresionada)
            
            // --- Titulo e informacion ---
            InformacionCuadricula(
                coleccionVM: coleccionVM,
                nombre: archivo.nombre,
                tipo: archivo.fileType.rawValue,
                tamanioMB: ManipulacionSizes().formatearSize(archivo.fileSize),
                totalPaginas: archivo.totalPaginas,
                progreso: archivo.progreso,
                coleccionColor: coleccionVM.color,
                maxWidth: width
            )
            .equatable()
            .frame(height: 38)
            .padding(7)
        }
        .frame(width: width, height: height)
        .background(ap.temaResuelto.cardColorFixed)
        .cornerRadius(15)
        .shadow(color: ap.temaResuelto == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        .onAppear {
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)
            mostrarMiniatura = false // ← reinicia animación si se reutiliza la celda
        }
        .onDisappear {
            viewModel.unloadThumbnail(for: archivo)
        }
        .onChange(of: archivo.tipoMiniatura) {
            viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
        }

    }
    
}



