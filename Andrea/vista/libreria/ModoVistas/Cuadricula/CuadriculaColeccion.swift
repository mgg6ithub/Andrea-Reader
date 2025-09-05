import SwiftUI

struct CuadriculaColeccion: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    // --- PARAMETROS ---
    @ObservedObject var coleccion: Coleccion
    var width: CGFloat
    var height: CGFloat
    
    // --- VAIRABLES CALCULADAS ---
    private let constantes = ConstantesPorDefecto()
    private var escala: CGFloat { ap.constantes.scaleFactor }
    private var isSmall: Bool { ap.constantes.resLog == .small }
    private var cDinamico: Color { ap.temaResuelto.colorContrario }
    private var cSec: Color { ap.temaResuelto.secondaryText }
    private var totalElementos: Int { coleccion.totalArchivos + coleccion.totalColecciones }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button(action: {
                coleccion.meterColeccion()
            }) {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    ZStack {
                        CheckerEncimaDelElemento(elementoURL: coleccion.url, topPadding: false)
                        
                        MiniaturaColeccionView(coleccion: coleccion, width: width * 0.95, height: height * 0.6)

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
                                .textoAdaptativo(t: ap.constantes.titleSize, a: 0.6, l: 2, b: true, c: cDinamico, alig: .leading, mW: .infinity, mH: 40, fAlig: .leading)
                        }
                        
                        HStack(spacing: 0) {
                            Text("3.25 GB")
                                .textoAdaptativo(t: ap.constantes.subTitleSize * 0.85, a: 0.6, l: 1, b: false, c: cSec, alig: .leading, s: false)
                            
                            Spacer()
                            
                            Text("\(totalElementos) elementos")
                                .textoAdaptativo(t: ap.constantes.subTitleSize * 0.85, a: 0.6, l: 1, b: false, c: cSec, alig: .trailing, s: false)
                        }
                        .padding(.leading, 5)
                        .padding(.trailing, 10)
                    }
                    .padding(.horizontal, 5)
                    
                }
                .offset(y: -10)
            }
            .disabled(me.seleccionMultiplePresionada)
        }
        .frame(width: width, height: height)
    }
}


