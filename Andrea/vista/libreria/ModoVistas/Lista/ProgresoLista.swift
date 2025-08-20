
import SwiftUI

struct ProgresoLista: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    @ObservedObject var coleccionVM: ModeloColeccion
    @Binding var progresoMostrado: Int
    
    var body: some View {
        HStack(spacing: 10) {
            
            if archivo.progreso > 0 && ap.porcentajeNumero {
                HStack(spacing: 0) {
                    Text("%")
                        .font(.system(size: ap.porcentajeNumeroSize * 0.75))
                        .bold()
                        .foregroundColor(coleccionVM.color)
                        .offset(y: 1.5)
                    Color.clear
                        .animatedProgressText1(progresoMostrado)
                        .font(.system(size: ap.porcentajeNumeroSize * 1.1))
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
            
            if ap.porcentajeBarra && ap.porcentajeEstilo == .dentroCarta {
                GeometryReader { geo in
                    let totalWidth = geo.size.width
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(progresoMostrado > 0 ? Color.gray.opacity(0.7) : Color.gray.opacity(0.3))
                            .frame(height: 3)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(coleccionVM.color)
                            .frame(width: totalWidth * CGFloat(progresoMostrado) / 100.0, height: 3)
                            .animacionDesvanecer(coleccionVM.color) // <- necesaria para cambiar de color con animacion
                    } //FIN ZSTACK PROGRESSVIEW
                }
                .frame(height: 3)
                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
            }
            
        }
    }
}
