
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
        ScrollView(.vertical, showsIndicators: false) {
            //cmabiar cuando es iphone a vertical
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Contenido(archivo: archivo, vm: vm)
                }
                .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 0) {
//                        if archivo.progreso == true && archivo.tiempoTotal == true {
                            
//                            HStack {
//                                Spacer()
//                                ImagenLibreriaVacia(imagen: "buhosf", texto: "Aun no has leido este comic! ¿A que esperas para hacerlo?", anchura: 200, altura: 200)
//                                Spacer()
//                            }

//                        } else {
                            ProgresoLectura(archivo: archivo)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.25))
                                .padding(.vertical, 20)
                                .padding(.horizontal, 10)
                            
                            ProgresoTiempo(archivo: archivo)
                                .padding(.bottom, 15)
//                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray.opacity(0.25), lineWidth: 1)
                    )

                
                VStack {
                    Text("hola")
                }
                .frame(height: 300)
            }
            
        }
        .padding(.horizontal, 20)
    }
}

struct Contenido: View {
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    @ObservedObject var vm: ModeloColeccion
    var body: some View {
        ImagenMiniatura(archivo: archivo, vm: vm)
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

struct RectanguloDato: View {
    
    let nombre: String
    let dato: String
    let icono: String
    let color: Color
    
    var ancho: CGFloat { 100 }
    var alto: CGFloat { 60 }
     
    let opacidad: CGFloat = 0.1
    
    var body: some View {
        ZStack(alignment: .center) {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(opacidad))
                .frame(width: ancho, height: alto)
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .center, spacing: 10) {
                HStack(spacing: 2.5) {
                    Image(systemName: icono)
                        .foregroundColor(color)
                    
                    Text(nombre)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .zIndex(1)
                
                Text(dato)
                    .font(.subheadline)
                    .bold()
            }
            
        }
    }
}


struct ImagenMiniatura: View {
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var archivo: Archivo
    @ObservedObject var vm: ModeloColeccion
    
    @StateObject private var viewModel = ModeloMiniaturaArchivo()

    var body: some View {
        ZStack {
            if let img = viewModel.miniatura {
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 220, height: 340 * ap.constantes.scaleFactor)
                    .cornerRadius(15)
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
            } else {
                ProgressView()
            }
                
        }
        .onAppear {
            viewModel.loadThumbnail(color: vm.color, for: archivo)
        }
        .onDisappear {
            viewModel.unloadThumbnail(for: archivo)
        }
    }
}

struct EditableStarRating: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let url: URL
    @Binding var puntuacion: Double // permite valores como 3.5
    let maxRating: Int = 5
    private var iz: CGFloat { ap.constantes.iconSize }
    
    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            
            ForEach(1...maxRating, id: \.self) { index in
                let starType = starImageType(for: index)
                
                Image(systemName: starType)
                    .font(.system(size: iz))
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            // Si ya está en media estrella, pasa a estrella completa; si está completa, baja a media
                            if puntuacion == Double(index) {
                                puntuacion = Double(index) - 0.5
                            } else {
                                puntuacion = Double(index)
                            }
                        }
                        PersistenciaDatos().guardarDatoElemento(url: url, atributo: "puntuacion", valor: puntuacion)
                    }
            }
            
            Spacer()
            
            Text(String(format: "%.1f", puntuacion))
                .textoAdaptativo(t: ap.constantes.subTitleSize * 0.9, a: 0.6, l: 1, alig: .center, mW: 25)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let totalWidth = CGFloat(maxRating) * (iz + 4) - 4
                    let clampedX = min(max(value.location.x, 0), totalWidth)
                    let rawStars = Double(clampedX / (totalWidth / CGFloat(maxRating)))
                    
                    // Redondear a media estrella
                    let halfStep = (rawStars * 2).rounded() / 2
                    puntuacion = min(Double(maxRating), max(0.5, halfStep))
                }
                .onEnded { _ in
                    PersistenciaDatos().guardarDatoElemento(url: url, atributo: "puntuacion", valor: puntuacion)
                }
        )
    }
    
    private func starImageType(for index: Int) -> String {
            if puntuacion >= Double(index) {
                return "star.fill"
            } else if puntuacion >= Double(index) - 0.5 {
                return "star.lefthalf.fill"
            } else {
                return "star"
            }
        }
    
}
