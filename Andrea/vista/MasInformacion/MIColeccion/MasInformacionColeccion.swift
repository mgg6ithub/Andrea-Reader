

import SwiftUI

#Preview {
    pMIcoleccion()
}
//
private struct pMIcoleccion: View {
    @State private var pantallaCompleta = false
    
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
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if ap.resolucionLogica == .small {
                        ContenidoColeccion(vm: vm)
                            .padding(.bottom, 10)
                    } else {
                        HStack {
                            ContenidoColeccion(vm: vm)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // 📦 Card: Cantidad de archivos + detalles
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(tema.backgroundGradient)
                                .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cantidad de archivos")
                                        .font(.headline)
                                    Text("140 en total")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    
                                    Divider()
                                    
                                    // Tamaño promedio
                                    HStack(spacing: 6) {
                                        Image("doc-lupa")
                                            .font(.system(size: const.iconSize * 0.7))
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.blue, .black)
                                        Text("Tamaño promedio: 7 MB")
                                            .font(.system(size: const.subTitleSize * 0.9))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    // Archivo más grande
                                    HStack(spacing: 6) {
                                        Image("doc-arrow-up")
                                            .font(.system(size: const.iconSize * 0.7))
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.blue, .black)
                                        Text("Más grande: 320 MB")
                                            .font(.system(size: const.subTitleSize * 0.9))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    // Archivo más pequeño
                                    HStack(spacing: 6) {
                                        Image("doc-arrow-down")
                                            .font(.system(size: const.iconSize * 0.7))
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.blue, .black)
                                        Text("Más pequeño: 450 KB")
                                            .font(.system(size: const.subTitleSize * 0.9))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Divider()
                                    
                                    // Salud del almacenamiento
                                    HStack(spacing: 6) {
                                        Image(systemName: "cross.case.fill")
                                            .font(.system(size: const.iconSize * 0.7))
                                            .foregroundColor(.red)
                                        Text("Salud: estable (fragmentación baja)")
                                            .font(.system(size: const.subTitleSize * 0.9))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .frame(width: 300)
                                .border(.red)
                                
                                Spacer()
                                
                                VStack(alignment: .center, spacing: 15) {
                                    ProgresoCircular(
                                        titulo: "tamaño",
                                        progreso: 56,
                                        progresoDouble: 0.56,
                                        color: .red,
                                        anchuraLinea: 12,
                                        radio: 120
                                    )
                                    
                                    VStack(alignment: .center, spacing: 4) {
                                        HStack(spacing: 3) {
                                            Image(systemName: "externaldrive")
                                                .font(.system(size: const.iconSize * 0.65))
                                                .foregroundColor(.red.opacity(0.85))
                                            Text("Almacenamiento")
                                                .font(.system(size: const.titleSize * 0.75))
                                                .foregroundColor(tema.tituloColor)
                                        }
                                        
                                        HStack(alignment: .bottom, spacing: 2) {
                                            Text("Ocupa")
                                                .font(.system(size: const.subTitleSize * 0.65))
                                                .foregroundColor(tema.secondaryText.opacity(0.8))
                                            Text("1.5 GB")
                                                .font(.system(size: const.subTitleSize * 0.75))
                                                .foregroundColor(tema.secondaryText)
                                            Text("de")
                                                .font(.system(size: const.subTitleSize * 0.65))
                                                .foregroundColor(tema.secondaryText.opacity(0.8))
                                            Text("2 GB")
                                                .font(.system(size: const.subTitleSize * 0.75))
                                                .foregroundColor(tema.secondaryText)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                                .padding(.trailing, 15)
                            }
                            .padding()
                        }
                        
                        // 📊 Card: Tipos de archivo + últimos añadidos/abiertos
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(tema.backgroundGradient)
                                .shadow(color: sombraCarta, radius: 5, x: 0, y: 2)
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Tipos de archivo")
                                        .font(.headline)
                                    Text("3 formatos distintos")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    
                                    Divider()
                                    
                                    // Últimos añadidos
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Últimos añadidos")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("• Batman #45.cbz")
                                            .font(.caption2)
                                        Text("• Avengers #12.cbr")
                                            .font(.caption2)
                                        Text("• One Piece Vol.1.pdf")
                                            .font(.caption2)
                                    }
                                    
                                    Divider()
                                    
                                    // Últimos abiertos
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Últimos abiertos")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("• Spiderman #102.cbz")
                                            .font(.caption2)
                                        Text("• X-Men Classic.cbr")
                                            .font(.caption2)
                                    }
                                }
                                
                                Spacer()
                                
                                GraficoGithubStyle()
                            }
                            .padding()
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
}

