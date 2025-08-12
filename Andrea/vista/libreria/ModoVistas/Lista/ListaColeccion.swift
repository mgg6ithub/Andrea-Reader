
import SwiftUI

struct ListaColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var coleccion: Coleccion
    @ObservedObject var coleccionVM: ModeloColeccion
    
    private var const: Constantes { ap.constantes }
    private var escala: CGFloat { const.scaleFactor }
    
    var body: some View {
            HStack(spacing: 0) {
                let anchoMiniatura = coleccionVM.altura * escala
                Button(action: {
                    coleccion.meterColeccion()
                }) {
                    ZStack {
                        if coleccion.tipoMiniatura == .carpeta {
                            Image("CARPETA-ATRAS")
                                .resizable()
                                .frame(width: coleccionVM.altura * 0.599 * escala,
                                       height: coleccionVM.altura * 0.599 * escala)
                                .aspectRatio(contentMode: .fit)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(coleccion.color.gradient, coleccion.color.darken(by: 0.2).gradient)
                                .zIndex(1)
                        } else if coleccion.tipoMiniatura == .abanico {
                            let direccionAbanico: EnumDireccionAbanico = coleccion.direccionAbanico

                            // Configuración base
                            let baseXStep: CGFloat = 8
                            let yStep: CGFloat = 6
                            let baseAngleStep: Double = 4
                            let scaleStep: CGFloat = 0.02

                            // Ajuste según dirección
                            let xStep = direccionAbanico == .izquierda ? -baseXStep : baseXStep
                            let angleStep = direccionAbanico == .izquierda ? -baseAngleStep : baseAngleStep
                            let rotationAnchor: UnitPoint = direccionAbanico == .izquierda ? .topLeading : .topTrailing

                            ForEach(Array(coleccion.miniaturasBandeja.enumerated()), id: \.offset) { index, img in
                                Image(uiImage: img)
                                    .resizable()
                                    .frame(width: coleccionVM.altura * 0.525 * escala,
                                           height: coleccionVM.altura * 0.725 * escala)
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(4)
                                    .shadow(radius: 1.5)
                                    .scaleEffect(index == 0 ? 1.0 : 1.0 - CGFloat(index) * scaleStep)
                                    .rotationEffect(
                                        .degrees(index == 0 ? 0 : Double(index) * angleStep),
                                        anchor: rotationAnchor
                                    )
                                    .offset(
                                        x: index == 0 ? 0 : CGFloat(index) * xStep,
                                        y: index == 0 ? 0 : -CGFloat(index) * yStep
                                    )
                                    .zIndex(index == 0 ? Double(coleccion.miniaturasBandeja.count + 1) : Double(coleccion.miniaturasBandeja.count - index))
                            }
                        }
                    }
                }
                .frame(width: anchoMiniatura * 0.651 , height: coleccionVM.altura * escala)
                
                Divider()
                    .padding(.horizontal)
                
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
                    
                    Text("3.25 GB")
                        .textoAdaptativo(t: const.subTitleSize, a: 0.6, l: 1, b: false, c: .secondary, alig: .leading, s: true)
                    
                    Spacer()
                    
                    TotalElementosColeccion(coleccion: coleccion)
                    
                }
                
                Button(action: {
                    coleccion.meterColeccion()
                }) {
                    Text("Entrar a la colección")
                        .textoAdaptativo(t: const.subTitleSize, a: 0.7, l: 1, b: true, c: ap.temaActual.colorContrario, alig: .center, s: true)
                    
                    Image(systemName: "chevron.forward")
                        .font(.system(size: const.iconSize * 0.55))
                        .fontWeight(.bold)
                }
                .fondoBoton(pH: ConstantesPorDefecto().horizontalPadding, pV: 7, isActive: false, color: coleccion.color, borde: false)
                
            }
            .padding(.vertical, 20 * escala)
            .padding(.horizontal, 5 * escala)
            .frame(height: coleccionVM.altura * escala * 0.8)
            .background(ap.temaActual.cardColor)
            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
            .shadow(color: ap.temaActual == .dark ? .black.opacity(0.5) : .black.opacity(0.1), radius: 2.5, x: 0, y: 3)
    }
}


struct TotalElementosColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var coleccion: Coleccion
    
    private var const: Constantes { ap.constantes }
    private var totalElementos: Int { coleccion.totalArchivos + coleccion.totalColecciones }
    
    var body: some View {
        if totalElementos == 0 {
            HStack {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: const.iconSize * 0.6))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.gray)
                
                Text("El directorio está vacio.")
                    .textoAdaptativo(t: const.subTitleSize, a: 0.8, l: 1, alig: .leading)
            }
        } else {
            HStack {
                Text("\(totalElementos)")
                    .textoAdaptativo(t: const.subTitleSize, a: 0.8, l: 1, alig: .leading)
            
            Image(systemName: "shippingbox.fill")
                .font(.system(size: const.iconSize * 0.6))
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.gray)
            
            Text("Elementos")
                    .textoAdaptativo(t: const.subTitleSize, a: 0.8, l: 1, alig: .leading)
            }
        }
    }
}
