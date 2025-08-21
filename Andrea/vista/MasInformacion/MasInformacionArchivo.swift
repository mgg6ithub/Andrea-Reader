
import SwiftUI
import Charts

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
        
//        Text("")
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
                
                Text("Notas")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .offset(x: 5)
                
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
    
    @EnvironmentObject var ap: AppEstado
    
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
        .background(ap.temaActual.backgroundGradient.opacity(0.5))
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
        
            ZStack(alignment: .bottom) {
                
                if let img = viewModel.miniatura {
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 240 * ap.constantes.scaleFactor, height: 360 * ap.constantes.scaleFactor)
                        .cornerRadius(18)
                        .aparicionStiffness(show: $show1)
                } else {
                    ProgressView()
                }
            
                EditableStarRating(url: archivo.url, puntuacion: $archivo.puntuacion)
                    .background(.white, in: .capsule)
                    .padding(.bottom, 20)
                
                Image("custom-eye")
                    .background(.white, in: .capsule)
                    .offset(x: 60, y: -200)
                    .padding()
            }
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.clear)
                    .frame(height: isSmall ? 360 * 1.5 : 360)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black.opacity(0.6), lineWidth: 1) // borde gris oscuro
                        )
                    .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                    .zIndex(0)
                
                VStack(alignment: .center, spacing:	 8) { // ahora leading
                    if !isSmall {
                        HStack(alignment: .top, spacing: 15) { // alinear por arriba
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



struct TituloDescripcion: View {
    
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var archivo: Archivo
    let isSmall: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // ahora leading
            Text(archivo.nombre)
                .textoAdaptativo(t: ap.constantes.titleSize, a: 0.7, l: 3, alig: .center, mH: 80)
            
            Text("por \(archivo.autor)")
                .textoAdaptativo(t: ap.constantes.subTitleSize * 0.85, a: 0.7, l: 1, c: .secondary, alig: .center)
            
        }
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Descripción")
                .textoAdaptativo(t: ap.constantes.subTitleSize * 0.8, a: 0.6, l: 1, c: .secondary, alig: .leading)
            
            Text("He creado una librería completamente modernizada He creado una librería completamente modernizada. He creado una librería completamente modernizada. He creado una librería completamente modernizada. He creado una librería completamente modernizada.")
                .textoAdaptativo(t: ap.constantes.subTitleSize * 1.4, a: 0.6, l: 5, alig: .leading)
        }
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


struct EstadisticasAvanzadas: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let opacidad: CGFloat
    let isSmall: Bool
    
    @State private var modoVista: ModoVisualizacion = .lista
    
    enum ModoVisualizacion: CaseIterable {
        case lista
        case graficos
        
        var icono: String {
            switch self {
            case .lista: return "list.bullet.rectangle"
            case .graficos: return "chart.bar.fill"
            }
        }
        
        var titulo: String {
            switch self {
            case .lista: return "Lista"
            case .graficos: return "Gráficos"
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(opacidad))
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black.opacity(0.6), lineWidth: 2)
                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .center, spacing: 15) {
                
                // Header con título y botones de modo
                HStack {
                    Text("Estadísticas de lectura")
                        .textoAdaptativo(t: ap.constantes.titleSize * 0.85, a: 0.75, l: 1, b: true, alig: .leading)
                    
                    Spacer()
                    
                    // Selector de modo con estilo banner
                    HStack(spacing: 0) {
                        ForEach(ModoVisualizacion.allCases, id: \.self) { modo in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    modoVista = modo
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(modo.titulo)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(modoVista == modo ? .white : .secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(modoVista == modo ? Color.gray : Color.clear)
                                )
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    )
                }
                .padding(.horizontal, 10)
                
                // Contenido según el modo seleccionado
                Group {
                    if modoVista == .lista {
                        VistaLista()
                    } else {
                        VistaGraficos()
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: modoVista)
                
                Spacer()
            }
            .padding(15)
        }
        .frame(width: isSmall ? nil : 330)
    }
}

// Vista Lista (original)
struct VistaLista: View {
    var body: some View {
        VStack(spacing: 0) {
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
            )            .padding(.top, 15)
            
            RectanguloEstadisticaAvanzada(
                nombre: "PÁGINAS RESTANTES",
                dato: "39 páginas",
                descripcion: "Te falta el 30% por completar",
                icono: "book.pages.fill",
                color: .purple,
                ancho: 60,
                alto: 60
            )            .padding(.top, 15)
            
            RectanguloEstadisticaAvanzada(
                nombre: "PÁGINA MÁS VISITADA",
                dato: "Página 34",
                descripcion: "Tu página favorita para releer",
                icono: "bookmark.fill",
                color: .green,
                ancho: 60,
                alto: 60
            )            .padding(.top, 15)
        }
        .padding(.top, 10)
    }
}

// Vista Gráficos moderna
struct VistaGraficos: View {
    
    let datosProgreso = [
        ProgresoData(categoria: "Leído", valor: 70, color: .green),
        ProgresoData(categoria: "Restante", valor: 30, color: .gray)
    ]
    
    let datosVelocidad = [
        VelocidadData(dia: "L", velocidad: 1.8),
        VelocidadData(dia: "M", velocidad: 2.1),
        VelocidadData(dia: "M", velocidad: 2.3),
        VelocidadData(dia: "J", velocidad: 1.9),
        VelocidadData(dia: "V", velocidad: 2.5),
        VelocidadData(dia: "S", velocidad: 2.0),
        VelocidadData(dia: "D", velocidad: 1.7)
    ]
    
