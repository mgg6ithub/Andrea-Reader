

import SwiftUI

struct TituloInformacion: View {
    
    let archivo: Archivo
    let colorColeccion: Color
    
    var progreso: Int { archivo.fileProgressPercentage }
    
    var body: some View {
        
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                Text(archivo.name)
                    .font(.system(size: ConstantesPorDefecto().titleSize))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                
                Color.clear
                    .animatedProgressText1(progreso)
                    .foregroundColor(colorColeccion)
                    .font(.system(size: ConstantesPorDefecto().subTitleSize))
                    .bold()
            }
            .padding(0)
            
            HStack {
                Text("\(archivo.fileType.rawValue)")
                    .font(.system(size: ConstantesPorDefecto().subTitleSize))
                    .foregroundColor(.gray)
                    .font(.system(size: 8))
                    .lineLimit(1) // Limita a una sola línea inicialmente
                    .minimumScaleFactor(0.8) // Reduce el tamaño hasta un 80% si es necesario
                    .truncationMode(.tail)

                Spacer()

                Text(String("\(archivo.fileSize / (1024 * 1024)) MB"))
                    .font(.system(size: ConstantesPorDefecto().subTitleSize))
                    .foregroundColor(.gray)
                    .font(.system(size: 8))
                    .lineLimit(1) // Limita a una sola línea inicialmente
                    .minimumScaleFactor(0.8) // Reduce el tamaño hasta un 80% si es necesario
                    .truncationMode(.tail)

                Spacer()

                Text("\(archivo.fileTotalPages) pages")
                    .foregroundColor(.gray)
                    .font(.system(size: ConstantesPorDefecto().subTitleSize)) // Usa el tamaño de fuente calculado
                    .lineLimit(1) // Limita a una sola línea inicialmente
                    .minimumScaleFactor(0.8) // Reduce el tamaño hasta un 80% si es necesario
                    .truncationMode(.tail)
            }
        }
        .padding(8)
        
    }
    
}