struct ContenidoColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
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
    
    @State private var puntucacion: Double = 1.5
    
    var body: some View {
        ImagenColeccion(vm: vm)
            .if(ap.resolucionLogica == .small) { v in
                v.frame(maxWidth: .infinity, alignment: .center)
            }
        Spacer()
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(tema.backgroundGradient)
                .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 2) {
                        Image(systemName: "folder.fill")
                            .font(.system(size: titleS * 1.2))
                            .foregroundColor(vm.color)
                        Text("Colección")
                            .bold()
                            .font(.system(size: titleS * 1.2))
                            .foregroundColor(tema.tituloColor)
                            .offset(y: 3)
                        
                        Spacer()
                        
                        //                    if archivo.fechaPrimeraVezEntrado != nil || archivo.estadisticas.paginaActual != 0 {
                        EditableStarRating(vm: vm, url: vm.coleccion.url, puntuacion: $puntucacion)
                        //                    }
                    }
                    .padding(.bottom, 15 * ap.constantes.scaleFactor)
                    .padding(.bottom, 20)
                    
                    HStack(alignment: .top, spacing: 40) {
                        SelectorColor(vm: vm)
                        
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(.gray.opacity(0.25))
                        .frame(height: 1)
                        .padding(15 * ap.constantes.scaleFactor)
                    
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
                                        vm.coleccion.descripcion = descripcionTexto
                                        
                                        //persitencia
                                        //                                    pd.guardarDatoArchivo(valor: descripcionTexto, elementoURL: vm.coleccion.url, key: cpe.descripcion)
                                        
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
                
                Spacer()
            }
            .padding(10)

        }
    }
}

struct ImagenColeccion: View {
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    private var col: Coleccion { vm.coleccion }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) { // separación entre imagen y texto
            // 🔹 Imagen arriba
            if col.tipoMiniatura == .carpeta {
                Image("CARPETA-ATRAS")
                    .resizable()
                    .frame(width: 220, height: 270 * ap.constantes.scaleFactor, alignment: .top)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        vm.color.gradient,
                        vm.color.darken(by: 0.2).gradient
                    )
            }
            
            Button(action: {
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
            
        }
        .frame(width: 220, height: 340 * ap.constantes.scaleFactor, alignment: .top)
        .border(.red) // 👈 para que veas el contenedor
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
            Text("Color de colección")
                .font(.system(size: ap.constantes.titleSize * 0.8))
                .bold()
                .foregroundColor(ap.temaResuelto.tituloColor)
            
            Text("Selecciona un color")
                .font(.system(size: ap.constantes.subTitleSize * 0.8))
                .foregroundColor(ap.temaResuelto.secondaryText)
            
            // 🔹 Grid 2 filas × 9 columnas
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 9),
                spacing: 8
            ) {
                ForEach(colores, id: \.self) { color in
                    Button {
                        withAnimation {
                            colorActual = color
                            vm.color = color
                        }
                        PersistenciaDatos().guardarDatoArchivo(valor: color, elementoURL: vm.coleccion.url, key: ClavesPersistenciaElementos().colorGuardado)
                    } label: {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [color.opacity(0.7), color]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 35) // 🔹 altura más compacta
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(color == colorActual ? Color.primary : Color.clear, lineWidth: 2)
                            )
                    }
                }
            }
            .frame(maxHeight: 90) // 🔹 fuerza que sean solo 2 filas visibles
            
            // 🔹 Opción más colores
            Button {
                mostrarColorPicker.toggle()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Más colores")
                }
                .font(.subheadline)
                .foregroundColor(.black)
            }
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

