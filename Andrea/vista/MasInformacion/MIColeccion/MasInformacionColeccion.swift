

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
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if ap.resolucionLogica == .small {
                        ContenidoColeccion(vm: vm)
                            .padding(.bottom, 15)
                    } else {
                        HStack {
                            ContenidoColeccion(vm: vm)
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
                            
                            Button(action: { /*importar archivos*/ }) {
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
                                CantidadArchivos()
                            }
                            
                            .padding()
                        } else {
                            HStack {
                                CantidadArchivos()
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
               
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(tema.backgroundGradient)
                        .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    InformacionAvanzadaFechas(archivo: Archivo(), vm: vm, opacidad: opacidad, masInfoPresionado: $masInfoPresionado)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(tema.backgroundGradient)
                        .shadow(color: esOscuro ? .black.opacity(0.4) : .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    InformacionAvanzada(archivo: Archivo(), vm: vm, opacidad: opacidad, masInfoPresionado: $masInfoPresionado)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
                    
                }
            }
            .padding(.bottom, 20)
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
            .padding(.leading, 15)
            .padding(.top, 15)
//        Spacer()
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
            
            // 🔹 Grid más compacto: 6 columnas en vez de 9
            // 🔹 Grid compacto: 4 columnas × 2 filas
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4),
                spacing: 8
            ) {
                ForEach(colores.prefix(8), id: \.self) { color in   // 👈 solo mostramos los 8 primeros
                    Button {
                        withAnimation {
                            colorActual = color
                            vm.color = color
                        }
                        PersistenciaDatos().guardarDatoArchivo(
                            valor: color,
                            elementoURL: vm.coleccion.url,
                            key: ClavesPersistenciaElementos().colorGuardado
                        )
                    } label: {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [color.opacity(0.7), color]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)   // 👈 cuadraditos iguales
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(color == colorActual ? Color.primary : Color.clear, lineWidth: 2)
                            )
                    }
                }
            }
            .frame(maxWidth: 200) // 👈 limita ancho total del grid para que quede centrado


            
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

