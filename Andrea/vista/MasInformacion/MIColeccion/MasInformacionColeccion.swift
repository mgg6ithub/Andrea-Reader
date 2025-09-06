

import SwiftUI

#Preview {
    pMIcoleccion()
}

//
private struct pMIcoleccion: View {
    @State private var pantallaCompleta = true
    
    var body: some View {
        MasInfoCol(
            pantallaCompleta: $pantallaCompleta, vm: ModeloColeccion()
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct MasInformacionColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @Binding var pantallaCompleta: Bool
    let escala: CGFloat
    
    private var const: Constantes { ap.constantes }
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    private var sombraCarta: Color { esOscuro ? .black.opacity(0.4) : .black.opacity(0.1) }
    private var scale: CGFloat { const.scaleFactor }
    
    private let opacidad: CGFloat = 0.15
    @State private var masInfoPresionado: Bool = false
    @State private var show: Bool = false
    
    @State private var mostrarDocumentPicker: Bool = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if ap.resolucionLogica == .small {
                        ContenidoColeccion(vm: vm, estadisticasColeccion: vm.estadisticasColeccion)
                            .padding(.bottom, 15)
                    } else {
                        HStack {
                            ContenidoColeccion(vm: vm, estadisticasColeccion: vm.estadisticasColeccion)
                        }
                        .padding(.bottom, 15)
                    }
                    
                //si la coleccion esta vacia no hay datos
                if vm.elementos.isEmpty {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(tema.backgroundGradient)
                            .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        VStack(alignment: .center, spacing: 0) {
                            HStack(spacing: 3) {
                                Image("folder-slash")
                                    .font(.system(size: const.iconSize * 0.75, weight: .medium))
                                
                                Text("La colección está vacia")
                                    .font(.system(size: const.titleSize * 0.8))
                                    .bold()
                                    .offset(y: 2)
                            }
                            
                            Image("caja-vacia")
                                .resizable()
                                .frame(width: 200 * scale, height: 215 * scale)
                            
                            Text("Aun no has importado archivos.\n¿A que esperas para hacerlo?")
                                .font(.system(size: const.titleSize * 0.8))
                                .foregroundColor(ap.temaResuelto.textColor)
                            
                            Button(action: { mostrarDocumentPicker.toggle() }) {
                                ZStack {
                                    HStack {
                                        Image(systemName: "tray.and.arrow.down")
                                            .font(.system(size: const.iconSize * 0.8, weight: .medium))
                                            .foregroundColor(.black.opacity(0.8))
                                            .offset(y: -2)
                                        
                                        Text("Importar archivos")
                                            .font(.system(size: const.titleSize * 0.8))
                                            .foregroundColor(.black.opacity(0.8))
                                    }
                                }
                                .padding(10) // margen interno
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 184/255, green: 226/255, blue: 152/255), // verde clarito
                                            Color(red: 160/255, green: 215/255, blue: 132/255)  // sombra suave
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 15)
                            .importarArchivosSheet(mostrar: $mostrarDocumentPicker) { urls in
                                for url in urls {
                                    SistemaArchivos.sa.crearArchivo(archivoURL: url, coleccionDestino: PilaColecciones.pilaColecciones.getColeccionActual().coleccion.url)
                                }
                                
                                //Ordenar la libreria despues de importar.
                            }
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .aparicionStiffness(show: $show)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                    
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(tema.backgroundGradient)
                            .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        if ap.resolucionLogica == .small {
                            VStack {
                                CantidadArchivos(vm: vm, estadisticasColeccion: vm.estadisticasColeccion)
                            }
                            
                            .padding()
                        } else {
                            HStack {
                                CantidadArchivos(vm: vm, estadisticasColeccion: vm.estadisticasColeccion)
                            }
                            .padding()
                        }
                        
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(tema.backgroundGradient)
                            .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        if ap.resolucionLogica == .small {
                            VStack {
                                TiposArchivos(vm: vm)
                            }
                            .padding()
                        } else {
                            HStack {
                                TiposArchivos(vm: vm)
                            }.padding()
                        }
                        
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
                }
               
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                        .fill(tema.backgroundGradient)
//                        .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
//                    InformacionAvanzadaFechas(archivo: Archivo(), vm: vm, opacidad: opacidad, masInfoPresionado: $masInfoPresionado)
//                }
//                .padding(.horizontal, 15)
//                .padding(.bottom, 10)
//                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                        .fill(tema.backgroundGradient)
//                        .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
//                    InformacionAvanzada(archivo: Archivo(), vm: vm, opacidad: opacidad, masInfoPresionado: $masInfoPresionado)
//                }
//                .padding(.horizontal, 15)
//                .padding(.bottom, 15)
                    
                }
            }
            .padding(.bottom, 20)
        }
    }
}

