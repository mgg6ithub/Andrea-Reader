
import SwiftUI

struct MenuIzquierda: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    // --- ESTADO ---
    @State private var mostrarMenuLateral: Bool = false
    @State private var mostrarPopover = false
    
    private var const: Constantes { appEstado.constantes }
    private var iconColor: Color { appEstado.temaActual.menuIconos }
    
    var body: some View {

        HStack {
            
            //MARK: --- FLECHA TRADICIONAL PARA IR ATRAS UNA COLECCION ---
            
            //                if pc.getColeccionActual().coleccion.name != "HOME" {
            //                    if menuEstado.menuIzquierdaFlechaLateral {
            //                        Button(action: {
            //
            //                            pc.sacarColeccion()
            //
            //                        }) {
            //                            Image(systemName: "arrow.backward")
            //                                .font(.system(size: appEstado.constantes.iconSize * 0.9))
            //                                .symbolRenderingMode(.palette)
            //                                .foregroundStyle(appEstado.constantes.iconColor.gradient)
            //                                .fontWeight(appEstado.constantes.iconWeight)
            //                        }
            //                        .offset(y: 1.0)
            //                    }
            //                }
            
            //MARK: --- MOSTRAR MENU LATERAL ---
            
            //                if menuEstado.menuIzquierdaSideMenuIcono {
            //                    Button(action: {
            //
            //                        //                isSideMenuVisible.toggle()
            //
            //                    }) {
            //                        Image(systemName: "sidebar.trailing")
            //                            .font(.system(size: appEstado.constantes.iconSize))
            //                            .symbolRenderingMode(.palette)
            //                            .foregroundStyle(appEstado.constantes.iconColor.gradient)
            //                            .fontWeight(appEstado.constantes.iconWeight)
            //                    }
            //                    .offset(y: 1.6)
            //                }
            //
            
            //MARK: --- SISTEMA DE ARCHIVOS ARBOL INDEXADO LATERAL ---
            ZStack {
                PopOutCollectionsView() { isExpandable in
                    Image("custom-library.badge")
                        .font(.system(size: const.iconSize * 1.01))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(appEstado.colorActual, iconColor)
//                        .foregroundStyle(appEstado.temaActual.colorContrario)
                        .fontWeight(const.iconWeight)
                    //                            .symbolEffect(.bounce, value: menuModel.newDirectoryCreated)
                } content: { isExpandable, cerrarMenu in
                    ListaColeccionMenu(onSeleccionColeccion: cerrarMenu)
                        .frame(width: 300)
                }
            }
            .padding(0)
            
        }
        .padding(0)
    }
}