    let datosPaginasVisitadas = [
        PaginaVisitadaData(pagina: 12, visitas: 3),
        PaginaVisitadaData(pagina: 18, visitas: 5),
        PaginaVisitadaData(pagina: 25, visitas: 2),
        PaginaVisitadaData(pagina: 34, visitas: 8),
        PaginaVisitadaData(pagina: 42, visitas: 4),
        PaginaVisitadaData(pagina: 51, visitas: 6),
        PaginaVisitadaData(pagina: 67, visitas: 3)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Diagrama de progreso del libro
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "chart.bar.horizontal.fill")
                            .foregroundColor(.blue)
                        Text("Progreso del libro")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 120)
                        .overlay(
                            Chart(datosProgreso) { item in
                                BarMark(
                                    x: .value("Valor", item.valor),
                                    y: .value("Categoría", item.categoria)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: item.categoria == "Leído" ?
                                            [.blue, .purple] : [.gray.opacity(0.6), .gray.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(6)
                                .annotation(position: .trailing, alignment: .leading) {
                                    Text("\(Int(item.valor))%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                }
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading) { _ in
                                    AxisValueLabel()
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .chartXAxis(.hidden)
                            .padding()
                        )
                }
                
                // Gráfico de barras de velocidad
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.orange)
                        Text("Velocidad semanal")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 120)
                        .overlay(
                            Chart(datosVelocidad) { item in
                                BarMark(
                                    x: .value("Día", item.dia),
                                    y: .value("Velocidad", item.velocidad)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .cornerRadius(4)
                            }
                            .padding()
                        )
                }
                
                // Gráfico de páginas más visitadas
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.green)
                        Text("Páginas más visitadas")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 100)
                        .overlay(
                            Chart(datosPaginasVisitadas) { item in
                                LineMark(
                                    x: .value("Página", item.pagina),
                                    y: .value("Visitas", item.visitas)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.cyan, .green],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .interpolationMethod(.catmullRom)
                                
                                AreaMark(
                                    x: .value("Página", item.pagina),
                                    y: .value("Visitas", item.visitas)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.cyan.opacity(0.3), .green.opacity(0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .interpolationMethod(.catmullRom)
                                
                                // Punto destacado para la página más visitada
                                if item.visitas == datosPaginasVisitadas.map(\.visitas).max() {
                                    PointMark(
                                        x: .value("Página", item.pagina),
                                        y: .value("Visitas", item.visitas)
                                    )
                                    .foregroundStyle(.white)
                                    .symbolSize(50)
                                    
                                    PointMark(
                                        x: .value("Página", item.pagina),
                                        y: .value("Visitas", item.visitas)
                                    )
                                    .foregroundStyle(.green)
                                    .symbolSize(30)
                                }
                            }
                            .chartYAxis(.hidden)
                            .chartXAxis {
                                AxisMarks(position: .bottom, values: .stride(by: 5)) { value in
                                    AxisValueLabel() {
                                        if let intValue = value.as(Int.self) {
                                            Text("\(intValue)")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                        )
                }
                
                // Métrica rápida de tiempo restante
                MetricaRapida(
                    titulo: "Tiempo restante",
                    valor: "1h 55m",
                    icono: "clock.fill",
                    color: .blue
                )
            }
        }
    }
}

// Componente para métricas rápidas
struct MetricaRapida: View {
    let titulo: String
    let valor: String
    let icono: String
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.ultraThinMaterial)
            .frame(height: 70)
            .overlay(
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: icono)
                            .foregroundColor(color)
                            .font(.caption)
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(valor)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(titulo)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(8)
            )
    }
}

// Modelos de datos para gráficos
struct ProgresoData: Identifiable {
    let id = UUID()
    let categoria: String
    let valor: Double
    let color: Color
}

struct VelocidadData: Identifiable {
    let id = UUID()
    let dia: String
    let velocidad: Double
}

struct PaginaVisitadaData: Identifiable {
    let id = UUID()
    let pagina: Int
    let visitas: Int
}

// Tu componente original RectanguloEstadisticaAvanzada permanece igual
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
                .frame(height: 180)
//                .overlay(
//                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
//                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Información del Archivo")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                GrupoDatoAvanzado(nombre: "Dimensiones portada", valor: "1234 x 1234")
                GrupoDatoAvanzado(nombre: "Extensión", valor: "cbr")
                GrupoDatoAvanzado(nombre: "Formato", valor: EnumDescripcionArchivo.descripcion(for: archivo.fileType))

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
//                .overlay(
//                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
//                    )
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
                .frame(height: isSmall ? nil : 200)
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
//                        BotonAccion(icono: "star.fill", titulo: "Favorito", color: .yellow) { print("FAVORITO") }
//                        BotonAccion(icono: "lock.shield", titulo: "Proteger", color: .black, dosColores: true)
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
                .frame(width: isSmall ? nil : 550)
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
                    )
                .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
                .zIndex(0)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 100) {
                    Text("Progreso de Lectura")
                        .font(.headline)
                        .offset(x: 40)
                    
                    Text("Almacenamiento")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .offset(x: -55)
                }
                
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
                    
                    VStack {
                        ProgresoCircular(valor: tiempo, color: .purple)
                        Text("Tamaño en la colección")
                            .font(.subheadline)
                            .lineLimit(1)
                        Text("Ocupa \(13) MB de 2 GB")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .frame(height: 200)
    }
}


