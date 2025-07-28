import SwiftUI

struct ListaColeccionMenu: View {
    
    @EnvironmentObject var ap: AppEstado
    private let sa: SistemaArchivos = SistemaArchivos.sa
    
    var body: some View {
        VStack {
            ForEach(Array(sa.cacheColecciones), id: \.key) { (url, colValor) in
                
                let col = colValor.coleccion
                
                VStack(spacing: 0) {
                    Button(action: {
                        // Acción al tocar la colección
                    }) {
                        HStack {
                            Circle()
                                .fill(col.color)
                                .frame(width: 35, height: 35)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(col.nombre)
                                    .font(.system(size: 17))
                                    .bold()
                                
                                HStack(spacing: 5) {
                                    Text("\(col.totalArchivos) archivos")
                                        .font(.system(size: 12))
                                        .foregroundColor(ap.temaActual.secondaryText)
                                    
                                    Text("\(col.totalColecciones) colecciones")
                                        .font(.system(size: 12))
                                        .foregroundColor(ap.temaActual.secondaryText)
                                }
                            }
                            
                            Spacer()
                            
//                            Image(systemName: "chevron.forward")
//                                .font(.system(size: 30 * 0.6))
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity) // <- Importante: ocupa todo el ancho
                        .background(ap.temaActual.backgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    // Línea de separación personalizada
                    Rectangle()
                        .fill(Color.gray) // O ap.temaActual.separatorColor
                        .frame(height: 0.5)
                        .padding(.horizontal, 10)
                        .padding(.top, 3.5)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets()) // <- Elimina los insets del sistema
            }
            Spacer()
        }
    }
}




