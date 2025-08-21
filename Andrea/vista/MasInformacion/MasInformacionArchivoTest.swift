
import SwiftUI

#Preview {
    PreviewMasInformacion1()
}
//
private struct PreviewMasInformacion1: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInformacion(
            pantallaCompleta: $pantallaCompleta,
            vm: ModeloColeccion(),
            elemento: Archivo.preview
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct MasInformacionArchivoTest: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    // --- PARAMETROS ---
    @ObservedObject var archivo: Archivo
    
    // --- ESTADO ---
    @Binding var pantallaCompleta: Bool
    let escala: CGFloat
    
    private let opacidad: CGFloat = 0.15
    
    private var isSmall: Bool { ap.resolucionLogica == .small }
    
    var body: some View {
        ScrollView(.vertical) {
            //cmabiar cuando es iphone a vertical
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Contenido(archivo: archivo)
                }
                .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 0) {
                    ProgresoLectura()
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.25))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 10)
                    
                    ProgresoTiempo()
                        .padding(.bottom, 15)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray.opacity(0.25), lineWidth: 1)
                )
                
                VStack {
                    Text("hola")
                }
                .frame(height: 300)
                
                
//                ProgresoTiempo()
            }
//            .padding(.leading, 30)
//            .padding(.vertical, 100)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .overlay(
//                RoundedRectangle(cornerRadius: 15)
//                    .stroke(.gray.opacity(0.25), lineWidth: 1)
//            )
//            .padding(.top, 10)
            
        }
        .padding(.horizontal, 20)
    }
}

struct Contenido: View {
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    
    var body: some View {
        ImagenMiniatura(archivo: archivo)
        //                        .frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Poison ivy")
                    .font(.system(size: 45))
                    .bold()
                
                if archivo.autor != nil {
                    HStack(spacing: 5) {
                        Text("por")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Text("Andrea Olivares")
                            .font(.system(size: 15))
                            .bold()
                    }
                    .padding(.leading, 15)
                    .padding(.vertical, 10)
                }
                
                Text("Esto es una descripcion sinmas algo de texto pero no decir nada algo mas de texto si si valo bien algo mas algo mas otra frase mas voty a cenar")
                    .font(.system(size: 15))
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.25))
                .padding(.vertical, 20)
            
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 0) {
                    RectanguloDato(nombre: "Páginas", dato: "\(String(describing: archivo.totalPaginas ?? 0))", icono: "book.pages", color: .blue)
                    Spacer()
                    RectanguloDato(nombre: "Tamaño", dato: ManipulacionSizes().formatearSize(archivo.fileSize), icono: "externaldrive", color: .red)
                    Spacer()
                    RectanguloDato(nombre: "Extensión", dato: "\(String(describing: archivo.fileExtension))", icono: "books.vertical", color: .purple)
                }
                
                HStack(spacing: 0) {
                    RectanguloDato(nombre: "Género", dato: "Fantasía", icono: "theatermasks", color: .green)
                    Spacer()
                    RectanguloDato(nombre: "Idioma", dato: "Español", icono: "globe", color: .orange)
                    Spacer()
                    RectanguloDato(nombre: "Publicado", dato: archivo.fechaPublicacion ?? "desconocido", icono: "calendar", color: .pink)
                }
                
            }
        } //FIN VSTACK INFORMACION DERECHA
        .frame(height: 320 * ap.constantes.scaleFactor)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray.opacity(0.25), lineWidth: 1)
        )
    }
}


struct ImagenMiniatura: View {
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var archivo: Archivo

    var body: some View {
        Image("ojo")
            .resizable()
            .frame(width: 220, height: 340 * ap.constantes.scaleFactor)
            .cornerRadius(15)
            // Degradado abajo
            .overlay(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(0.85), location: 0.0),
                        .init(color: .black.opacity(0.85), location: 0.7),
                        .init(color: .clear,                location: 1.0)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 85)
                .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
                .allowsHitTesting(false)
            }
            // Ojo + estrellas centrados y apilados
            .overlay(alignment: .bottom) {
                VStack(alignment: .center, spacing: 8) {
                    Image("custom-eye")
                        .renderingMode(.template)    // para tintar
                        .foregroundColor(.gray)
                        .padding(.top, 4)

                    EditableStarRating(url: archivo.url, puntuacion: $archivo.puntuacion)
                        .frame(maxWidth: .infinity, alignment: .center) // <-- fuerza ancho para centrar
                }
                .frame(maxWidth: .infinity)   // <-- ocupa todo el ancho del overlay
                .padding(.horizontal, 12)
                .padding(.bottom, 12)

            }
            .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
    }
}


struct ProgresoCircularTest: View {
    
    var valor: Double // 0.0 a 1.0
    var color: Color
    
    @State private var animatedValor: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.2)
                .foregroundColor(.secondary)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(animatedValor))
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: valor)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        animatedValor = valor
                    }
                }
            
            HStack(alignment: .bottom, spacing: 1.5) {
                Text("%")
                    .font(.system(size: 15))
                    .offset(y: -4)
                    .opacity(0.7)
                Color.clear
                    .animatedProgressText1(Int(valor) * 100)
                    .font(.system(size: 25))
            }
        }
        .frame(width: 90, height: 90)
    }
    
}
