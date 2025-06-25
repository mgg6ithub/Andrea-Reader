

import SwiftUI

struct TituloInformacion: View {
    
    let archivo: Archivo
    
    var body: some View {
        
        VStack(spacing: 4) {
            Text(archivo.name)
                .font(.system(size: ConstantesPorDefecto().titleSize))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
            
            HStack {
                Text("\(archivo.fileType)")
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
