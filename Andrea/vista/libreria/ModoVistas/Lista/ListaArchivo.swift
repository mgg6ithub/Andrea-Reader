

import SwiftUI

struct ListaArchivo: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @ObservedObject var coleccionVM: ModeloColeccion
    @State private var isVisible = false
    
    private var escala: CGFloat { ap.constantes.scaleFactor }
    private var tema: EnumTemas { ap.temaResuelto }
    
    private var ratio: CGFloat {
        if let img = viewModel.miniatura {
            return img.size.width / img.size.height
        }
        return 1 // fallback si no hay imagen
    }
    
    @State private var progresoMostrado: Int = 0
    
    var body: some View {
        HStack(spacing: 15) {
            let anchoMiniatura = coleccionVM.altura * escala
            Button(action: {
                ap.archivoEnLectura = archivo
            }) {
                ZStack {
                    CheckerEncimaDelElemento(elementoURL: archivo.url, topPadding: false)
                    
                    if let img = viewModel.miniatura {
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: anchoMiniatura * ratio * 0.9,
                                height: coleccionVM.altura * escala * 0.9
                            )
                            .cornerRadius(8, corners: .allCorners)
                            .onAppear {
                                print(ratio)
                            }
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: anchoMiniatura * ratio, height: coleccionVM.altura * escala)
                .onChange(of: coleccionVM.color) {
                    if archivo.tipoMiniatura == .imagenBase {
                        viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
                    }
                }
            }
            .disabled(me.seleccionMultiplePresionada)
            
//            Divider()
//                .background(Color.gray)
//                .padding(.horizontal)
            
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(archivo.nombre)
                        .font(.headline)
                        .foregroundColor(tema.textColor)
                        .id(archivo.nombre) // fuerza la transición
                            .transition(.opacity.combined(with: .scale)) // o .slide, .move(edge:), etc.
                            .animation(.easeInOut(duration: 0.3), value: archivo.nombre)
                    
                    Spacer()
                    
                    Text("Andrea la mas guapa del mundo pero que guapa es con esos pedazo de papos la madre que me pario. Hay diso mios que guapa es la pocala blablanskanks askdaskd algo mas no se que mas.")
                        .font(.subheadline)
                        .foregroundColor(tema.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    if ap.porcentaje {
                        ProgresoLista(archivo: archivo, coleccionVM: coleccionVM, progresoMostrado: $progresoMostrado)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    InformacionLista(archivo: archivo, coleccionVM: coleccionVM)
                }
                .padding(.trailing, 10 * escala)
            }
            
        } //HStack principal
        //PROGRESO
        .onAppear { progresoMostrado = archivo.progreso }
        .onChange(of: ap.archivoEnLectura) {
            withAnimation(.easeOut(duration: 0.6)) {
                progresoMostrado = archivo.progreso
            }
        }
        .onChange(of: archivo.completado) {
            withAnimation(.easeOut(duration: 0.6)) {
                progresoMostrado = archivo.progreso
            }
        }
        //PROGRESO
        .padding(.vertical, 10 * escala)
        .padding(.horizontal, 5 * escala)
        .frame(height: coleccionVM.altura * escala)
        .background(ap.fondoCarta ?  tema.cardColorFixed : .clear)
        .clipShape(RoundedCorners1(tl: 8, tr: 0, bl: 8, br: 0))  
        //AQUI HAY QUE AGREGAR UN OVERLAY PARA EL PROGRESO DEL CONTORNO DE LA LISTA
        .if(ap.porcentajeBarra && ap.porcentajeEstilo == .contorno && viewModel.miniatura != nil) { v in
            v.overlay {
                ProgressStroke(
                    progreso: $progresoMostrado,                          // tu estado animado
                    shape: RoundedCorners1(tl: 8, tr: 0, bl: 8, br: 0),    // misma forma
                    color: coleccionVM.color,
                    lineWidth: 3,
                    showGuide: false
                )
            }
        }
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .onAppear {
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)
            isVisible = true
        }
        .onDisappear {
            viewModel.unloadThumbnail(for: archivo)
        }
        .onChange(of: archivo.tipoMiniatura) {
            viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
        }
    }
}
