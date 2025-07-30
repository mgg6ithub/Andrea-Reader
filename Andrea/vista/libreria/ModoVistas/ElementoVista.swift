
import SwiftUI

struct ElementoVista<Content: View>: View {
    @EnvironmentObject var appEstado: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    let elemento: any ElementoSistemaArchivosProtocolo
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
    
    @ObservedObject var vm: ModeloColeccion
    
    let elemento: any ElementoSistemaArchivosProtocolo
    let cambiarMiniaturaArchivo: ((EnumTipoMiniatura) -> Void)?
    let cambiarMiniaturaColeccion: ((EnumTipoMiniaturaColeccion) -> Void)?
    @Binding var borrarPresionado: Bool
    @Binding var renombrarPresionado: Bool
    @Binding var accionDocumento: EnumAccionDocumento?
    
    private let sa: SistemaArchivos = SistemaArchivos.sa
    
    var body: some View {
        Section(header: Text(elemento.nombre)) {
            Text("Mostrar información")
            Text("Completar lectura")
            
            Button(action: {
                self.renombrarPresionado = true
            }) {
                Label("Renombrar", systemImage: "square.and.pencil")
            }
            
            Button(action: {
                self.accionDocumento = .mover
            }) {
                Label("Mover", systemImage: "arrow.right.doc.on.clipboard")
            }
            
            Button(action: {
                self.accionDocumento = .copiar
            }) {
                Label("Copiar", systemImage: "doc.on.doc")
            }
            
            Button(action: {
                try? sa.duplicarElemento(elemento, vm: vm)
            }) {
                Label("Duplicar", systemImage: "rectangle.on.rectangle")
            }
            
            ShareLink(item: elemento.url) {
                Label("Compartir", systemImage: "square.and.arrow.up")
            }
            
            // OPCIÓN B: Previsualizar con QuickLook
            Button(action: {
                
            }) {
                Label("Vista previa", systemImage: "eye")
            }
            
            Button(action: {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first,
                   let rootView = window.rootViewController?.view {
                    FilesAppManager.abrirConOpciones(url: elemento.url, desde: rootView)
                }
            }) {
                Label("Abrir con", systemImage: "door.french.open")
            }
            
            Menu {
                
                Button(action: {
                    FilesAppManager.abrirDirectorioDelArchivo(url: elemento.url)
                }) {
                    Label("Abrir en Archivos", systemImage: "folder")
                }
                
                Button(action: {
                    FilesAppManager.copiarYAbrirEnFiles(url: elemento.url)
                }) {
                    Label("Exportar a Archivos", systemImage: "square.and.arrow.up.on.square")
                }
                
                Button(action: {
                    FilesAppManager.vistaPreviaDeArchivos(url: elemento.url)
                }) {
                    Label("Vista previa en Archivos", systemImage: "eye")
                }
                
            } label: {
                Label("Mostrar en Archivos", systemImage: "folder")
            }
            
            Menu {
                if let _ = elemento as? Archivo {
                    Button {
                        cambiarMiniaturaArchivo?(.imagenBase)
                    } label: {
                        Label("Imagen base", systemImage: "photo")
                    }
                    Button {
                        cambiarMiniaturaArchivo?(.primeraPagina)
                    } label: {
                        Label("Primera página", systemImage: "doc.text")
                    }
                } else if let _ = elemento as? Coleccion {
                    Button {
                        cambiarMiniaturaColeccion?(.carpeta)
                    } label: {
                        Label("Carpeta", systemImage: "folder")
                    }
                    Button {
                        cambiarMiniaturaColeccion?(.tray)
                    } label: {
                        Label("Bandeja", systemImage: "tray")
                    }
                }
            } label: {
                Label("Cambiar portada", systemImage: "paintbrush")
            }
        }
        
        Button(role: .destructive) {
            self.borrarPresionado = true
        } label: {
            Label("Borrar", systemImage: "trash")
        }

        
    }
}
