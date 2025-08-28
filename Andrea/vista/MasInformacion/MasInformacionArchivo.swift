
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
    
    @State private var masInfoPresionado: Bool = true
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                //IMAGEN + DATOS
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Contenido(archivo: archivo, vm: vm)
                    }
                    .padding(.bottom, 10)
                    
                    //ESTADISTICAS
                    VStack(alignment: .center, spacing: 0) {
                        if archivo.fechaPrimeraVezEntrado == nil {

                            HStack {
                                Spacer()
                                ImagenLibreriaVacia(imagen: "buhosf", texto: "Aun no has leido este comic! ¿A que esperas para hacerlo?", anchura: 200, altura: 200)
                                Spacer()
                            }

                        } else {
                        
                        EstadisticasProgresoLectura(archivo: archivo)
                                .padding(.top, 30)
                                .padding(.horizontal, 45)
                        
//                        Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(.gray.opacity(0.25))
//                            .padding(.vertical, 20)
//                            .padding(.horizontal, 10)
                        
                            MenuNavegacion(estadisticas: archivo.estadisticas)
                                .padding(.vertical, 15)
                            
//                            EstadisticaProgresoTiempo(archivo: archivo)
//                            .padding(.bottom, 15)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray.opacity(0.25), lineWidth: 1)
                    )
                    
                    //INFORMACION AVANZADA
//                    InformacionAvanzada(archivo: archivo, vm: vm, opacidad: opacidad, masInfoPresionado: $masInfoPresionado)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 15)
//                                .stroke(.gray.opacity(0.25), lineWidth: 1)
//                        )
//                        .padding(.top, 10)
//                        .id("informacionAvanzada")
                }
                
            }
            .padding(.horizontal, 20)
            .onChange(of: masInfoPresionado) { nuevoValor in
                if nuevoValor {
                    withAnimation {
                        proxy.scrollTo("informacionAvanzada", anchor: .bottom)
                    }
                }
            }
        }
    }
}

struct MenuNavegacion: View {
    @State private var seleccion: Seccion = .progreso
    
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    
    enum Seccion: String, CaseIterable, Identifiable {
        case progreso = "Progreso"
        case velocidad = "Velocidad"
        case masVistas = "Página más vistas"
        case masTiempo = "Tiempo en páginas"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack {
            Picker("Sección", selection: $seleccion) {
                ForEach(Seccion.allCases) { seccion in
                    Text(seccion.rawValue).tag(seccion)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
            
            // Aquí el contenido según la selección
            switch seleccion {
            case .progreso:
                GraficoProgreso(estadisticas: estadisticas)
                    .padding(.horizontal, 20)
            case .velocidad:
                GraficoVelocidadLectura(estadisticas: estadisticas)
                    .padding(.horizontal, 20)
            case .masVistas:
                GraficoPaginasMasVisitadas(estadisticas: estadisticas)
            case .masTiempo:
                GraficoTiempoPorPagina(estadisticas: estadisticas)
            }
            
            Spacer()
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
    
    init(archivo: Archivo, vm: ModeloColeccion) {
        self.archivo = archivo
        self.vm = vm
        _autorTexto = State(initialValue: archivo.autor ?? "")
        _descripcionTexto = State(initialValue: archivo.descripcion ?? "")
    }
    
    var body: some View {
        ImagenMiniatura(archivo: archivo, vm: vm)
        Spacer()
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .bottom, spacing: 2) {
                    Image(systemName: "text.page.fill")
                        .foregroundColor(vm.color)
                    Text("Archivo")
                        .bold()
                        .font(.system(size: titleS))
                        .foregroundColor(tema.tituloColor)
                    
                    Spacer()
                    
                    EditableStarRating(vm: vm, url: archivo.url, puntuacion: $archivo.puntuacion)
                }
                
                VStack(alignment: .leading, spacing: 4) {
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
                        TextField("Introduce un autor", text: $autorTexto)
                            .font(.system(size: titleS))
                            .foregroundColor(tema.tituloColor)
                            .textFieldStyle(.roundedBorder)
                            .focused($isEditingAutorFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                archivo.autor = autorTexto
                                withAnimation { isEditingAutor = false }
                                print("Nuevo autor: \(autorTexto)")
                            }
                            .onAppear {
                                // en cuanto aparezca el campo de texto, enfocar
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    isEditingAutorFocused = true
                                }
                            }
                            .frame(height: 40)
                    } else {
                        ZStack {
                            Text(autorTexto.isEmpty ? "desconocido" : autorTexto)
                                .font(.system(size: titleS))
                                .foregroundColor(tema.tituloColor)
                                .bold()
                                .multilineTextAlignment(.leading)
                        }
                        .frame(height: 40, alignment: .topLeading)
                        .contentShape(Rectangle())
                        .onTapGesture { withAnimation {isEditingAutor.toggle()} }
                    }

                }
                
                
                VStack(alignment: .leading, spacing: 4) {
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
                                .frame(height: 100)
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
                                    withAnimation { isEditingDescripcion = false }
                                    print("Nueva descripción: \(descripcionTexto)")
                                }
                            }
                        }


                    } else {
                        HStack(alignment: .top) {
                            Text(descripcionTexto.isEmpty ? "sin descripción" : descripcionTexto)
                                .bold()
                                .font(.system(size: titleS))
                                .foregroundColor(tema.tituloColor)
                                .multilineTextAlignment(.leading)
                                .lineLimit(5)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .frame(height: 100, alignment: .topLeading)
                        .contentShape(Rectangle())
                        .onTapGesture { withAnimation { isEditingDescripcion.toggle() } }
                    }
                    
                    // 👇 Ellipsis botón debajo del área
                    ZStack {
                        if !isEditingDescripcion, descripcionTexto.count > 214 {
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
                    .frame(height: 20)
                }

            }
            
            VStack(alignment: .center, spacing: 20) {
                HStack(alignment: .bottom, spacing: 0) {
                    RectanguloDato(nombre: "Extensión", dato: "\(String(describing: archivo.fileExtension))", icono: "books.vertical", color: vm.color)
                    Spacer()
                    RectanguloDato(nombre: "Páginas", dato: "\(String(describing: archivo.estadisticas.totalPaginas ?? 0))", icono: "book.pages", color: vm.color)
                    Spacer()
                    RectanguloDato(nombre: "Tamaño", dato: ManipulacionSizes().formatearSize(archivo.fileSize), icono: "externaldrive", color: vm.color)
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
                                .init(color: .black.opacity(0.75), location: 0.0),
                                .init(color: .black.opacity(0.75), location: 0.7),
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
                        HStack(alignment: .center, spacing: 4) {
                            Image("custom-eye")
                                .font(.system(size: ap.constantes.iconSize * 0.7))
                                .foregroundColor(vm.color.opacity(0.8))
                            
                            Text("Miniatura")
                                .foregroundColor(vm.color.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)   // <-- ocupa todo el ancho del overlay
                        .padding(.horizontal, 12)
                        .padding(.bottom, 6)

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
                
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let totalWidth = CGFloat(maxRating) * (iz + 4) - 4
                        let clampedX = min(max(value.location.x, 0), totalWidth)
                        let rawStars = Double(clampedX / (totalWidth / CGFloat(maxRating)))
                        
                        // Redondear a media estrella
                        let halfStep = (rawStars * 2).rounded() / 2
                        withAnimation(.easeInOut(duration: 0.2)) { puntuacion = min(Double(maxRating), max(0.5, halfStep)) }
                    }
                    .onEnded { _ in
                        PersistenciaDatos().guardarDatoElemento(url: url, atributo: "puntuacion", valor: puntuacion)
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
