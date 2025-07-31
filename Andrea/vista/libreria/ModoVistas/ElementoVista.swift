
import SwiftUI

struct ElementoVista<Content: View>: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var me: MenuEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    let elemento: any ElementoSistemaArchivosProtocolo
    var elementoURL: URL { elemento.url }
    let scrollIndex: Int?
    // Cambiar miniatura para archivo
    var cambiarMiniaturaArchivo: ((EnumTipoMiniatura) -> Void)? = nil
    // Cambiar miniatura para colección
    var cambiarMiniaturaColeccion: ((EnumTipoMiniaturaColeccion) -> Void)? = nil
    
    @ViewBuilder let content: () -> Content

    @State private var borrarPresionado = false
    @State private var mostrarElementoReal = false
    @State private var esPlaceholder = true
    
    @State private var renombrarPresionado = false
    @State private var nuevoNombre = ""
    
    @State private var accionDocumento: EnumAccionDocumento? = nil //MOVER,COPIAR


    private let sa: SistemaArchivos = SistemaArchivos.sa

    var body: some View {
        
        content()
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: ScrollIndexPreferenceKey.self,
                            value: scrollIndex.map { idx in
                                [VisibleIndex(index: idx, minY: geo.frame(in: .named("scroll")).minY)]
                            } ?? []
                        )
                }
            )
            .contextMenu {
                ContextMenuContenido(
                    vm: vm,
                    elemento: elemento,
                    cambiarMiniaturaArchivo: cambiarMiniaturaArchivo,
                    cambiarMiniaturaColeccion: cambiarMiniaturaColeccion,
                    borrarPresionado: $borrarPresionado,
                    renombrarPresionado: $renombrarPresionado,
                    accionDocumento: $accionDocumento
                )
            }
            .confirmationDialog(
                "¿Estás seguro de que quieres borrar \(elemento.nombre)?",
                isPresented: $borrarPresionado, // <- o el tuyo
                titleVisibility: .visible
            ) {
                Button("Borrar", role: .destructive) {
                    SistemaArchivos.sa.borrarElemento(elemento: elemento, vm: vm)
                }
                Button("Cancelar", role: .cancel) {}
            }
            .alert("Renombrar \"\(elemento.nombre)\"", isPresented: $renombrarPresionado, actions: {
                TextField("Nuevo nombre", text: $nuevoNombre)
                
                Button("Aceptar") {
                    let nombreLimpio = nuevoNombre.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !nombreLimpio.isEmpty else { return }
                    sa.renombrarElemento(elemento: elemento, nuevoNombre: nombreLimpio)
                    self.nuevoNombre = ""
                }

                Button("Cancelar", role: .cancel) {}
            })
            .sheet(item: $accionDocumento) { accion in
                DocumentPicker(
                    onPick: { urls in
                        guard let destino = urls.first else { return }
                        switch accion {
                        case .mover:
                            try? sa.moverElemento(elemento, vm: vm, a: destino)
                        case .copiar:
                            try? sa.copiarElemento(elemento, vm: vm, a: destino)
                        default:
                            break
                        }
                    },
                    onCancel: {
                        print("Cancelado \(accion == .mover ? "mover" : "copiar")")
                    },
                    allowMultipleSelection: false,
                    contentTypes: [.folder]
                )
            }
            .onTapGesture {
                if me.seleccionMultiplePresionada {
                    if !me.elementosSeleccionados.contains(elementoURL) {
                        me.seleccionarElemento(url: elementoURL)
                    } else {
                        me.deseleccionarElemento(url: elementoURL)
                    }
                }
            }
    }
}

enum EnumAccionDocumento {
    case mover
    case copiar
    case mostrarEnArchivos
}

extension EnumAccionDocumento: Identifiable {
    var id: String {
        switch self {
        case .mover: return "mover"
        case .copiar: return "copiar"
        case .mostrarEnArchivos: return "mostrarEnArchivos"
        }
    }
}


struct ContextMenuContenido: View {
    
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    var elemento: any ElementoSistemaArchivosProtocolo
    var elementoURL: URL { elemento.url }
    let cambiarMiniaturaArchivo: ((EnumTipoMiniatura) -> Void)?
    let cambiarMiniaturaColeccion: ((EnumTipoMiniaturaColeccion) -> Void)?
    @Binding var borrarPresionado: Bool
    @Binding var renombrarPresionado: Bool
    @Binding var accionDocumento: EnumAccionDocumento?
    
    private let sa: SistemaArchivos = SistemaArchivos.sa
    @State private var masInformacionPresionado: Bool = false
    
    @State private var menuRefreshTrigger = UUID()
    
    var cDinamico: Color { ap.temaActual.colorContrario }
    var cGris: Color { ap.temaActual == .dark ? .gray.opacity(0.5) : .gray }
    
    var body: some View {
        Section(header: Label(elemento.nombre, systemImage: "document")) {
        
            // --- SELECCIONAR ELEMENTO ---
            Button(action: {
                me.seleccionMultiplePresionada = true
                me.seleccionarElemento(url: elementoURL)
            }) {
                Label("Seleccionar", systemImage: "hand.tap")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, cGris)
            }
        }
        
