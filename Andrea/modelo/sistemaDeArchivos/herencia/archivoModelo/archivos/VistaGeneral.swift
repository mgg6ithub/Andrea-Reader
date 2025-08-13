
import SwiftUI

struct ArchivoIncompatibleView: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var archivo: Archivo
    @Environment(\.dismiss) private var dismiss
    
    private var escala: CGFloat { ap.constantes.scaleFactor }

    var body: some View {
        VStack(spacing: 24) {
            // Card con mensaje
            VStack(spacing: 16) {
                Image("error-no-b")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240 * escala, height: 240 * escala)

                Text("No se puede mostrar este archivo")
                    .textoAdaptativo(t: ap.constantes.titleSize, a: 1.0, l: 1, c: ap.temaActual.colorContrario, alig: .center)
                
                Text("El archivo no cumple con el protocolo requerido")
                    .textoAdaptativo(t: ap.constantes.subTitleSize, a: 0.9, l: 1, c: ap.temaActual.secondaryText, alig: .center)
            }
            .padding(24 * escala)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ap.temaActual.backgroundColor)
                    .shadow(color: ap.temaActual == .dark ? .black.opacity(0.3) : .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal)

            // Botón Atrás
            Button(action: {
                dismiss()
            }) {
                Text("Volver atrás")
                    .padding(12 * escala)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(ap.temaActual.backgroundColor)
                            .shadow(color: ap.temaActual == .dark ? .black.opacity(0.15) : .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .textoAdaptativo(t: ap.constantes.subTitleSize, a: 1.0, l: 1, c: ap.temaActual.colorContrario, alig: .center)
            }
        }
        .onAppear {
            print("⚠️ El archivo \(archivo) no cumple ProtocoloComic")
        }
    }
}
