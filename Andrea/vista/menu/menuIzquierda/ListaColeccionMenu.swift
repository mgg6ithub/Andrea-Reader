import SwiftUI

struct ListaColeccionMenu: View {
    
    @EnvironmentObject var ap: AppEstado
    private let sa: SistemaArchivos = SistemaArchivos.sa
    
    var body: some View {
        List {
            ForEach(Array(sa.cacheColecciones), id: \.key) { (url, colValor) in
                VStack(spacing: 0) {
                    Button(action: {
                        // Acción al tocar la colección
                    }) {
                        HStack {
                            Circle()
                                .fill(colValor.coleccion.color)
                                .frame(width: 35, height: 35)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(colValor.coleccion.nombre)
                                    .font(.system(size: 17))
                                    .bold()
                                
                                Text("33 archivos")
                                    .font(.system(size: 12))
                                    .foregroundColor(ap.temaActual.secondaryText)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 30 * 0.6))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity) // <- Importante: ocupa todo el ancho
                        .background(ap.temaActual.backgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    // Línea de separación personalizada
                    Rectangle()
                        .fill(Color.white) // O ap.temaActual.separatorColor
                        .frame(height: 1)
                        .padding(.leading, 50)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets()) // <- Elimina los insets del sistema
            }
        }
        .scrollContentBackground(.hidden)
        .background(ap.temaActual.backgroundColor)
        .listStyle(.plain)
        .listRowSeparator(.hidden) // <- Bien, pero reforzado por lo anterior
    }
}




