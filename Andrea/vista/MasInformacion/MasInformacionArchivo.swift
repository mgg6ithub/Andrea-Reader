
import SwiftUI

#Preview {
    PreviewMasInformacion()
}

private struct PreviewMasInformacion: View {
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

struct MasInformacionArchivo: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    // --- PARAMETROS ---
    @ObservedObject var archivo: Archivo
    
    // --- ESTADO ---
    @Binding var pantallaCompleta: Bool
    
    private let opacidad: CGFloat = 0.15
    
    private var isSmall: Bool { ap.resolucionLogica == .small }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 0) {
                    if !isSmall {
                        HStack(spacing: 15) {
                            MiniaturaEinformacion(vm: vm, archivo: archivo, opacidad: opacidad, isSmall: isSmall)
                        }
                    } else {
                        VStack(alignment: .center, spacing: 20) {
                            MiniaturaEinformacion(vm: vm, archivo: archivo, opacidad: opacidad, isSmall: isSmall)
                        }
                    }
                    
                    if !isSmall {
                        HStack(spacing: 15) {
                            ProgresoLecturaView(
                                   completado: archivo.progresoEntero,
                                   tiempo: 0.36,
                                   paginasLeidas: archivo.paginaActual,
                                   paginasTotales: archivo.totalPaginas!,
                                   horasLeidas: 3,
                                   minutosLeidos: 0,
                                   opacidad: opacidad,
                                   isSmall: isSmall
                               )
                        
                        AccionesRapidasView(opacidad: opacidad, isSmall: isSmall)
                        }
                        .padding(.top, 15)
                        
                        HStack(spacing: 15) {
                            
                            EstadisticasAvanzadas(opacidad: opacidad, isSmall: isSmall)
                            
                            VStack(alignment: .center, spacing: 0) {
                                InfoAvanzadaArchivoView(archivo: archivo, vm: vm, opacidad: opacidad)
                                
                                NotasArchivo(opacidad: opacidad)
                                    .padding(.top, 15)
                                
                                Spacer()
                            }
                            
                        }
                        .frame(height: 580)
                        .padding(.top, 15)
                        
                        InfoAvanzadaArchivoView1(archivo: archivo, vm: vm, opacidad: opacidad)
                            .padding(.top, 15)
                        
                        
                    } else {
                        ProgresoLecturaView(
                                completado: archivo.progresoEntero,
                               tiempo: 0.36,
                                paginasLeidas: archivo.paginaActual,
                                paginasTotales: archivo.totalPaginas!,
                               horasLeidas: 3,
                               minutosLeidos: 0,
                               opacidad: opacidad,
                               isSmall: isSmall
                           )
                        .padding(.top, 25)
                    
                        AccionesRapidasView(opacidad: opacidad, isSmall: isSmall)
                            .padding(.top, 25)
                            
                        EstadisticasAvanzadas(opacidad: opacidad, isSmall: isSmall)
                            .padding(.top, 25)
                        
                        InfoAvanzadaArchivoView(archivo: archivo, vm: vm, opacidad: opacidad)
                            .padding(.top, 25)
                        
                        NotasArchivo(opacidad: 0.05)
                            .padding(.top, 25)
                        
                        InfoAvanzadaArchivoView1(archivo: archivo, vm: vm, opacidad: opacidad)
                            .padding(.top, 15)
                        
                    }
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .padding(.top, 15)
            }
            
        }

    }
}

struct NotasArchivo: View {
    
    let opacidad: CGFloat
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(0.1))
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("NOTAS")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<5) { index in
                            NotaCard(
                                titulo: "Nota \(index+1)",
                                descripcion: "Descripción breve de la nota para el archivo, indicando su contexto y relevancia.",
                                pagina: Int.random(in: 1...120),
                                color: [.yellow, .green, .blue, .pink, .orange][index % 5],
                                icono: ["star.fill", "pencil", "bookmark.fill", "flag.fill", "bolt.fill"][index % 5]
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
            }
        }
    }
}

