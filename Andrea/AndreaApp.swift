

import SwiftUI
import TipKit

@main
struct AndreaApp: App {
    
    init() { 
         //Creamos la instancia de TipKit en la vista padre
        var _ = SistemaArchivos.sa //Inicializamos el sistema de archivos
    }
    
    var body: some Scene {
        WindowGroup {
            AndreaAppView()
                .task {
//                    try? Tips.resetDatastore()
//                    try? Tips.configure(
//                        [   .displayFrequency(.daily),
//                            .datastoreLocation(.applicationDefault)
//                        ]
//                    )
                    try? Tips.resetDatastore()
                    try? Tips.configure(
                        [
                            .datastoreLocation(.applicationDefault)
                        ]
                    )
                }
        }
    }
}


struct MiniaturaHolograficaView: View {
    @State private var selectedOption = "Aleatoria"
    let options = ["Imagen base", "Primera imagen", "Aleatoria", "Personalizada"]

    var body: some View {
        VStack(spacing: 20) {
            
            // Segmentos superiores con animación
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                        .foregroundColor(selectedOption == option ? .white : .gray)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            ZStack {
                                if selectedOption == option {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.cyan.opacity(0.6))
                                        .matchedGeometryEffect(id: "selector", in: namespace)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                selectedOption = option
                            }
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
            )
            .padding(.top, 30)
            
            Spacer()
            
            // Imagen con borde brillante
            Image("ojo") // pon tu asset
                .resizable()
                .frame(width: 250, height: 370)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan, lineWidth: 2)
                        .shadow(color: .cyan, radius: 12)
                )
                .shadow(color: .cyan.opacity(0.6), radius: 25)
            
            Spacer()
            
            // Panel inferior con información
            VStack(alignment: .leading, spacing: 12) {
                infoRow("Ruta:", "/Documentos/Comics/Ivy23.pdf")
                infoRow("Tipo:", "Miniatura generada")
                infoRow("Dimensiones:", "400 x 600 px")
                infoRow("Calidad:", "Alta")
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 25)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    @Namespace private var namespace
    
    // helper para filas de texto
    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 16))
        }
    }
}



struct MiniaturaHolograficaView_Previews: PreviewProvider {
    static var previews: some View {
        MiniaturaHolograficaView()
    }
}


