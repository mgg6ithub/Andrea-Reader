
import SwiftUI

struct ElementoVista<Content: View>: View {
    @EnvironmentObject var appEstado: AppEstado

    @ObservedObject var vm: ModeloColeccion
    let elemento: any ElementoSistemaArchivosProtocolo
    let scrollIndex: Int?
    @ViewBuilder let content: () -> Content

    @State private var borrarPresionado = false
    @State private var mostrarElementoReal = false
    @State private var esPlaceholder = true

    var body: some View {
        content()
            .opacity(mostrarElementoReal ? 1 : 0)
            .scaleEffect(mostrarElementoReal ? 1 : 0.9)
            .animation(.easeOut(duration: 0.25), value: mostrarElementoReal)
            .onAppear {
                // Detecta si ya no es un placeholder
                if !(elemento is ElementoPlaceholder) {
                    DispatchQueue.main.async {
                        self.mostrarElementoReal = true
                    }
                }
            }
            .onChange(of: elemento.id) {
                if !(elemento is ElementoPlaceholder) {
                    DispatchQueue.main.async {
                        self.mostrarElementoReal = true
                    }
                }
            }
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

                    } label: {
                        Label("Cambiar portada", systemImage: "paintbrush")
                    }
                }

                Button("Borrar", role: .destructive) {
                    borrarPresionado = true
                }
            }
            .confirmationDialog(
                "¿Estás seguro de que quieres borrar \(elemento.name)?",
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



