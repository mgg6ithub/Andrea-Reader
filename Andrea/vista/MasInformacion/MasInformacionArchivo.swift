
import SwiftUI

#Preview {
    PreviewMasInformacion1()
}
//
private struct PreviewMasInformacion1: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInformacionArchivo(
            vm: ModeloColeccion(),
            archivo: Archivo.preview,
            pantallaCompleta: $pantallaCompleta,
            escala: 1.0
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
    let escala: CGFloat
    
    private let opacidad: CGFloat = 0.15
    
    private var isSmall: Bool { ap.resolucionLogica == .small }
    private var padding: CGFloat { pantallaCompleta ? 20 : 10 }
    
    @State private var masInfoPresionado: Bool = false
    @State private var show: Bool = false
    private var const: Constantes { ap.constantes }
    private var scale: CGFloat { const.scaleFactor }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                //IMAGEN + DATOS
                VStack(alignment: .leading, spacing: 0) {
                    if ap.resolucionLogica == .small {
                        Contenido(archivo: archivo, vm: vm)
                            .padding(.bottom, 10)
                    } else {
                        HStack {
                            Contenido(archivo: archivo, vm: vm)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    //ESTADISTICAS
                    VStack(alignment: .center, spacing: 0) {
                        if archivo.fechaPrimeraVezEntrado == nil || archivo.estadisticas.paginaActual == 0 {
                            VStack(alignment: .center, spacing: 0) {
                                HStack(spacing: 3) {
                                    Image("book-slash")
                                        .font(.system(size: const.iconSize * 0.75, weight: .medium))
                                    
                                    Text("No hay sesiones de lectura.")
                                    .font(.system(size: const.titleSize * 0.8))
                                    .bold()
                                    .offset(y: 2)
                                }
                                
                                Image("buho-pantalla")
                                    .resizable()
                                    .frame(width: 200 * scale, height: 215 * scale)
                                
                                Text("Aun no has leido este archivo.\n¿A que esperas para hacerlo?")
                                    .font(.system(size: const.titleSize * 0.8))
                                    .foregroundColor(ap.temaResuelto.textColor)
                                
                                Button(action: {
                                    
                                }) {
                                    ZStack {
                                        Text("Empezar a leer")
                                            .foregroundColor(ap.temaResuelto.textColor)
                                            .font(.system(size: const.titleSize * 0.8))
                                    }
                                    .padding(10) // margen interno
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(vm.color)
                                    )
                                }
                                .padding(.top, 15)
                                
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .aparicionStiffness(show: $show)

                        } else {
                        
                        EstadisticasProgresoLectura(archivo: archivo)
                            .padding(.top, 15)
                            .padding(.horizontal, 45)
                        
                        MenuNavegacion(estadisticas: archivo.estadisticas)
                            .padding(.top, 25)
                            .padding(.bottom, 20)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray.opacity(0.25), lineWidth: 1)
                    )
                    
                    //FECHAS
                    InformacionAvanzadaFechas(archivo: archivo, vm: vm, opacidad: opacidad, masInfoPresionado: $masInfoPresionado)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.gray.opacity(0.25), lineWidth: 1)
                        )
                        .padding(.top, 10)
                    
                    //INFORMACION AVANZADA
                    InformacionAvanzada(archivo: archivo, vm: vm, opacidad: opacidad, masInfoPresionado: $masInfoPresionado)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.gray.opacity(0.25), lineWidth: 1)
                        )
                        .padding(.top, 10)
                        .id("informacionAvanzada")
                }
                
            }
            .padding(.horizontal, 15)
            .onChange(of: masInfoPresionado) { old, nuevoValor in
                if nuevoValor {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation {
                            proxy.scrollTo("informacionAvanzada", anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct MenuNavegacion: View {
    @State private var seleccion: Seccion = .progreso
    @State private var verTodo: Bool = false
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    enum Seccion: String, CaseIterable, Identifiable {
        case progreso = "Progreso"
        case velocidad = "Velocidad"
        case masVistas = "Página más vistas"
        case masTiempo = "Tiempo en páginas"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Picker("Sección", selection: $seleccion) {
                ForEach(Seccion.allCases) { seccion in
                    Text(seccion.rawValue).tag(seccion)
                }
            }
            .pickerStyle(.segmented)
//            .padding(.top, 5)
            .padding(.bottom, 25)
            
            Spacer()
            
            // Aquí el contenido según la selección
            switch seleccion {
            case .progreso:
                VStack(alignment: .center, spacing: 15) {
                    //GRAFICO
//                    LeyendaGraficoProgreso() //leyenda
                    GraficoProgresoLectura(estadisticas: estadisticas) //grafico
                    
                    //INFOMRMACION
                    
                }
            case .velocidad:
                VStack(alignment: .leading, spacing: 20) {
                    
//                    LeyendaGraficoVelocidad(vMax: estadisticas.velocidadSesionMax)
                    
                    GraficoVelocidadLectura(estadisticas: estadisticas, verTodo: $verTodo)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            verTodo.toggle()
                        }
                    }) {
                        Text(verTodo ? "Ver menos" : "Ver todo")
                            .font(.footnote)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
            case .masVistas:
                GraficoPaginasMasVisitadas(estadisticas: estadisticas)
            case .masTiempo:
                GraficoTiempoPorPagina(estadisticas: estadisticas)
            }
            
//            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct Contenido: View {
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    @ObservedObject var vm: ModeloColeccion
    
    @State private var isEditingAutor = false
    @FocusState private var isEditingAutorFocused: Bool
    @State private var isEditingDescripcion = false
    @FocusState private var isEditingDescriptionFocused: Bool
    @State private var autorTexto: String = ""
    @State private var descripcionTexto: String = ""
    @State private var mostrarDescripcionCompleta: Bool = false
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var const: Constantes { ap.constantes }
    private var titleS: CGFloat { const.titleSize * 0.75 }
    private var subTitleS: CGFloat { const.subTitleSize * 0.75 }
    private var pd: PersistenciaDatos = PersistenciaDatos()
    private var cpe: ClavesPersistenciaElementos = ClavesPersistenciaElementos()
    
    init(archivo: Archivo, vm: ModeloColeccion) {
        self.archivo = archivo
        self.vm = vm
        _autorTexto = State(initialValue: archivo.autor)
        _descripcionTexto = State(initialValue: archivo.descripcion ?? "")
    }
    
    var body: some View {
        ImagenMiniatura(archivo: archivo, vm: vm)
            .if(ap.resolucionLogica == .small) { v in
                v.frame(maxWidth: .infinity, alignment: .center)
            }
        Spacer()
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    Image(systemName: "text.page.fill")
                        .font(.system(size: titleS * 1.2))
                        .foregroundColor(vm.color)
                    Text("Archivo")
                        .bold()
                        .font(.system(size: titleS * 1.2))
                        .foregroundColor(tema.tituloColor)
                        .offset(y: 3)
                    
                    Spacer()
                    
                    if archivo.fechaPrimeraVezEntrado != nil || archivo.estadisticas.paginaActual != 0 {
                        EditableStarRating(vm: vm, url: archivo.url, puntuacion: $archivo.puntuacion)
                    }
                }
                .padding(.bottom, 25 * ap.constantes.scaleFactor)
                
                HStack(spacing: 2) {
                    Image(systemName: "zipper.page")
                        .font(.system(size: titleS * 1.2))
                        .foregroundColor(vm.color)
                    Text(EnumDescripcionArchivo.descripcion(for: archivo.fileType))
                        .bold()
                        .font(.system(size: titleS * 1.2))
                        .foregroundColor(tema.tituloColor)
                        .offset(y: 3)
                    
                    Text("(\(archivo.fileType.rawValue.uppercased()))") // Ej: (PDF), (CBR)...
                        .font(.system(size: subTitleS))
                        .foregroundColor(tema.tituloColor)
                        .offset(y: 4)
                }
                
                Spacer()
                
                Rectangle()
                    .fill(.gray.opacity(0.25))
                    .frame(height: 1)
                    .padding(15 * ap.constantes.scaleFactor)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 2) {
                        Text("Autor")
                            .underline()
                            .font(.system(size: subTitleS))
                            .foregroundColor(tema.secondaryText)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: const.iconSize * 0.5))
                            .foregroundColor(tema.secondaryText)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { withAnimation {isEditingAutor.toggle()} }
                    
                    if isEditingAutor {
                        TextField("Autor1, Autor2, Autor3...", text: $autorTexto)
                            .font(.system(size: titleS))
                            .foregroundColor(tema.tituloColor)
                            .textFieldStyle(.roundedBorder)
                            .focused($isEditingAutorFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                archivo.autor = autorTexto
                                
                                //persitencia
                                pd.guardarDatoArchivo(valor: autorTexto, elementoURL: archivo.url, key: cpe.autor)
                                
                                withAnimation { isEditingAutor = false }
                                print("Nuevo autor: \(autorTexto)")
                            }
                            .onAppear {
                                // en cuanto aparezca el campo de texto, enfocar
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    isEditingAutorFocused = true
                                }
                            }
//                            .frame(height: 30 * ap.constantes.scaleFactor)
                    } else {
                        ZStack {
                            Text(autorTexto.isEmpty ? "???" : autorTexto)
                                .font(.system(size: autorTexto.isEmpty ? titleS * 0.8 : titleS))
                                .foregroundColor(tema.tituloColor)
                                .bold(!autorTexto.isEmpty)
                                .multilineTextAlignment(.leading)
                        }
//                        .frame(height: 30 * ap.constantes.scaleFactor, alignment: .topLeading)
                        .contentShape(Rectangle())
                        .onTapGesture { withAnimation {isEditingAutor.toggle()} }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 2) {
                        Text("Descripción")
                            .underline()
                            .font(.system(size: subTitleS))
                            .foregroundColor(tema.secondaryText)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: const.iconSize * 0.5))
                            .foregroundColor(tema.secondaryText)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { withAnimation { isEditingDescripcion.toggle() } }
                    
                    if isEditingDescripcion {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $descripcionTexto)
                                .bold()
                                .font(.system(size: titleS))
//                                .frame(height: 105 * ap.constantes.scaleFactor)
                                .focused($isEditingDescriptionFocused)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary.opacity(0.4), lineWidth: 0.5)
                                )
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        isEditingDescriptionFocused = true
                                    }
                                }
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer() // empuja a la derecha
                                Button("Aceptar") {
                                    archivo.descripcion = descripcionTexto
                                    
                                    //persitencia
                                    pd.guardarDatoArchivo(valor: descripcionTexto, elementoURL: archivo.url, key: cpe.descripcion)
                                    
                                    withAnimation { isEditingDescripcion = false }
                                    print("Nueva descripción: \(descripcionTexto)")
                                }
                            }
                        }


                    } else {
                        HStack(alignment: .top) {
                            Text(descripcionTexto.isEmpty ? "???" : descripcionTexto)
                                .font(.system(size: descripcionTexto.isEmpty ? titleS * 0.8 : titleS))
                                .foregroundColor(tema.tituloColor)
                                .bold(!descripcionTexto.isEmpty)
                                .multilineTextAlignment(.leading)
                                .lineLimit(6)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
//                        .frame(height: 105 * ap.constantes.scaleFactor, alignment: .topLeading)
                        .contentShape(Rectangle())
                        .onTapGesture { withAnimation { isEditingDescripcion.toggle() } }
                    }
                    
                    // 👇 Ellipsis botón debajo del área
                    ZStack {
                        if !isEditingDescripcion, descripcionTexto.count > 254 {
                            Button("Leer más…") {
                                mostrarDescripcionCompleta.toggle()
                            }
                            .font(.system(size: 14))
                            .foregroundColor(tema.tituloColor)
                            .buttonStyle(.plain)
                            .popover(isPresented: $mostrarDescripcionCompleta) {
                                ScrollView {
                                    Text(descripcionTexto)
                                        .font(.system(size: 16))
                                        .padding()
                                }
                                .frame(width: 330, height: 350)
                            }
                        }
                    }
//                    .frame(height: 20)
                    Spacer()
                }

            }

