
import SwiftUI

struct MenuIzquierda: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    // --- PARAMETROS ---
    @ObservedObject var coleccionActualVM: ModeloColeccion
    var c2: Color
    var iconSize: CGFloat
    var iconFont: EnumFuenteIcono
    
    // --- ESTADO ---
    @State private var mostrarMenuLateral: Bool = false
    @State private var mostrarPopover = false
    
    private var const: Constantes { ap.constantes }
   
    private var c1: Color {
        if me.dobleColor {
            return ap.colorActual
        } else if me.colorGris {
            return .gray
        } else {
            return ap.temaResuelto.menuIconos
        }
    }
    
    var body: some View {
        HStack {
            //MARK: --- MOSTRAR MENU LATERAL ---
            if me.iconoMenuLateral {
                Button(action: {
                    ap.sideMenuVisible.toggle()
                }) {
                    Image(systemName: "sidebar.trailing")
                        .font(.system(size: iconSize))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(c2)
                        .fontWeight(iconFont.weight)
                }
                .offset(y: 2)
            }
            
            //MARK: --- SISTEMA DE ARCHIVOS ARBOL INDEXADO LATERAL ---
            if ap.sistemaArchivos == .arbol {
                ZStack {
                    PopOutCollectionsView() { isExpandable in
                        Image("custom-library.badge")
                            .font(.system(size: iconSize * 1.01))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(c1, c2)
                            .fontWeight(iconFont.weight)
                        //                            .symbolEffect(.bounce, value: menuModel.newDirectoryCreated)
                    } content: { isExpandable, cerrarMenu in
                        ListaColeccionMenu(onSeleccionColeccion: cerrarMenu)
                            .frame(width: 300)
                    }
                }
                .offset(y: -1.5)
                .padding(0)
            }
            
            //MARK: --- FLECHA TRADICIONAL PARA IR ATRAS UNA COLECCION ---
            if me.iconoFlechaAtras {
                if pc.getColeccionActual().coleccion.nombre != "HOME" {
//                    if ap.sistemaArchivos == .tradicional {
                        Button(action: {
                            pc.sacarColeccion()
                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: iconSize * 1.01))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(c2)
                                .fontWeight(iconFont.weight)
                        }
                        .offset(y: 1.0)
//                    }
                }
            }
            
        }
        .padding(0)
        .animacionDesvanecer(c1)
    }
}
