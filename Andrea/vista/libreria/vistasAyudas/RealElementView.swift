import SwiftUI

struct RealElementView: View {
    let element: any ElementoSistemaArchivosProtocolo
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 100, height: 140)

                Image(systemName: "book.closed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray.opacity(0.5))
            }

            Text(element.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(width: 120, alignment: .center)

            if let coleccion = element as? Coleccion {
                
                Button(action: {
                    coleccion.meterColeccion(coleccion: coleccion)
                }) {
                    Text("Entrar")
                }
                
            } else {
                HStack(spacing: 6) {
                    ForEach(["Dato 1", "Dato 2", "Dato 3"], id: \.self) { dato in
                        Text(dato)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .frame(width: 36, alignment: .leading)
                    }
                }
            }

        }
        .padding()
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
    }
}

