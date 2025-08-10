import SwiftUI

struct CuadriculaColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    @ObservedObject var coleccion: Coleccion
    var width: CGFloat
    var height: CGFloat
    
    private let constantes = ConstantesPorDefecto()
    private var escala: CGFloat { ap.constantes.scaleFactor }
    private var isSmall: Bool { ap.constantes.resLog == .small }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button(action: {
                coleccion.meterColeccion()
            }) {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    ZStack {
                        if me.seleccionMultiplePresionada {
                            VStack(alignment: .center, spacing: 0) {
                                let seleccionado = me.elementosSeleccionados.contains(coleccion.url)
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
                        
                        if coleccion.tipoMiniatura == .carpeta {
                            Image("CARPETA-ATRAS")
                                .resizable()
                                .frame(width: 180 * ap.constantes.scaleFactor, height: 200 * ap.constantes.scaleFactor)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(coleccion.color, coleccion.color.darken(by: 0.2))
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
                                    .frame(width: 150, height: 210)
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
                    .frame(height: 210 * ap.constantes.scaleFactor)
                    .onAppear {
                        if coleccion.tipoMiniatura == .abanico && coleccion.miniaturasBandeja.isEmpty {
                            coleccion.precargarMiniaturas()
                        }
                    }
                    .onChange(of: coleccion.tipoMiniatura) {
                        if coleccion.tipoMiniatura == .abanico && coleccion.miniaturasBandeja.isEmpty {
                            coleccion.precargarMiniaturas()
                        }
                    }
                                
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
                                .textoAdaptativo(t: ap.constantes.titleSize, a: 0.6, l: 2, b: true, alig: .leading, mW: .infinity, fAlig: .leading)
                        }
                        
                        HStack(spacing: 20) {
                            Text("3.25 GB")
                                .textoAdaptativo(t: ap.constantes.subTitleSize, a: 0.6, l: 1, b: false, c: .secondary, alig: .leading, s: true)
                            Text("\(coleccion.totalArchivos) elementos")
                                .textoAdaptativo(t: ap.constantes.subTitleSize, a: 0.6, l: 1, b: false, c: .secondary, alig: .leading, s: true)
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    }
                    
                }
            }
            .disabled(me.seleccionMultiplePresionada)
        }
        .frame(width: width, height: height)
    }
}


