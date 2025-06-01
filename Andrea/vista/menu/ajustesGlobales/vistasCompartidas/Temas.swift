//
//  RectangleFormView.swift
//  iREADER
//
//  Created by mgg on 10/1/25.
//

import Foundation
import SwiftUI

struct RectangleFormView: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    @EnvironmentObject var menuEstado: MenuEstado
    
    @State var titulo: String
    @State var icono: String
    @State var coloresIcono: [Color] // Array de colores
    
    var temaSeleccionado: EnumTemas
    
    var isCustomImage: Bool? = nil
    
    @State private var isBouncing = false // Estado para controlar el rebote
    
    var isSelected: Bool { return appEstado.temaActual == temaSeleccionado }
    
    //FIJAS
    
    private var anchoConstante: CGFloat { menuEstado.anchoRectanguloSmall }
    private var altoConstante: CGFloat { menuEstado.altoRectanguloSmall }
    
    private var scala: CGFloat { appEstado.constantes.scaleFactor }
    private var ancho: CGFloat { appEstado.resolucionLogica == .big ? anchoConstante : anchoConstante * scala }
    private var alto: CGFloat { appEstado.resolucionLogica == .big ? altoConstante : altoConstante * scala }
    
    private var iconSize: CGFloat { (ConstantesValores().iconSize + 20) * scala }
    
    var body: some View {
        
        VStack {
            
            Text(titulo)
                .frame(maxWidth: .infinity, alignment: .center) // Centrar el texto
                .font(.subheadline)
                .foregroundColor(isSelected ? .primary : .secondary.opacity(0.3))
            
            Button(action: {
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    isBouncing.toggle() // Activar el rebote cuando se presiona el botón
                    appEstado.temaActual = temaSeleccionado
                }
                
            }) {
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: ancho, height: alto)
                        .foregroundColor(isSelected ? Color.gray.opacity(1.0) : Color.gray.opacity(0.3)) // Gris claro con opacidad
                        .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 5 : 0, x: 0, y: appEstado.shadows ? 2 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    isSelected
                                    ? (appEstado.temaActual == .dark ? Color.white : Color.black) // Condición para color del borde
                                        : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                    
                    ZStack {
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: iconSize))
                            .scaleEffect(x: 1.1, y: 1.3, anchor: .center)
                            .foregroundColor(isSelected ? Color.gray.opacity(0.8) : Color.clear)
                            .zIndex(0)
                            .shadow(color: .black.opacity(0.1), radius: appEstado.shadows ? 2.5 : 0 , x: 0, y: appEstado.shadows ? 2.5 : 0)
                        
                        if isCustomImage != nil { // Si el icono es personzalido
                            Image(icono)
                                .zIndex(1)
                                .font(.system(size: iconSize)) // Ajusta el tamaño de la imagen
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(isSelected ? coloresIcono[0] : coloresIcono[0].opacity(0.6), coloresIcono.dropFirst().first ?? coloresIcono[0])
                                .shadow(
                                    color: isSelected ? coloresIcono[0].opacity(0.5) : .clear, // Aplica la sombra solo cuando `isBouncing` es true
                                    radius: appEstado.shadows ? 5 : 0,
                                    x: 0,
                                    y: appEstado.shadows ? 5 : 0
                                )
                                .symbolEffect(.bounce, value: isBouncing)
                        } else {
                            Image(systemName: icono)
                                .zIndex(1)
                                .font(.system(size: iconSize)) // Ajusta el tamaño de la imagen
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(isSelected ? coloresIcono[0] : coloresIcono[0].opacity(0.6), coloresIcono.dropFirst().first ?? coloresIcono[0])
                                .shadow(
                                    color: isSelected ? coloresIcono[0].opacity(0.5) : .clear, // Aplica la sombra solo cuando `isBouncing` es true
                                    radius: appEstado.shadows ? 5 : 0,
                                    x: 0,
                                    y: appEstado.shadows ? 5 : 0
                                )
                                .symbolEffect(.bounce, value: isBouncing)
                        }
                    }
                    
                }
            }
//            .if(!appEstado.animaciones) { view in
//                view.buttonStyle(PlainButtonStyle())
//            }

        }
        
    }
    
}
