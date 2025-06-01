//
//  AjustesMenu.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

//import Foundation
import SwiftUI

struct AjustesMenu: View {
    
    var body: some View {
        ZStack {}
    }
    
}

//struct AjustesMenu: View {
//    
//    @EnvironmentObject var appEstado: AppEstado1
//    @EnvironmentObject var menuEstado: MenuEstado
//    
//    var isSection: Bool
//    
//    var body: some View {
//        
//        Text("Ajustes del menu")
//            .font(.system(size: appEstado.constantes.titleSize, weight: .bold))
//            .font(.headline)
//            .foregroundColor(.primary)
//            .padding(.bottom, 25)
//        
//        Text("Puedes añadir o eliminar iconos al menu para personalizarlo como mas te guste.")
//            .font(.system(size: appEstado.constantes.subTitleSize))
//            .foregroundColor(.secondary)
//            .padding(.bottom, 5)
//            .frame(maxWidth: w, alignment: .leading)
//            .padding(.bottom, 20)
//        
//        VStack(spacing: 0){
//            HStack {
//                CirculoActivo(isSection: isSection)
//                Text("Activar o desactivar iconos")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                
//            }
//            .padding(.bottom, 4.5)
//            .frame(maxWidth: w - 42.5, alignment: .leading)
//            
//            ZStack {
//                
//                RoundedRectangle(cornerRadius: 25)
//                    .fill(Color.gray.opacity(0.2))
//                    .frame(
//                        width: w
//                    )
//                    .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
//                
//                VStack {
//                    CurrentSettingToggle(titulo: "Icono menu lateral", descripcion: "Activa o desactiva el icono del menu lateral del menu.", opcionBinding: $menuEstado.menuIzquierdaSideMenuIcono, opcionTrue: "Deshabilitar icono menu lateral", opcionFalse: "Habilitar icono menu lateral", w: w, isInsideToggle: true, isDivider: false)
//                    
//                    CurrentSettingToggle(titulo: "Flecha lateral", descripcion: "Activa o desactiva la flecha para ir atras en una coleccion.", opcionBinding: $menuEstado.menuIzquierdaFlechaLateral, opcionTrue: "Deshabilitar icono flecha lateral", opcionFalse: "Habilitar icono flecha lateral", w: w, isInsideToggle: true, isDivider: false)
//                }
//                
//            }
//            .padding(.bottom, 20)
//            
//            HStack {
//                CirculoActivo(isSection: isSection)
//                Text("Tamaños del menu")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                
//            }
//            .padding(.bottom, 4.5)
//            .frame(maxWidth: w - 42.5, alignment: .leading)
//            
//            ZStack {
//                
//                RoundedRectangle(cornerRadius: 25)
//                    .fill(Color.gray.opacity(0.2))
//                    .frame(
//                        width: w
//                    )
//                    .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
//                
//                VStack {}
//                
//            }
//        }
//        
//    }
//    
//}
