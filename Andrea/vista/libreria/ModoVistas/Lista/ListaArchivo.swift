

import SwiftUI

struct ListaArchivo: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @ObservedObject var coleccionVM: ModeloColeccion
    @State private var isVisible = false
    
    private var escala: CGFloat { ap.constantes.scaleFactor }
    
    private var ratio: CGFloat {
        if let img = viewModel.miniatura {
            return img.size.width / img.size.height
        }
        return 1 // fallback si no hay imagen
    }
    
    var body: some View {
        HStack(spacing: 0) {
            let anchoMiniatura = coleccionVM.altura * escala
            ZStack {
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
            
            Divider()
                .background(Color.gray)
                .padding(.horizontal)
            
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(archivo.nombre)
                        .font(.headline)
                        .foregroundColor(ap.temaActual.textColor)
                        .id(archivo.nombre) // fuerza la transición
                            .transition(.opacity.combined(with: .scale)) // o .slide, .move(edge:), etc.
                            .animation(.easeInOut(duration: 0.3), value: archivo.nombre)
                    
                    Spacer()
                    
                    Text("Andrea la mas guapa del mundo pero que guapa es con esos pedazo de papos la madre que me pario. Hay diso mios que guapa es la pocala blablanskanks askdaskd algo mas no se que mas.")
                        .font(.subheadline)
                        .foregroundColor(ap.temaActual.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                   
                    ProgresoLista(archivo: archivo, coleccionVM: coleccionVM)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    InformacionLista(archivo: archivo, coleccionVM: coleccionVM)
                }
                .padding(.trailing, 10 * escala)
            }
            
        } //HStack principal
        .padding(.vertical, 10 * escala)
        .padding(.horizontal, 5 * escala)
        .frame(height: coleccionVM.altura * escala)
        .background(ap.temaActual.cardColor)
        .cornerRadius(8, corners: [.topLeft, .bottomLeft])
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