struct ContenidoColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @ObservedObject var estadisticasColeccion: EstadisticasColeccion
    @State private var puntuacion: Double = 0.0
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var const: Constantes { ap.constantes }
    private var titleS: CGFloat { const.titleSize * 0.75 }
    private var subTitleS: CGFloat { const.subTitleSize * 0.75 }
    private var esOscuro: Bool { tema == .dark }
    private var sombraCarta: Color { esOscuro ? .black.opacity(0.4) : .black.opacity(0.1) }
    
    @State private var isEditingDescripcion = false
    @FocusState private var isEditingDescriptionFocused: Bool
    @State private var descripcionTexto: String = ""
    @State private var mostrarDescripcionCompleta: Bool = false
    
    init(vm: ModeloColeccion, estadisticasColeccion: EstadisticasColeccion) {
        self.vm = vm
        self.estadisticasColeccion = estadisticasColeccion
        _descripcionTexto = State(initialValue: estadisticasColeccion.descripcion)
    }
    
    var body: some View {
        ImagenColeccion(vm: vm)
            .if(ap.resolucionLogica == .small) { v in
                v.frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.leading, 15)
            .padding(.top, 15)
//        Spacer()
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(tema.backgroundGradient)
                .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
//                        Spacer()
                        EditableStarRating(vm: vm,
                                               url: vm.coleccion.url,
                                               puntuacion: $puntuacion,
                                               isEditable: false)
                            .onReceive(estadisticasColeccion.$mediaValoraciones) { nuevaMedia in
                                puntuacion = nuevaMedia
                            }
                            .opacity(vm.elementos.isEmpty ? 0.25 : 1.0)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
//                    HStack(alignment: .top, spacing: 40) {
//                        Spacer()
                        SelectorColor(vm: vm)
                    
//                        Spacer()
//                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(.gray.opacity(0.25))
                        .frame(height: 1)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        if !descripcionTexto.isEmpty {
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
                            .padding(.bottom, 3)
                        }
                        
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
                                        vm.coleccion.descripcion = descripcionTexto
                                        
                                        //persitencia
                                        PersistenciaDatos().guardarDatoArchivo(valor: descripcionTexto, elementoURL: vm.coleccion.url, key: ClavesPersistenciaElementos().descripcion)
                                        
                                        withAnimation { isEditingDescripcion = false }
                                        print("Nueva descripción: \(descripcionTexto)")
                                    }
                                }
                            }
                            
                        } else {
                            if descripcionTexto.isEmpty {
                                Label("Agregar descripción", systemImage: "square.and.pencil")
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue) // o tema.accent
                                    .contentShape(Rectangle())
                                    .onTapGesture { withAnimation { isEditingDescripcion.toggle() } }
                            } else {
                                Text(descripcionTexto)
                                    .font(.system(size: titleS))
                                    .foregroundColor(tema.tituloColor)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(6)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
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
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(15)
        }
        .padding(.trailing, 15)
        .padding(.top, 15)
    }
}

struct ImagenColeccion: View {
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    private var col: Coleccion { vm.coleccion }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) { // separación entre imagen y texto
            Spacer()
            
            MiniaturaColeccionView(coleccion: vm.coleccion, width: 210 * ap.constantes.scaleFactor, height: 230 * ap.constantes.scaleFactor)
            
            Button(action: {
                
                print("La coleccion seleccionada es: ", vm.coleccion.nombre)
                
                ap.coleccionseleccionada = vm
                withAnimation(.easeInOut(duration: 0.3)) { ap.vistaPreviaColeccion = true }
            }) {
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "paintbrush")
                        .foregroundColor(.gray)
                    
                    Text("Modificar miniatura")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 20)
            
        }
        .frame(width: 220, height: 340 * ap.constantes.scaleFactor, alignment: .top)
    }
}


struct SelectorColor: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    @State private var colorActual: Color = .blue
    @State private var mostrarColorPicker = false
    
    // 🎨 Paleta de colores (mínimo 18 para llenar 2x9)
    let colores: [Color] = [.blue, .green, .orange, .pink, .purple, .red, .yellow, .teal, .indigo, .mint, .cyan, .brown, .gray, .black, .white, .primary, .secondary, .accentColor]

    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 🔹 Título
            
            HStack(alignment: .bottom, spacing: 5) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(vm.color.gradient.opacity(0.3))
                        .frame(width: 30, height: 30)
                        .shadow(color: vm.color.opacity(0.25), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "folder.fill")
                        .foregroundColor(vm.color)
                        .frame(width: 25, height: 25)
                }
                
                Text("Color de la colección")
                    .font(.system(size: ap.constantes.titleSize * 0.8))
                    .bold()
                    .foregroundColor(ap.temaResuelto.tituloColor)
            }
            
            Text("Selecciona un color")
                .font(.system(size: ap.constantes.subTitleSize * 0.8))
                .foregroundColor(ap.temaResuelto.secondaryText)
            
            let circleSize = ap.constantes.iconSize * 1.5
            
            // 🔹 Grid más compacto: 6 columnas en vez de 9
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5),
                spacing: 8
            ) {
                ForEach(colores.prefix(10), id: \.self) { color in   // 👈 solo mostramos los 8 primeros
                    let current = color == colorActual
                    Button {
                        withAnimation {
                            colorActual = color
                            vm.color = color
                            vm.coleccion.color = color
                        }
                        PersistenciaDatos().guardarDatoArchivo(
                            valor: color,
                            elementoURL: vm.coleccion.url,
                            key: ClavesPersistenciaElementos().colorGuardado
                        )
                    } label: {
                        Circle()
                            .fill(color.gradient)
                            .opacity(current ? 1 : 0.3)
                            .frame(width: circleSize, height: circleSize)
                    }
                }
            }
            .frame(maxWidth: 200 * ap.constantes.scaleFactor) // 👈 limita ancho total del grid para que quede centrado
            
            // 🔹 Opción más colores
            Button {
                mostrarColorPicker.toggle()
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Más colores")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.top, 10)
            .sheet(isPresented: $mostrarColorPicker) {
                VStack {
                    Text("Selecciona un color")
                        .font(.headline)
                        .padding()
                    
                    ColorPicker("Elige un color", selection: $colorActual, supportsOpacity: false)
                        .padding()
                    
                    Spacer()
                }
                .presentationDetents([.medium])
            }
        }
        
        
        
    }
}

