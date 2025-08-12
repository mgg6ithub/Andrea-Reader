

import SwiftUI

struct ListaColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var coleccion: Coleccion
    @ObservedObject var coleccionVM: ModeloColeccion
    
    private var const: Constantes { ap.constantes }
    private var escala: CGFloat { const.scaleFactor }
    
    var body: some View {
        
        HStack(spacing: 10) {
            Button(action: {
                coleccion.meterColeccion()
            }) {
                ZStack {
                    if coleccion.tipoMiniatura == .carpeta {
                        Image("CARPETA-ATRAS")
                            .resizable()
                            .frame(width: 110 * escala, height: 120 * escala)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(coleccion.color.gradient, coleccion.color.darken(by: 0.2).gradient)
                            .zIndex(1)
                    }
                }
            }
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    // ---- Información básica ----
                    HStack(spacing: 6) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(coleccion.color.gradient.opacity(0.3))
                                .frame(width: 30, height: 30)
                                .shadow(color: coleccion.color.opacity(0.25), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "folder.fill")
                                .foregroundColor(coleccion.color)
                                .frame(width: 25, height: 25)
                        }
                        
                        Text(coleccion.nombre)
                            .textoAdaptativo(t: const.titleSize, a: 0.6, l: 2, b: true, alig: .leading, mW: .infinity, fAlig: .leading)
                    }
                    
                    HStack(spacing: 20) {
                        Text("3.25 GB")
                            .textoAdaptativo(t: const.subTitleSize, a: 0.6, l: 1, b: false, c: .secondary, alig: .leading, s: true)
                        Text("\(coleccion.totalArchivos) elementos")
                            .textoAdaptativo(t: const.subTitleSize, a: 0.6, l: 1, b: false, c: .secondary, alig: .leading, s: true)
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        coleccion.meterColeccion()
                    }) {
                        Text("Entrar a la colección")
                            .textoAdaptativo(t: const.subTitleSize, a: 0.7, l: 1, b: true, c: ap.temaActual.colorContrario, alig: .center, s: true)
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: const.iconSize * 0.75))
                    }
                    .fondoBoton(pH: ConstantesPorDefecto().horizontalPadding, pV: 7, isActive: false, color: coleccion.color, borde: false)
                }
                .padding(20 * escala)
            }
            .frame(height: coleccionVM.altura * escala)
            .background(ap.temaActual.cardColor)
            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}
