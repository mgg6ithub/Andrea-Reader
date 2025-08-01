

import SwiftUI

struct MenuSeleccionMultipleAbajo: View {
    
    @EnvironmentObject var me: MenuEstado
    
    @State var eliminarPresionado: Bool = false
    @State private var accionDocumento: EnumAccionDocumento? = nil
    private let constantes = ConstantesPorDefecto()
    
    @ObservedObject private var coleccionActualVM: ModeloColeccion
    private let sa: SistemaArchivos = SistemaArchivos.sa
        
    init() {
        _coleccionActualVM = ObservedObject(initialValue: PilaColecciones.pilaColecciones.getColeccionActual())
    }
    
    var body: some View {
        
        HStack(spacing: 40) {
            
            AccionSeleccionMultiple(nombreBoton: "Completar") {
                me.aplicarAccionPorElemento { elemento in
                    if let archivo = elemento as? Archivo {
                        archivo.completarLectura()
                    }
                }
            }
            
            AccionSeleccionMultiple(nombreBoton: "Mover") {
                accionDocumento = .mover
            }

            AccionSeleccionMultiple(nombreBoton: "Copiar") {
                accionDocumento = .copiar
            }
            
            AccionSeleccionMultiple(nombreBoton: "Favoritos") {
                me.aplicarAccionPorElemento { elemento in
                    elemento.cambiarEstadoFavorito()
                }
            }
            
            AccionSeleccionMultiple(nombreBoton: "Proteger") {
                me.aplicarAccionPorElemento { elemento in
                    elemento.cambiarEstadoProtegido()
                }
            }
            
            Spacer()
            
            MenuAcciones()
            
            Button("Eliminar", role: .destructive) {
                eliminarPresionado.toggle()
            }
            .foregroundColor(Color.red)
            
        }
        .opacity(me.elementosSeleccionados.count > 0 ? 1.0 : 0.2)
        .padding(.horizontal, constantes.horizontalPadding)
        .confirmationDialog(
            "¿Estás seguro de que quieres borrar \(me.elementosSeleccionados.count)?",
            isPresented: $eliminarPresionado, // <- o el tuyo
            titleVisibility: .visible
        ) {
            Button("Borrar", role: .destructive) {
                me.eliminarTodosLosSeleccionados()
            }
            Button("Cancelar", role: .cancel) {}
        }
        .sheet(item: $accionDocumento) { accion in
            DocumentPicker(
                onPick: { urls in
                    guard let destino = urls.first else { return }
                    switch accion {
                    case .mover:
                        me.aplicarAccionPorElemento { elemento in
                            try? sa.moverElemento(elemento, vm: coleccionActualVM, a: destino)
                        }
                    case .copiar:
                        me.aplicarAccionPorElemento { elemento in
                            try? sa.copiarElemento(elemento, vm: coleccionActualVM, a: destino)
                        }
                    default:
                        break
                    }
                },
                onCancel: {},
                allowMultipleSelection: false,
                contentTypes: [.folder]
            )
        }

        
    }
}

enum EnumAccionSeleccionMultiple: Identifiable {
    case mover
    case copiar
    
    var id: String {
        switch self {
        case .mover: return "mover"
        case .copiar: return "copiar"
        }
    }
}



struct AccionSeleccionMultiple: View {
    
    @EnvironmentObject var me: MenuEstado
    
    let nombreBoton: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(nombreBoton)
        }
    }
}


struct MenuAcciones: View {
    var body: some View {
        Menu {
            
            Button(action: {
                
            }) {
                Label("Accion", systemImage: "")
            }
            
            Button(action: {
                
            }) {
                Label("Accion", systemImage: "")
            }
            
            Button(action: {
                
            }) {
                Label("Accion", systemImage: "")
            }
            
        } label: {
            Label("Más", systemImage: "ellipsis")
        }
    }
}
