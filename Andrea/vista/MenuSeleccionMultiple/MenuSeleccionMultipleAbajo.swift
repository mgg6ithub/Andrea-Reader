

import SwiftUI

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
////        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
////        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
//        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let me = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.preview
//
//        return AndreaAppView()
//            .environmentObject(ap)
//            .environmentObject(me)
//            .environmentObject(pc)
//    }
//}

struct MenuSeleccionMultipleAbajo: View {
    
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State var eliminarPresionado: Bool = false
    @State private var accionDocumento: EnumAccionDocumento? = nil
    private let constantes = ConstantesPorDefecto()
    
//    @ObservedObject private var coleccionActualVM: ModeloColeccion
    private var coleccionActualVM: ModeloColeccion {
            pc.getColeccionActual()
        }
    private let sa: SistemaArchivos = SistemaArchivos.sa
        
//    init() {
//        _coleccionActualVM = ObservedObject(initialValue: PilaColecciones.pilaColecciones.getColeccionActual())
//    }
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
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
                    
                }
                .opacity(me.elementosSeleccionados.count > 0 ? 1.0 : 0.2)
                .padding(.horizontal, constantes.horizontalPadding)
                .confirmationDialog(
                    "¿Estás seguro de que quieres borrar \(me.elementosSeleccionados.count)?",
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
            
            HStack {
                MenuAcciones()
                
                Button("Eliminar", role: .destructive) {
                    eliminarPresionado.toggle()
                }
                .foregroundColor(Color.red)
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
