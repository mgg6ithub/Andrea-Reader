//
//  LeftMenu.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

struct MenuIzquierda: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State private var mostrarMenuLateral: Bool = false
    @State private var mostrarPopover = false
    
    //    private let pc: PilaColecciones = PilaColecciones.getPilaColeccionesSingleton
    
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
                
                if appEstado.sistemaArchivos == .arbol {
                                Button(action: {
                                    mostrarPopover.toggle()
                                }) {
                                    Image("custom.library")
                                        .font(.system(size: appEstado.constantes.iconSize))
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(appEstado.constantes.iconColor.gradient)
                                        .fontWeight(appEstado.constantes.iconWeight)
                                }
                                .offset(y: -0.7)
                                // Aquí va el popover
                                .popover(isPresented: $mostrarPopover, arrowEdge: .bottom) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Colecciones")
                                            .font(.headline)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)

                                        Divider()

                                        ScrollView {
                                            LazyVStack(alignment: .leading, spacing: 0) {
                                                ForEach(
                                                    SistemaArchivos.sa.cacheColecciones
                                                        .sorted { $0.value.coleccion.name < $1.value.coleccion.name },
                                                    id: \.key
                                                ) { url, valor in
                                                    Button {
                                                        // Acción al seleccionar
                                                        valor.coleccion.meterColeccion()
                                                        // Actualiza tu vista o VM aquí...
                                                        mostrarPopover = false
                                                    } label: {
                                                        Text(valor.coleccion.name)
                                                            .padding(.vertical, 8)
                                                            .padding(.horizontal)
                                                            .foregroundColor(appEstado.temaActual.textColor)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                    }
                                                    .background(appEstado.temaActual.backgroundColor)
                                                }
                                            }
                                        }
                                        .frame(maxHeight: 300) // límite de alto, ajusta a tu gusto
                                    }
                                    .frame(width: 200) // ajusta el ancho
                                    .background(appEstado.temaActual.cardColor)
                                }
                            }

                            Spacer()
                
            }
            .frame(maxWidth: 120)
//            .padding(.leading, 4)

        
    }
}


//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
//        let appStatePreview = AppEstado()   // Reemplaza con inicialización adecuada
////        let appEstadoPreview = AppEstado() // Reemplaza con inicialización adecuada
////        let appEstadoPreview = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let appEstadoPreview = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
////        let appEstadoPreview = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let appEstadoPreview = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let appEstadoPreview = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let menuEstadoPreview = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.getPilaColeccionesSingleton
//
//        return AndreaAppView()
//            .environmentObject(appStatePreview)
//            .environmentObject(appEstadoPreview)
//            .environmentObject(menuEstadoPreview)
//            .environmentObject(pc)
//    }
//}
