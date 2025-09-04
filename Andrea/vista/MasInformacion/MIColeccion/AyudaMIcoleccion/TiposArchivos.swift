
import SwiftUI

#Preview {
    pMIcoleccion5()
}

//
private struct pMIcoleccion5: View {
    @State private var pantallaCompleta = true
    
    var body: some View {
        MasInfoCol(
            pantallaCompleta: $pantallaCompleta, vm: ModeloColeccion()
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct TiposArchivos: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    private var const: Constantes { ap.constantes }
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    private var sombraCarta: Color { esOscuro ? .black.opacity(0.4) : .black.opacity(0.1) }
//        .font(.system(size: const.titleSize * 0.9))
//        .foregroundColor(tema.secondaryText)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tipos de archivo")
                .font(.headline)
            Text("3 formatos distintos")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            GraficoGithubStyle()
            //ocupe el 55% porciento del width de la pantalla
        }
        .frame(width: 400)
            
        Spacer()
            
        VStack(alignment: .center, spacing: 8) {
            Text("Última importación")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Image("ojo")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(radius: 3)
            
            Text("One Piece Vol. 1")
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center) // 🔹 permite varias líneas
            
            Button(action: {
                
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "book.fill")
                    Text("Leer ahora")
                }
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous) // 🔹 menos radius
                        .fill(vm.color.opacity(0.2))
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.trailing, 55)
    }
}
