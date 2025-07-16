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
                
                if pc.getColeccionActual().coleccion.name != "HOME" {
                    if menuEstado.menuIzquierdaFlechaLateral {
                        Button(action: {
                            
                            pc.sacarColeccion()
                            
                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: appEstado.constantes.iconSize))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(appEstado.constantes.iconColor.gradient)
                                .fontWeight(appEstado.constantes.iconWeight)
                        }
                        .offset(y: 1.0)
                    }
                }
                
                //MARK: --- MOSTRAR MENU LATERAL ---
                
                if menuEstado.menuIzquierdaSideMenuIcono {
                    Button(action: {
                        
                        //                isSideMenuVisible.toggle()
                        
                    }) {
                        Image(systemName: "sidebar.trailing")
                            .font(.system(size: appEstado.constantes.iconSize))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(appEstado.constantes.iconColor.gradient)
                            .fontWeight(appEstado.constantes.iconWeight)
                    }
                    .offset(y: 1.35)
                }
                
                
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
                                                    SistemaArchivos.getSistemaArchivosSingleton.cacheColecciones
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

        
    }
}
