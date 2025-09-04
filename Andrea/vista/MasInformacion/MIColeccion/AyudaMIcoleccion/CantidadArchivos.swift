
import SwiftUI

#Preview {
    pMIcoleccion()
}

//
private struct pMIcoleccion: View {
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

struct CantidadArchivos: View {
    
    @EnvironmentObject var ap: AppEstado
    
    private var const: Constantes { ap.constantes }
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Cantidad de archivos")
                .font(.headline)
            Text("140 en total")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Rectangle()
                .fill(Color.secondary.opacity(0.15))
                .frame(width: 220, height: 1)
                .padding(.vertical, 4)

            
            // Tamaño promedio
            HStack(spacing: 2) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: const.iconSize * 0.45))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .black)
                    .frame(width: 20, height: 20)
                Text("Tamaño promedio: 7 MB")
                    .font(.system(size: const.subTitleSize * 0.9))
                    .foregroundColor(tema.secondaryText)
            }
            
            // Archivo más grande
            HStack(spacing: 2) {
                Image(systemName: "arrow.up")
                    .font(.system(size: const.iconSize * 0.45))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .white)
                    .frame(width: 20, height: 20)
                Text("Más grande: 320 MB")
                    .font(.system(size: const.subTitleSize * 0.9))
                    .foregroundColor(tema.secondaryText)
            }
            
            // Archivo más pequeño
            HStack(spacing: 2) {
                Image(systemName: "arrow.down")
                    .font(.system(size: const.iconSize * 0.45))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .white)
                    .frame(width: 20, height: 20)
                Text("Más pequeño: 450 KB")
                    .font(.system(size: const.subTitleSize * 0.9))
                    .foregroundColor(tema.secondaryText)
            }
            
            Rectangle()
                .fill(Color.secondary.opacity(0.15))
                .frame(width: 220, height: 1)
                .padding(.vertical, 4)

            
            // Salud del almacenamiento
            HStack(spacing: 6) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: const.iconSize * 0.7))
                    .foregroundColor(.red)
                Text("Salud: estable (fragmentación baja)")
                    .font(.system(size: const.subTitleSize * 0.9))
                    .foregroundColor(tema.secondaryText)
            }
        }
        .frame(width: 280)
        
        Spacer()
        
        VStack(alignment: .center, spacing: 15) {
            ProgresoCircular(
                titulo: "tamaño",
                progreso: 56,
                progresoDouble: 0.56,
                color: .red,
                anchuraLinea: 12,
                radio: 120
            )
            
            VStack(alignment: .center, spacing: 4) {
                HStack(spacing: 3) {
                    Image(systemName: "externaldrive")
                        .font(.system(size: const.iconSize * 0.65))
                        .foregroundColor(.red.opacity(0.85))
                    Text("Almacenamiento")
                        .font(.system(size: const.titleSize * 0.75))
                        .foregroundColor(tema.tituloColor)
                }
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text("Ocupa")
                        .font(.system(size: const.subTitleSize * 0.65))
                        .foregroundColor(tema.secondaryText.opacity(0.8))
                    Text("1.5 GB")
                        .font(.system(size: const.subTitleSize * 0.75))
                        .foregroundColor(tema.secondaryText)
                    Text("de")
                        .font(.system(size: const.subTitleSize * 0.65))
                        .foregroundColor(tema.secondaryText.opacity(0.8))
                    Text("2 GB")
                        .font(.system(size: const.subTitleSize * 0.75))
                        .foregroundColor(tema.secondaryText)
                }
            }
        }
        .padding(.top, 15)
        .padding(.trailing, 45)

    }
}
