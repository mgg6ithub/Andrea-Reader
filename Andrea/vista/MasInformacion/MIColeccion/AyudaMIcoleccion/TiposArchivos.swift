
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
                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct TiposArchivos: View {
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    @State private var formatosDiferentes: Int = 0
    
    private var const: Constantes { ap.constantes }
    private var tema: EnumTemas { ap.temaResuelto }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tipos de archivo")
                .font(.headline)
            
            Text("\(formatosDiferentes) formatos diferentes")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            GraficoGithubStyle(estadisticas: vm.estadisticasColeccion)
        }
        .onReceive(vm.estadisticasColeccion.$distribucionTipos) { nuevosTipos in
            formatosDiferentes = nuevosTipos.count
        }
//        .frame(width: 400)
        
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
                .multilineTextAlignment(.center)
            
            Button(action: { }) {
                HStack(spacing: 6) {
                    Image(systemName: "book.fill")
                    Text("Leer ahora")
                }
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(vm.color.opacity(0.2))
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.trailing, 55)
    }
}

