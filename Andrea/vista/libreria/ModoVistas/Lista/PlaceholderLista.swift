
import SwiftUI

struct PlaceholderLista: View {
    
    @EnvironmentObject var appEstado: AppEstado
    
    let placeholder: ElementoPlaceholder
    @ObservedObject var coleccionVM: ModeloColeccion
    
    var body: some View {
        HStack(spacing: 0) {
            
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: coleccionVM.altura - 47.5)
            
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 16)
                    Spacer()
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 16)
                    Spacer()
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.7))
                        .frame(height: 4)
                        .padding(.horizontal, 10)
                    
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 35, height: 14)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 35, height: 14)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 35, height: 14)
                }
            }
            .padding()
        }
        .frame(width: .infinity, height: coleccionVM.altura)
        .background(appEstado.temaActual.cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 8)) // <- Luego el recorte
    }
}