struct NotaCard: View {
    let titulo: String
    let descripcion: String
    let pagina: Int
    let color: Color
    let icono: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: icono)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(titulo)
                    .font(.headline)
                Text(descripcion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    Text("Página \(pagina)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button {
                        // acción ir a página
                    } label: {
                        Text("Ir")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(color.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct MiniaturaEinformacion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var puntuacion: Double = 5.0 // puedes cambiar este valor
    
    @ObservedObject var vm: ModeloColeccion
    @ObservedObject var archivo: Archivo
    let opacidad: CGFloat
    let isSmall: Bool
    
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @State private var show1: Bool = false

    var body: some View {
        
            if let img = viewModel.miniatura {
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 240 * ap.constantes.scaleFactor, height: 360 * ap.constantes.scaleFactor)
                    .cornerRadius(18)
                    .aparicionStiffness(show: $show1)
            } else {
                ProgressView()
            }
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(opacidad))
                    .frame(height: isSmall ? 360 * 1.5 : 360)
                    .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
                        )
                    .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                    .zIndex(0)
                
                VStack(alignment: .center, spacing: 8) { // ahora leading
                    if !isSmall {
                        HStack(alignment: .top, spacing: 30) { // alinear por arriba
                            TituloDescripcion(archivo: archivo, isSmall: isSmall)
                        }
                    }
                    else {
                        VStack(alignment: .center, spacing: 15) {
                            TituloDescripcion(archivo: archivo, isSmall: isSmall)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    if isSmall {
                        VStack(alignment: .center) {
                            HStack(spacing: isSmall ? 25 : 50) {
                                RectanguloDato(nombre: "Páginas", dato: "\(String(describing: archivo.totalPaginas ?? 0))", icono: "book.pages", color: .blue)
                                RectanguloDato(nombre: "Tamaño", dato: ManipulacionSizes().formatearSize(archivo.fileSize), icono: "externaldrive", color: .red)
                            }
                            
                            HStack(spacing: isSmall ? 25 : 50) {
                                RectanguloDato(nombre: "Extensión", dato: ManipulacionSizes().formatearSize(archivo.fileSize), icono: "books.vertical", color: .purple)
                                RectanguloDato(nombre: "Género", dato: "Fantasía", icono: "theatermasks", color: .green)
                            }
                            
                            HStack(spacing: isSmall ? 25 : 50) {
                                RectanguloDato(nombre: "Idioma", dato: "Español", icono: "globe", color: .orange)
                                RectanguloDato(nombre: "Publicado", dato: archivo.fechaPublicacion ?? "desconocido", icono: "calendar", color: .pink)
                            }
                        }
                    } else {
                        HStack(spacing: 50) {
                            RectanguloDato(nombre: "Páginas", dato: "\(String(describing: archivo.totalPaginas ?? 0))", icono: "book.pages", color: .blue)
                            RectanguloDato(nombre: "Tamaño", dato: ManipulacionSizes().formatearSize(archivo.fileSize), icono: "externaldrive", color: .red)
                            RectanguloDato(nombre: "Extensión", dato: "\(String(describing: archivo.fileExtension))", icono: "books.vertical", color: .purple)
                        }
                        .padding(.bottom, 15)

                        HStack(spacing: 50) {
                            RectanguloDato(nombre: "Género", dato: "Fantasía", icono: "theatermasks", color: .green)
                            RectanguloDato(nombre: "Idioma", dato: "Español", icono: "globe", color: .orange)
                            RectanguloDato(nombre: "Publicado", dato: archivo.fechaPublicacion ?? "desconocido", icono: "calendar", color: .pink)
                        }
                    }
                    
                }
                .padding(15)
                .onAppear {
                    viewModel.loadThumbnail(color: vm.color, for: archivo)
                }
                .onDisappear {
                    viewModel.unloadThumbnail(for: archivo)
                }
            }
//            .aparicionBlur(show: $show)
    }
}

