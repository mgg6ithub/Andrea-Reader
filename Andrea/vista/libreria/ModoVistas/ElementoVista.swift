
import SwiftUI

struct ElementoVista<Content: View>: View {
    @EnvironmentObject var appEstado: AppEstado

    @ObservedObject var vm: ModeloColeccion
    let elemento: any ElementoSistemaArchivosProtocolo
    let scrollIndex: Int?
    var cambiarMiniatura: ((EnumTipoMiniatura) -> Void)? = nil
    
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
                Section(header: Text(elemento.nombre)) {
                    Text("Mostrar informacion")
                    Text("Completar lectura")
                    
                    Menu {
                        Button(action: {
                            cambiarMiniatura?(.imagenBase)
                        }) {
                            Label("Imagen base", systemImage: "text.document")
                        }
                        
                        Button(action: {
                            cambiarMiniatura?(.primeraPagina)
                        }) {
                            Label("Primera página", systemImage: "text.document")
                        }
                    } label: {
                        Label("Cambiar portada", systemImage: "paintbrush")
                    }
                    
                    Menu {

                    } label: {
                        Label("Cambiar portada", systemImage: "paintbrush")
                    }
                }

                Button("Borrar", role: .destructive) {
                    borrarPresionado = true
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



