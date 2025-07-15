
import SwiftUI

struct ListaVista: View {
    
    @ObservedObject var vm: ColeccionViewModel
    
    @State private var currentMagnification: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0
    @State private var scrollEnabled: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(vm.elementos, id: \.id) { elemento in
                    HStack(spacing: 12) {
                        // Miniatura + título en fila
                        if let _ = elemento as? ElementoPlaceholder {
                            let idx = vm.elementos.firstIndex { $0.id == elemento.id } ?? 0
                            PlaceholderElementView(index: idx, width: 180, height: 180)
                                .frame(width: 60, height: 60)
                        } else if let archivo = elemento as? Archivo {
                            ListaArchivo(archivo: archivo, coleccionVM: vm)
                        } else if let coleccion = elemento as? Coleccion {
                            ListaColeccion(coleccion: coleccion)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            .padding(.vertical)
        }
        .simultaneousGesture(
            MagnificationGesture()
                .onChanged { value in
                    scrollEnabled = false
                    currentMagnification = value
                }
                .onEnded { value in
                    let delta = value / lastMagnification

                    if delta > 1.1, vm.altura < 250 {
                        vm.altura += 30
                    } else if delta < 0.9, vm.altura > 100 {
                        vm.altura -= 30
                    }
                    
                    PersistenciaDatos().guardarAtributoVista(coleccion: vm.coleccion, modo: vm.modoVista, atributo: "altura", valor: vm.columnas)
                    
                    lastMagnification = 1.0
                    currentMagnification = 1.0

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        scrollEnabled = true
                    }
                },
            including: .all // <- esto da prioridad real al gesto incluso sobre el scroll
        )
    }
}

