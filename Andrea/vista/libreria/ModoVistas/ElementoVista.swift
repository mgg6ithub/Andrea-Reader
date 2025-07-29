
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
//                Section(header: Text(elemento.nombre)) {
//                    Text("Mostrar informacion")
//                    Text("Completar lectura")
//                    
//                    Menu {
//                        Button(action: {
//                            cambiarMiniatura?(.imagenBase)
//                        }) {
//                            Label("Imagen base", systemImage: "text.document")
//                        }
//                        
//                        Button(action: {
//                            cambiarMiniatura?(.primeraPagina)
//                        }) {
//                            Label("Primera página", systemImage: "text.document")
//                        }
//                    } label: {
//                        Label("Cambiar portada", systemImage: "paintbrush")
//                    }
//                    
//                    Menu {
//
//                    } label: {
//                        Label("Cambiar portada", systemImage: "paintbrush")
//                    }
//                }
//
//                Button("Borrar", role: .destructive) {
//                    borrarPresionado = true
//                }
                ZStack {
                    ContextMenuContenido(
                        elemento: elemento,
                        cambiarMiniaturaArchivo: cambiarMiniaturaArchivo,
                        cambiarMiniaturaColeccion: cambiarMiniaturaColeccion,
                        borrarPresionado: $borrarPresionado
                    )
                }
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
    }
}


struct ContextMenuContenido: View {
    let elemento: any ElementoSistemaArchivosProtocolo
    let cambiarMiniaturaArchivo: ((EnumTipoMiniatura) -> Void)?
    let cambiarMiniaturaColeccion: ((EnumTipoMiniaturaColeccion) -> Void)?
    @Binding var borrarPresionado: Bool
    
    var body: some View {
        Section(header: Text(elemento.nombre)) {
            Text("Mostrar información")
            Text("Completar lectura")
            
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
        
        Button("Borrar", role: .destructive) {
            borrarPresionado = true
        }
        
    }
}




