

import SwiftUI

struct ListaArchivo: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @ObservedObject var coleccionVM: ModeloColeccion
    @State private var isVisible = false
    
    private var escala: CGFloat { ap.constantes.scaleFactor }
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                if let img = viewModel.miniatura {
                    Image(uiImage: img)
                        .resizable()
                } else {
                    ProgressView()
                }
            }
            .frame(width: (coleccionVM.altura * escala) - coleccionVM.ajusteHorizontal)
            .onChange(of: coleccionVM.color) { //Si se cambia de color volvemos a genera la imagen base
                if archivo.tipoMiniatura == .imagenBase {
                    viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
                }
            }
            
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
            }
            .padding()
            
        } //HStack principal
        .frame(height: coleccionVM.altura * escala)
        .background(ap.temaActual.cardColor)
        .cornerRadius(8, corners: [.topLeft, .bottomLeft])
        .shadow(color: ap.temaActual == .dark ? .black.opacity(0.5) : .black.opacity(0.1), radius: 2.5, x: 0, y: 3)
        .onAppear {
            
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)

//            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0.2...0.4))) {
                isVisible = true
//            }
        }
        .onDisappear {
            viewModel.unloadThumbnail(for: archivo)
        }
        .onChange(of: archivo.tipoMiniatura) {
            viewModel.cambiarMiniatura(color: coleccionVM.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
        }
    }
}
