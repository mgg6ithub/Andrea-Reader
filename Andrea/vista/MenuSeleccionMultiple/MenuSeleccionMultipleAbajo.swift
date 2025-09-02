

import SwiftUI


struct MenuSeleccionMultipleAbajo: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State var eliminarPresionado: Bool = false
    @State private var accionDocumento: EnumAccionDocumento? = nil
    private let constantes = ConstantesPorDefecto()
    
    @ObservedObject private var coleccionActualVM: ModeloColeccion
    
    private var tema: EnumTemas { ap.temaResuelto }
    
    //PREVIEW
//    private var coleccionActualVM: ModeloColeccion {
//            pc.getColeccionActual()
//        }
    private let sa: SistemaArchivos = SistemaArchivos.sa
    init() {
        _coleccionActualVM = ObservedObject(initialValue: PilaColecciones.pilaColecciones.getColeccionActual())
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    
                    AccionSeleccionMultiple(nombreBoton: "Completar") {
                        me.aplicarAccionPorElemento { elemento in
                            if let archivo = elemento as? Archivo {
                                archivo.estadisticas.completarLectura()
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
                    
                }
                .opacity(me.elementosSeleccionados.count > 0 ? 1.0 : 0.2)
                .padding(.horizontal, constantes.horizontalPadding)
                .sheet(item: $accionDocumento) { accion in
                    DocumentPicker(
                        onPick: { urls in
                            guard let destino = urls.first else { return }
                            switch accion {
                            case .mover:
                                me.aplicarAccionPorElemento { elemento in
                                    sa.moverElemento(elemento, vm: coleccionActualVM, a: destino)
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
            
            HStack {
                MenuAcciones()
                
                Button("Eliminar", role: .destructive) {
                    eliminarPresionado.toggle()
                }
                .foregroundColor(Color.red)
                .fondoBoton(pH: 7, pV: 7, isActive: true, color: .red, borde: false)
                .confirmationDialog(
                    "¿Estás seguro de que quieres borrar \(me.elementosSeleccionados.count) elemento?",
                    isPresented: $eliminarPresionado, // <- o el tuyo
                    titleVisibility: .visible
                ) {
                    Button("Borrar", role: .destructive) {
                        me.aplicarAccionPorElemento { elemento in
                            sa.borrarElemento(elemento: elemento, vm: coleccionActualVM)
                        }
                    }
                    Button("Cancelar", role: .cancel) {}
                }
            }
            .padding(.horizontal, 10)
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
    @EnvironmentObject var ap: AppEstado
    
    let nombreBoton: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(nombreBoton)
                .font(.system(size: ap.constantes.subTitleSize))
                .foregroundColor(ap.temaResuelto.textColor)
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
            Label("", systemImage: "ellipsis")
        }
    }
}
