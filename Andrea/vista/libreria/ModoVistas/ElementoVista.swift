
import SwiftUI

struct ElementoVista<Content: View>: View {
    
    @EnvironmentObject var appEstado: AppEstado
    
    @ObservedObject var vm: ColeccionViewModel
    let elemento: any ElementoSistemaArchivosProtocolo
    let scrollIndex: Int? // <- NUEVO
    @ViewBuilder let content: () -> Content

    private let sa: SistemaArchivos = SistemaArchivos.sa
    @State private var mostrarConfirmacion = false

    var body: some View {
        content()
//            .background(appEstado.temaActual.cardColor)
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
                Section(header: Text(elemento.name)) {
                    Text("Mostrar informacion")
                    Text("Completar lectura")
                    Menu {
                        // ...
                    } label: {
                        Label("Cambiar portada", systemImage: "paintbrush")
                    }
                }

                Button("Borrar", role: .destructive) {
                    mostrarConfirmacion = true
                }
            }
            .confirmationDialog(
                "¿Estás seguro de que quieres borrar \(elemento.name)?",
                isPresented: $mostrarConfirmacion,
                titleVisibility: .visible
            ) {
                Button("Borrar", role: .destructive) {
                    sa.borrarElemento(elemento: elemento, vm: vm)
                }
                Button("Cancelar", role: .cancel) {}
            }
    }
}


