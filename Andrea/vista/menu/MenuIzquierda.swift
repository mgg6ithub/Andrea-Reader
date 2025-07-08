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
            }
            
            
            //MARK: --- SISTEMA DE ARCHIVOS ARBOL INDEXADO LATERAL ---
            
            if appEstado.sistemaArchivos == .arbol {
                Button(action: {
                                            
                    //mostrar colecciones
                    
                }) {
                    Image("custom.library")
                        .font(.system(size: appEstado.constantes.iconSize))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(appEstado.constantes.iconColor.gradient)
                        .fontWeight(appEstado.constantes.iconWeight)
                }
            }
            
            Spacer()
            
        }
        .frame(maxWidth: 120)
        
    }
    
}