        Section {
            Button(action: {
                ap.elementoSeleccionado = elemento
                withAnimation(.easeInOut(duration: 0.3)) { ap.masInformacion = true }
            }) {
                Label("Más Información", systemImage: "info.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, cGris)
            }
//            .sheet(isPresented: $masInformacionPresionado){ //Puedo sacarlo de aqui con una .sheet o desde la vista principal
//                MasInformacionArchivo(vm: vm, elemento: elemento)
//            }
            
            Button(action: {
                //vista previa de mi programa personalizada. se motrara la miniatura y 3 datos basicos.
            }) {
                Label {
                    Text("Vista previa")
                } icon: {
                    Image("custom-eye") // <- tu símbolo personalizado
                        .renderingMode(.template) // permite aplicar `foregroundStyle`
                }
                .symbolRenderingMode(.palette)
                .foregroundStyle(cGris, cDinamico)

            }
            
            CambiarMiniaturaMenu(elemento: elemento, cambiarMiniaturaArchivo: cambiarMiniaturaArchivo, cambiarMiniaturaColeccion: cambiarMiniaturaColeccion)
            
        }
        
        //--- ESTADO DEL ARCHIVO ---
        Section {
            if let archivo = elemento as? Archivo { BotonCompletarLectura(archivo: archivo) }
            if let elementoConcreto = elemento as? ElementoSistemaArchivos { BotonFavorito(elemento: elementoConcreto) }
            if let elementoConcreto = elemento as? ElementoSistemaArchivos { BotonProteccion(elemento: elementoConcreto) }
        }
        

        Section {

            Button(action: {
                self.renombrarPresionado = true
            }) {
                Label("Renombrar", systemImage: "pencil")
            }
            
            Button(action: {
                self.accionDocumento = .mover
            }) {
                Label("Mover", systemImage: "arrow.right.doc.on.clipboard")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, cGris)
            }
            
            Button(action: {
                self.accionDocumento = .copiar
            }) {
                Label("Copiar", systemImage: "doc.on.doc")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, cGris)
            }
            
            Button(action: {
                try? sa.duplicarElemento(elemento, vm: vm)
            }) {
                Label("Duplicar", systemImage: "plus.rectangle.on.rectangle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, cGris)
            }
        }
        
        Section {
            Button(action: {
                FilesAppManager.abrirConOpciones(url: elementoURL)
            }) {
                Label("Abrir con", systemImage: "ellipsis")
            }
            
            ShareLink(item: elementoURL) {
                Label("Compartir", systemImage: "square.and.arrow.up")
            }

            Menu {
                
                Button(action: {
                    FilesAppManager.abrirDirectorioDelArchivo(url: elementoURL)
                }) {
                    Label("Abrir en Archivos", systemImage: "folder")
                }
                
                Button(action: {
                    FilesAppManager.copiarYAbrirEnFiles(url: elementoURL)
                }) {
                    Label {
                        Text("Compartir")
                    } icon: {
                        Image("custom-compartir") // <- tu símbolo personalizado
                            .renderingMode(.template) // permite aplicar `foregroundStyle`
                    }
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, cGris)
                }
                
                Button(action: {
                    FilesAppManager.vistaPreviaDeArchivos(url: elementoURL)
                }) {
                    Label("Vista previa en Archivos", systemImage: "eye")
                }
                
            } label: {
                Label("Mostrar en Archivos", systemImage: "folder")
            }
        }
        
        Section {
            Button(role: .destructive) {
                self.borrarPresionado = true
            } label: {
                Label("Eliminar archivo", systemImage: "trash")
            }
        }

        
    }
}


struct BotonCompletarLectura: View {
    
    @ObservedObject var archivo: Archivo
    @EnvironmentObject var ap: AppEstado
    
    var cDinamico: Color { ap.temaActual.colorContrario }
    var cGris: Color { ap.temaActual == .dark ? .gray.opacity(0.5) : .gray }
    
    var body: some View {
        Button(action: {
            archivo.completarLectura()
        }) {
            let completado: Bool = archivo.progreso == 100
            Label {
                Text(completado ? "Reiniciar lectura" : "Completar lectura")
            } icon: {
                Image(completado ? "custom-reiniciar" : "custom-completar")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(cDinamico, cGris)
            }
            .symbolRenderingMode(.palette)
            .foregroundStyle(cDinamico, cGris)
            .onAppear {
                print(completado)
                print(archivo.progreso)
            }
        }
    }
}

struct BotonFavorito<Elemento: ObservableObject & ElementoSistemaArchivosProtocolo>: View {
    @ObservedObject var elemento: Elemento
    @EnvironmentObject var ap: AppEstado
    
    var cDinamico: Color { ap.temaActual.colorContrario }
    var cGris: Color { ap.temaActual == .dark ? .gray : .gray }
    
    var body: some View {
        Button(action: {
            elemento.cambiarEstadoFavorito()
        }) {
            if !elemento.favorito {
                Label {
                    Text("Agregar a favoritos")
                } icon: {
                    Image("custom-star") // <- tu símbolo personalizado
                        .renderingMode(.template) // permite aplicar `foregroundStyle`
                }
                .symbolRenderingMode(.palette)
                .foregroundStyle(cGris, cDinamico)
            } else {
                Label("Quitar de favoritos", systemImage: "star.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.yellow)
            }
        }
    }
}


struct BotonProteccion<Elemento: ObservableObject & ElementoSistemaArchivosProtocolo>: View {
    @ObservedObject var elemento: Elemento
    @EnvironmentObject var ap: AppEstado
    
    var cDinamico: Color { ap.temaActual.colorContrario }
    var cGris: Color { ap.temaActual == .dark ? .gray.opacity(0.5) : .gray }
    
    var body: some View {
        Button(action: {
            elemento.cambiarEstadoProtegido()
        }) {
            
            let p = elemento.protegido
            
            Label {
                Text(p ? "Quitar protección" : "Proteger")
            } icon: {
                Image(systemName: "lock.shield")
                    .font(.system(size: 60))
            }
            .symbolRenderingMode(.palette)
            .foregroundStyle(elemento.protegido ? .red : cGris, cGris)

        }
    }
}
