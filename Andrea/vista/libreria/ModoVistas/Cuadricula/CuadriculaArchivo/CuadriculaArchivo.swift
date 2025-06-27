import SwiftUI

struct CuadriculaArchivo: View {
    
    @ObservedObject var archivo: Archivo
    let colorColeccion: Color
    @State private var isVisible = false
    var width: CGFloat = 180  // Esto lo puedes inyectar dinámicamente

    var body: some View {
        VStack(spacing: 0) {

            // --- Imagen ---
            ZStack {
                
                Image(uiImage: archivo.imagenArchivo.uiImage)
                    .resizable()
                    .frame(maxWidth: .infinity)
                
                // --- Progreso ---
                VStack {
                    Spacer()
                    ProgresoCuadricula(archivo: archivo, colorColeccion: colorColeccion)
                }
                
            }
            .frame(width: width) // solo limitamos ancho
            
            // --- Titulo e informacion ---
            TituloInformacion(archivo: archivo, colorColeccion: colorColeccion)
            
        }
        .frame(width: width, height: 310)
        .background(Color(.systemGray6))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.6), radius: 7, x: 0, y: 3)
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            
            archivo.crearMiniaturaPortada()
            
            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0...0.2))) {
                isVisible = true
            }
        }
    }
}

