//
//  LeftMenu.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

struct MenuIzquierda: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    @EnvironmentObject var menuEstado: MenuEstado
    
    var body: some View {
        
        HStack {
            
            if menuEstado.menuIzquierdaFlechaLateral {
                Button(action: {
                                            
    //                isSideMenuVisible.toggle()
                    
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: appEstado.constantes.iconSize))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(appEstado.constantes.iconColor.gradient)
                        .fontWeight(appEstado.constantes.iconWeight)
                }
            }
            
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
            
            Button(action: {
                                        
//                isSideMenuVisible.toggle()
                
            }) {
                Image("custom.library")
                    .font(.system(size: appEstado.constantes.iconSize))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .fontWeight(appEstado.constantes.iconWeight)
            }
            
            Spacer()
            
        }
        .frame(maxWidth: 120)
        
    }
    
}
