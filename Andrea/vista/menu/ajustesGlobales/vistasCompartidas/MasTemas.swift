//
//  RectangleDegradado.swift
//  Andrea
//
//  Created by mgg on 31/5/25.
//

import SwiftUI

struct MasTemas: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    private var escala: CGFloat { appEstado.constantes.scaleFactor }
    
    //NOMBRE TEMA
    let tema: String
    
    //COLORES
    let color1: Color
    let color2: Color
    
    var body: some View {
        
        VStack {
            Text(tema)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                print(tema, " SELECCIONADO")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color1.opacity(0.4), color2.opacity(0.9)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: (menuEstado.anchoRectanguloSmall * escala) * 0.8, height: (menuEstado.altoRectanguloSmall * escala) * 0.8)
                        .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 5 : 0, x: 0, y: appEstado.shadows ? 2 : 0)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 15)
//                                .stroke(
//                                    appEstado.temaActual == appEstado.temaActual
//                                    ? (appEstado.temaActual == .dark ? Color.white : Color.black)
//                                        : Color.clear,
//                                    lineWidth: 1.5
//                                )
//                        )
                    
                    Image(systemName: "rectangle.fill")
                        .font(.system(size: menuEstado.anchoRectanguloSmall * 0.35))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [color1.opacity(0.4), color2.opacity(0.9)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.2), radius: appEstado.shadows ? 5 : 0 , x: 0, y: appEstado.shadows ? 5 : 0)
                }
            }
//                                    .if(!appEstado.animaciones) { view in
//                                        view.buttonStyle(PlainButtonStyle())
//                                    }
        }
        .padding(.bottom, 10)
    }
    
}