struct TituloDescripcion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    
    var puntuacion: Double = 5.0 // puedes cambiar este valor
    let isSmall: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) { // ahora leading
            Text(archivo.nombre)
                .textoAdaptativo(t: ap.constantes.titleSize, a: 0.7, l: 3, alig: .center)
            
            Text("por autor")
                .textoAdaptativo(t: ap.constantes.subTitleSize, a: 0.7, l: 1, alig: .center)
            
            // Sistema de puntuación
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: index < Int(puntuacion) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                Text(String(format: "%.1f", puntuacion))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
        }
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Descripción")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("He creado una librería completamente modernizada He creado una librería completamente modernizada. He creado una librería completamente modernizada. He creado una librería completamente modernizada. He creado una librería completamente modernizada.")
                .textoAdaptativo(t: ap.constantes.subTitleSize, a: 0.6, l: 4, alig: .leading)
        }
    }
}

struct RectanguloDato: View {
    
    let nombre: String
    let dato: String
    let icono: String
    let color: Color
    
    var ancho: CGFloat { 120 }
    var alto: CGFloat { 80 }
     
    let opacidad: CGFloat = 0.1
    
    var body: some View {
        ZStack(alignment: .center) {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(opacidad))
                .frame(width: ancho, height: alto)
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .center, spacing: 10) {
                HStack(spacing: 10) {
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

struct EstadisticasAvanzadas: View {
    
    let opacidad: CGFloat
    let isSmall: Bool
    
//    @State private var show: Bool = true
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(opacidad))
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .center, spacing: 15) {
                
                Text("Estadísticas de lectura")
                    .font(.headline)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                RectanguloEstadisticaAvanzada(
                                    nombre: "TIEMPO RESTANTE",
                                    dato: "1h 55m",
                                    descripcion: "Estimación basada en tu ritmo actual de lectura",
                                    icono: "hourglass.bottomhalf.fill",
                                    color: .blue,
                                    ancho: 60,
                                    alto: 60
                                )
                                
                                RectanguloEstadisticaAvanzada(
                                    nombre: "VELOCIDAD DE LECTURA",
                                    dato: "2 pág/m",
                                    descripcion: "Tu ritmo promedio de lectura",
                                    icono: "speedometer",
                                    color: .orange,
                                    ancho: 60,
                                    alto: 60
                                )
                                
                                RectanguloEstadisticaAvanzada(
                                    nombre: "PÁGINAS RESTANTES",
                                    dato: "39 páginas",
                                    descripcion: "Te falta el 30% por completar",
                                    icono: "book.pages.fill",
                                    color: .purple,
                                    ancho: 60,
                                    alto: 60
                                )
                                
                                RectanguloEstadisticaAvanzada(
                                    nombre: "PÁGINA MÁS VISITADA",
                                    dato: "Página 34",
                                    descripcion: "Tu página favorita para releer",
                                    icono: "bookmark.fill",
                                    color: .green,
                                    ancho: 60,
                                    alto: 60
                                )
                
                Spacer()
                
            }
            .padding(15)
        }
        .frame(width: isSmall ? nil : 330)
        
    }
}


struct RectanguloEstadisticaAvanzada: View {
    
    let nombre: String
    let dato: String
    let descripcion: String
    let icono: String
    let color: Color
    
    let ancho: CGFloat
    let alto: CGFloat
    
    
    var body: some View {
        ZStack(alignment: .center) {
            
            RoundedRectangle(cornerRadius: 15)
                .fill(color.opacity(0.1).gradient)
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.3).gradient)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: icono)
                            .font(.title2)
                            .foregroundColor(color)
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(nombre)
                        .font(.subheadline)
                    Text(dato)
                        .bold()
                    Text(descripcion)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
            }
            
        }
        .padding(.horizontal, 5)
        .frame(height: 110)
    }
}


