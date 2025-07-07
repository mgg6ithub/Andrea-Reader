//
//  AndreaAppView.swift
//  Andrea
//
//  Created by mgg on 28/5/25.
//

import SwiftUI

struct AndreaAppView: View {
    
//    @StateObject private var appEstado = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//    @StateObject private var appEstado = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//    @StateObject private var appEstado = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
    @StateObject private var appEstado = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
//    @StateObject private var appEstado = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
//    @StateObject private var appEstado = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
    @StateObject private var menuEstado = MenuEstado()//Inicalizamos el sistema de archivos
    @StateObject private var pc = PilaColecciones.getPilaColeccionesSingleton //Inicalizamos la pila de las colecciones
    
    @State private var sideMenuVisible: Bool = false
    
    var body: some View {
        
        ZStack {
            VistaPrincipal()
                .environmentObject(appEstado)
                .environmentObject(menuEstado)
//                .environmentObject(sa)
                .environmentObject(pc)
            
            if sideMenuVisible {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.sideMenuVisible = false
                    }
                
                HStack {
                    SideMenu()
                        .frame(width: 300)
                        .offset(x: sideMenuVisible ? 0 : -300)
                        .animation(.spring(), value: sideMenuVisible)
                    
                    Spacer()
                }
                
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        if value.translation.width > 100 {
                            self.sideMenuVisible = true
                        }
                    }
                }
        )
        
    }
    
}

struct AndreaAppView_Preview: PreviewProvider {
    static var previews: some View {
        // Instancias de ejemplo para los objetos de entorno
        let appStatePreview = AppEstado()   // Reemplaza con inicialización adecuada
//        let appEstadoPreview = AppEstado() // Reemplaza con inicialización adecuada
        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
        let menuEstadoPreview = MenuEstado() // Reemplaza con inicialización adecuada
        let pc = PilaColecciones.getPilaColeccionesSingleton

        return AndreaAppView()
            .environmentObject(appStatePreview)
            .environmentObject(appEstadoPreview)
            .environmentObject(menuEstadoPreview)
            .environmentObject(pc)
    }
}