//            VStack(alignment: .center, spacing: 20) {
//                HStack(alignment: .bottom, spacing: 0) {
//                    RectanguloDato(nombre: "Extensión", dato: "\(String(describing: archivo.fileExtension))", icono: "books.vertical", color: vm.color)
//                    Spacer()
//                    RectanguloDato(nombre: "Páginas", dato: "\(String(describing: archivo.estadisticas.totalPaginas ?? 0))", icono: "book.pages", color: vm.color)
//                    Spacer()
//                    RectanguloDato(nombre: "Tamaño", dato: ManipulacionSizes().formatearSize(archivo.fileSize), icono: "externaldrive", color: vm.color)
//                }
//                
//            }
        } //FIN VSTACK INFORMACION DERECHA
//        .frame(height: 320 * ap.constantes.scaleFactor)
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
    
    private var tema: EnumTemas { ap.temaResuelto }

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
                                .init(color: .black.opacity(0.90), location: 0.0),
                                .init(color: .black.opacity(0.90), location: 0.80),
                                .init(color: .clear,                location: 1.0)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 45)
                        .clipShape(RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight]))
                        .allowsHitTesting(false)
                    }
                    // Ojo + estrellas centrados y apilados
                    .overlay(alignment: .bottom) {
                        Button(action: {
//                            DispatchQueue.main.async { archivo.paginas = archivo.cargarNombresPaginas(applyFilters: true) }
                            ap.elementoSeleccionado = archivo
                            withAnimation(.easeInOut(duration: 0.3)) { ap.vistaPrevia = true }
                        }) {
                            HStack(alignment: .center, spacing: 4) {
                                Image(systemName: "paintbrush")
                                    .font(.system(size: ap.constantes.iconSize * 0.6))
                                    .foregroundColor(.white.opacity(0.95))
                                
                                Text("Modificar miniatura")
                                    .foregroundColor(.white.opacity(0.95))
                            }
                            .frame(maxWidth: .infinity)   // <-- ocupa todo el ancho del overlay
                            .padding(.horizontal, 12)
                            .padding(.bottom, 10)
                        }
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
        .onChange(of: archivo.tipoMiniatura) {
            viewModel.cambiarMiniatura(color: vm.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura)
        }
        .onChange(of: archivo.imagenPersonalizada) {
            viewModel.cambiarMiniatura(color: vm.color, archivo: archivo, tipoMiniatura: archivo.tipoMiniatura, url: archivo.imagenPersonalizada)
        }
    }
}

