import SwiftUI

struct RealElementView: View {
    let element: any ElementoSistemaArchivosProtocolo
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 0) {
            
            // --- Imagen (75% de alto)
            ZStack {
                if let cbz = element as? CBZArchivo,
                   let imagen = cbz.imagenMiniatura {
                    Image(uiImage: imagen)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } else {
                    // Placeholder si no hay imagen
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
            .frame(height: 165) // 75% de 220
            
            // --- Texto e info (25% de alto)
            VStack(spacing: 4) {
                Text(element.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)

                if let coleccion = element as? Coleccion {
                    Button(action: {
                        coleccion.meterColeccion(coleccion: coleccion)
                    }) {
                        Text("Entrar")
                            .font(.caption)
                            .padding(.top, 2)
                    }
                } else {
                    HStack(spacing: 6) {
                        ForEach(["Dato 1", "Dato 2", "Dato 3"], id: \.self) { dato in
                            Text(dato)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .frame(height: 55) // 25% de 220
            .padding(.horizontal, 6)
            .padding(.top, 6)

        }
        .frame(width: 150, height: 220)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0...0.2))) {
                isVisible = true
            }
        }
        .clipped()
    }
}


