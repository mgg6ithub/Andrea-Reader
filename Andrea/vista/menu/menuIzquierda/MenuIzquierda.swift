
import SwiftUI

struct MenuIzquierda: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    // --- PARAMETROS ---
//    var c1: Color
//    var c2: Color
//    var iconSize: CGFloat
//    var fuente: Font.Weight
    
    // --- ESTADO ---
    @State private var mostrarMenuLateral: Bool = false
    @State private var mostrarPopover = false
    
    private var const: Constantes { ap.constantes }
    
    private var c2: Color {
        if me.colorGris {
            return .gray
        } else {
            return ap.temaActual.menuIconos
        }
    }
    
    private var c1: Color {
        if me.dobleColor {
            return ap.colorActual
        } else if me.colorGris {
            return .gray
        } else {
            return ap.temaActual.menuIconos
        }
    }
    
    private var iconSize: CGFloat { me.iconSize }
    
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
                        .foregroundStyle(c1, c2)
                        .fontWeight(const.iconWeight)
                }
//                .offset(y: 3)
            }
            
            //MARK: --- FLECHA TRADICIONAL PARA IR ATRAS UNA COLECCION ---
            if me.iconoFlechaAtras {
                if pc.getColeccionActual().coleccion.nombre != "HOME" {
                    if ap.sistemaArchivos == .tradicional {
                        Button(action: {

                            pc.sacarColeccion()

                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: iconSize * 1.01))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(c1, c2)
                                .fontWeight(const.iconWeight)
                        }
//                        .offset(y: 1.0)
                    }
                }
            }
            
            
            //MARK: --- SISTEMA DE ARCHIVOS ARBOL INDEXADO LATERAL ---
            if ap.sistemaArchivos == .arbol {
                ZStack {
                    PopOutCollectionsView() { isExpandable in
                        Image("custom-library.badge")
                            .font(.system(size: iconSize * 1.01))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(c1, c2)
                            .fontWeight(const.iconWeight)
                        //                            .symbolEffect(.bounce, value: menuModel.newDirectoryCreated)
                    } content: { isExpandable, cerrarMenu in
                        ListaColeccionMenu(onSeleccionColeccion: cerrarMenu)
                            .frame(width: 300)
                    }
                }
                .padding(0)
            }
            
        }
        .padding(0)
    }
}
