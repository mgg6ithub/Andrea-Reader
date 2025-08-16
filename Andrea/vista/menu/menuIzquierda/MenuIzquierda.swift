
import SwiftUI

struct MenuIzquierda: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    // --- ESTADO ---
    @State private var mostrarMenuLateral: Bool = false
    @State private var mostrarPopover = false
    
    private var const: Constantes { ap.constantes }
    private var iconColor: Color { ap.temaActual.menuIconos }
    
    var body: some View {
        HStack {
            //MARK: --- MOSTRAR MENU LATERAL ---
            if me.iconoMenuLateral {
                Button(action: {
                    me.sideMenuVisible.toggle()
                }) {
                    Image(systemName: "sidebar.trailing")
                        .font(.system(size: const.iconSize))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(ap.colorActual, iconColor)
                        .fontWeight(const.iconWeight)
                }
                .offset(y: 3)
            }
            
            //MARK: --- FLECHA TRADICIONAL PARA IR ATRAS UNA COLECCION ---
            if me.iconoFlechaAtras {
                if pc.getColeccionActual().coleccion.nombre != "HOME" {
                    if ap.sistemaArchivos == .tradicional {
                        Button(action: {

                            pc.sacarColeccion()

                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: const.iconSize * 1.01))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(ap.colorActual, iconColor)
                                .fontWeight(const.iconWeight)
                        }
                        .offset(y: 1.0)
                    }
                }
            }
            
            
            //MARK: --- SISTEMA DE ARCHIVOS ARBOL INDEXADO LATERAL ---
            if ap.sistemaArchivos == .arbol {
                ZStack {
                    PopOutCollectionsView() { isExpandable in
                        Image("custom-library.badge")
                            .font(.system(size: const.iconSize * 1.01))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(ap.colorActual, iconColor)
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