struct InfoAvanzadaArchivoView: View {
    
    // --- PARAMETROS ---
    @ObservedObject var archivo: Archivo
    @ObservedObject var vm: ModeloColeccion
    
    let opacidad: CGFloat
    
    var body: some View {
        
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(opacidad))
                .frame(height: 225)
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Información del Archivo")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                GrupoDatoAvanzado(nombre: "Dimensiones portada", valor: "1234 x 1234")
                GrupoDatoAvanzado(nombre: "Extensión", valor: "cbr")
                GrupoDatoAvanzado(nombre: "Formato", valor: EnumDescripcionArchivo.descripcion(for: archivo.fileType))
                GrupoDatoAvanzado(nombre: "Ruta absoluta", valor: "\(archivo.url)")

            }
            .padding()
        }
    }
}

struct InfoAvanzadaArchivoView1: View {
    
    // --- PARAMETROS ---
    @ObservedObject var archivo: Archivo
    @ObservedObject var vm: ModeloColeccion
    
    let opacidad: CGFloat
    
    @State private var masInfoAvanzada: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(opacidad))
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Información avanzada")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                GrupoDatoAvanzado(nombre: "Pertenece a la colección", valor: vm.coleccion.nombre)
                GrupoDatoAvanzado(nombre: "Numero de la colección", valor: "\(archivo.numeroDeLaColeccion ?? 0)")
                GrupoDatoAvanzado(nombre: "Nombre original", valor:  archivo.nombreOriginal ?? "desconocido")
                GrupoDatoAvanzado(nombre: "Ruta absoluta", valor: "\(archivo.url)")
                GrupoDatoAvanzado(nombre: "Ruta relativa", valor: "\(archivo.relativeURL)")
                
                Button(action: {
                    masInfoAvanzada.toggle()
                }) {
                    HStack(spacing: 5) {
                        Text("Más informacion")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                        
                        Image(systemName: "chevron.forward")
                            .rotationEffect(.degrees(masInfoAvanzada ? 90 : 0))
                    }
                }
                .buttonStyle(.plain)
                
                if masInfoAvanzada {
                    VStack(alignment: .leading, spacing: 10) {
                        GrupoDatoAvanzado(nombre: "Editorial", valor: "Marvel")
                        GrupoDatoAvanzado(nombre: "Formato de escaneo", valor: archivo.formatoEscaneo ?? "desconocido")
                        GrupoDatoAvanzado(nombre: "Entidad del escaneador", valor: archivo.entidadEscaneo ?? "desconocido")
                        GrupoDatoAvanzado(nombre: "Resolución", valor: "333 pp")
                        GrupoDatoAvanzado(nombre: "Peso", valor: "2.13")
                        GrupoDatoAvanzado(nombre: "Fecha de creación", valor: "\(archivo.fechaImportacion)")
                        GrupoDatoAvanzado(nombre: "Numero de aperturas", valor: "fechaCreacion")
                        GrupoDatoAvanzado(nombre: "Primera lectura", valor: "fechaCreacion")
                        GrupoDatoAvanzado(nombre: "Última lectura", valor: "ultimaLectura")
                        GrupoDatoAvanzado(nombre: "Última modificación", valor: "ultimaLectura")
                        GrupoDatoAvanzado(nombre: "Formato", valor: "formato")
                        GrupoDatoAvanzado(nombre: "ID único", valor: "idUnico")
                        GrupoDatoAvanzado(nombre: "ISBN", valor: "123123123")
                    }
                }
            }
            .padding()
        }
    }
}


struct GrupoDatoAvanzado: View {
    let nombre: String
    @State var valor: String
    @State private var editando = false

