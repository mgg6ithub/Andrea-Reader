
import SwiftUI

struct ListaVista: View {
    @ObservedObject var vm: ColeccionViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(vm.elementos, id: \.id) { elemento in
                    HStack(spacing: 12) {
                        // Miniatura + título en fila
                        if let archivo = elemento as? Archivo {
                            // aquí podrías reutilizar CuadriculaArchivo o hacer un ThumbnailView
                            Text(archivo.name)
                        } else {
                            // placeholder
                            let idx = vm.elementos.firstIndex { $0.id == elemento.id } ?? 0
                            PlaceholderElementView(index: idx)
                                .frame(width: 60, height: 60)
                        }
                        // Usa la propiedad correcta: si tu Archivo tiene `name`:
                        if let archivo = elemento as? Archivo {
                            Text(archivo.name)
                                .font(.body)
                        } else {
                            Text("Placeholder")
                                .font(.body)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            .padding(.vertical)
        }
    }
}