struct EditableStarRating: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    let url: URL
    @Binding var puntuacion: Double // permite valores como 3.5
    let maxRating: Int = 5
    private var iz: CGFloat { ap.constantes.iconSize }
    
    var body: some View {
        HStack(spacing: 10) {
            Text(displayRating)
                .font(.system(size: ap.constantes.titleSize * 1.1))
                .frame(minWidth: 40, alignment: .trailing)
            
            HStack(spacing: 4) {
                ForEach(1...maxRating, id: \.self) { index in
                    let starType = starImageType(for: index)
                    
                    Image(systemName: starType)
                        .font(.system(size: iz))
                        .foregroundColor(vm.color)
                        .scaleEffect(puntuacion.rounded() == Double(index) ? 1.2 : 1.0) // efecto extra
                        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: puntuacion)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.1)) {
                                // Si ya está en media estrella, pasa a estrella completa; si está completa, baja a media
                                if puntuacion == Double(index) {
                                    puntuacion = Double(index) - 0.5
                                } else {
                                    puntuacion = Double(index)
                                }
                            }
                            PersistenciaDatos().guardarDatoArchivo(valor: puntuacion, elementoURL: url, key: ClavesPersistenciaElementos().puntuacion)
                        }
                }
                
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let totalWidth = CGFloat(maxRating) * (iz + 4) - 4
                        let clampedX = min(max(value.location.x, 0), totalWidth)
                        let rawStars = Double(clampedX / (totalWidth / CGFloat(maxRating)))
                        
                        // Redondear a media estrella
                        let halfStep = (rawStars * 2).rounded() / 2
                        withAnimation(.linear(duration: 0.1)) { puntuacion = min(Double(maxRating), max(0.5, halfStep)) }
                    }
                    .onEnded { _ in
                        PersistenciaDatos().guardarDatoArchivo(valor: puntuacion, elementoURL: url, key: ClavesPersistenciaElementos().puntuacion)
                    }
            )
        }
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
    
    private var displayRating: String {
        if puntuacion == 0 {
            return "" // 👈 no se muestra nada
        } else if puntuacion.truncatingRemainder(dividingBy: 1) == 0 {
            // Es entero
            return String(Int(puntuacion))
        } else {
            // Tiene decimales
            return String(format: "%.1f", puntuacion)
        }
    }


    
}