    var body: some View {
        HStack(alignment: .top) {
            Text(nombre)
                .foregroundColor(.secondary)

            Spacer()

            if editando {
                TextField("", text: $valor, onCommit: {
                    print("Nuevo valor: \(valor)")
                    editando = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 200, alignment: .trailing)
            } else {
                Text(valor)
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.5)
                    .lineLimit(5)
                    .onTapGesture {
                        editando = true
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}



struct AccionesRapidasView: View {
    
    let opacidad: CGFloat
    let isSmall: Bool
    
//    @State private var show: Bool = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(opacidad))
                .frame(height: isSmall ? nil : 170)
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Acciones")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                if isSmall {
                    VStack(alignment: .center, spacing: 30) {
                        HStack(spacing: 40) {
                            BotonAccion(icono: "star.fill", titulo: "Favorito", color: .yellow)
                            BotonAccion(icono: "lock.shield", titulo: "Proteger", color: .black)
                        }
                        
                        HStack(spacing: 40) {
                            BotonAccion(icono: "square.and.arrow.up", titulo: "Compartir", color: .orange)
                            BotonAccion(icono: "trash", titulo: "Eliminar", color: .red)
                        }
                    }
                } else {
                    HStack(spacing: 15) {
                        BotonAccion(icono: "star.fill", titulo: "Favorito", color: .yellow) { print("FAVORITO") }
                        BotonAccion(icono: "lock.shield", titulo: "Proteger", color: .black, dosColores: true)
                        BotonAccion(icono: "square.and.arrow.up", titulo: "Compartir", color: .orange)
                        BotonAccion(icono: "trash", titulo: "Eliminar", color: .red)
                    }
                }
                
            }
            .padding()
        }
//        .aparicionBlur(show: $show)
    }
}

struct BotonAccion: View {
    let icono: String
    let titulo: String
    let color: Color
    let dosColores: Bool
    let c1: Color
    let c2: Color
    let action: () -> Void
    
    @State private var show: Bool = false
    
    init(
        icono: String,
        titulo: String,
        color: Color,
        dosColores: Bool = false,
        c1: Color = .red,
        c2: Color = .gray,
        action: @escaping () -> Void = {}
    ) {
        self.icono = icono
        self.titulo = titulo
        self.color = color
        self.dosColores = dosColores
        self.c1 = c1
        self.c2 = c2
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 85, height: 85)
                    .overlay(
                        Group {
                            if dosColores {
                                Image(systemName: icono)
                                    .font(.title2)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(c2, c1)
                            } else {
                                Image(systemName: icono)
                                    .font(.title2)
                                    .foregroundColor(color)
                            }
                        }
                        .aparicionStiffness(show: $show)
                    )
                Text(titulo)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct ProgresoLecturaView: View {
    var completado: Double // 0.0 a 1.0
    var tiempo: Double // 0.0 a 1.0
    var paginasLeidas: Int
    var paginasTotales: Int
    var horasLeidas: Int
    var minutosLeidos: Int
    
    let opacidad: CGFloat
    let isSmall: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(opacidad))
                .frame(width: isSmall ? nil : 330)
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(spacing: 20) {
                Text("Progreso de Lectura")
                    .font(.headline)
                
                HStack(spacing: 80) {
                    // Progreso completado
                    VStack {
                        ProgresoCircular(valor: completado, color: .blue)
                        Text("Completado")
                            .font(.subheadline)
                        Text("\(paginasLeidas)/\(paginasTotales) páginas")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Tiempo
                    VStack {
                        ProgresoCircular(valor: tiempo, color: .green)
                        Text("Tiempo")
                            .font(.subheadline)
                        Text("\(horasLeidas)h \(minutosLeidos)m leído")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .frame(height: 160)
    }
}

struct ProgresoCircular: View {
    
    var valor: Double // 0.0 a 1.0
    var color: Color
    
    @State private var show: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.2)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(valor))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: valor)
            
            Text("\(Int(valor * 100))%")
                .font(.headline)
        }
        .aparicionStiffness(show: $show)
        .frame(width: 60, height: 60)
    }
    
}


