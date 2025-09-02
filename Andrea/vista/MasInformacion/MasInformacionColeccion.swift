

import SwiftUI

struct MasInformacionColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @Binding var pantallaCompleta: Bool
    let escala: CGFloat

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
                
                SelectorColor(vm: vm)
                
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
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray.opacity(0.25), lineWidth: 1)
        )
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
    
    @ObservedObject var vm: ModeloColeccion
    
    @State private var colorActual: Color = .blue
    @State private var mostrarColorPicker = false
    
    // 🎨 Paleta de colores (mínimo 18 para llenar 2x9)
    let coloresPredefinidos: [Color] = [
        .blue, .green, .orange, .pink, .purple, .red, .yellow, .teal, .indigo,
        .mint, .brown, .cyan, .gray, .black, .white, .secondary, .primary, .accentColor
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 🔹 Título
            Text("Color de colección")
                .font(.headline)
            
            Text("Selecciona un color")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            // 🔹 Grid 2 filas × 9 columnas
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 9),
                spacing: 8
            ) {
                ForEach(coloresPredefinidos, id: \.self) { color in
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


struct GraficoGithubStyle: View {
    // Datos: nombre, cantidad, color base
    let datos: [(String, Int, Color)] = [
        ("CBZ", 75, .blue),
        ("CBR", 45, .green),
        ("PDF", 20, .orange)
    ]
    
    var total: Int {
        datos.map { $0.1 }.reduce(0, +)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🔹 Título + total
            VStack(alignment: .leading, spacing: 2) {
                Text("Tipos de archivos")
                    .font(.headline)
                Text("\(total) en total")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            // 🔹 Barra segmentada
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(datos, id: \.0) { tipo, cantidad, color in
                        let porcentaje = CGFloat(cantidad) / CGFloat(total)
                        
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.8), color]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geo.size.width * porcentaje, height: 12)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .frame(height: 12)
            
            // 🔹 Leyenda en horizontal
            HStack(spacing: 16) {
                ForEach(datos, id: \.0) { tipo, cantidad, color in
                    let porcentaje = Double(cantidad) / Double(total) * 100
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [color.opacity(0.7), color]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 10, height: 10)
                        
                        Text(tipo)
                            .font(.subheadline).bold()
                        
                        Text("\(Int(porcentaje))%")
                            .font(.caption)              // 🔹 más pequeño
                            .foregroundColor(.secondary) // 🔹 gris
                    }
                }
            }
        }
        // ❌ quitamos el .padding() para que no tenga margen lateral
    }
}

