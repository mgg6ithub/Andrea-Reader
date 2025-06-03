//
//  Tema.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import Foundation
import SwiftUI

struct AjustesTema: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    @EnvironmentObject var menuEstado: MenuEstado
    
    
    //VARIABLES PARA EL TEMA
    @State private var isThemeExpanded: Bool = false
    
    var isSection: Bool
    
    //FIJAS
    
    //Subtitulo
    private let cpd = ConstantesPorDefecto()
    private var subTitle: CGFloat { appEstado.constantes.subTitleSize }
    
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * appEstado.constantes.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * appEstado.constantes.scaleFactor} // 20
    private var altoRectanguloFondo: CGFloat {menuEstado.altoRectanguloFondo * appEstado.constantes.scaleFactor}
    
    private var paddingCorto: CGFloat { cpd.paddingCorto }
    
    //VARIABLES
    private var iconSize: CGFloat  { appEstado.constantes.iconSize }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
                
            Text("Tema principal") //TITULO
                .font(.system(size: appEstado.constantes.titleSize, weight: .bold))
                .padding(.vertical, paddingVertical + 5) // 25
                .padding(.trailing, paddingHorizontal)
            
            Text("Los temas son combinaciones de colores que se aplican globalmente a toda la interfaz. Los temas claro y oscuro son los mas usados.")
                .font(.system(size: appEstado.constantes.subTitleSize))
                .foregroundColor(.secondary)
                .frame(width: .infinity, alignment: .leading)
                .padding(.bottom, paddingVertical) // 20
            
            HStack {
                
                CirculoActivo(isSection: isSection)
                
                Text("Selecciona un tema para establecerlo como principal.")
                    .font(.system(size: appEstado.constantes.subTitleSize))
                    .foregroundColor(.secondary)
                    .frame(alignment: .leading)
                
                Spacer()
            }
            .padding(.bottom, paddingCorto)
                
            // Contenedor del rectángulo
            ZStack {
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.2))
                    .frame(
                        height: altoRectanguloFondo
                    )
                    .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
                
                HStack(spacing: 0) {
                    
                    RectangleFormView(
                        titulo: "Claro",
                        icono: "sun.max.fill",
                        coloresIcono: [Color.yellow],
                        temaSeleccionado: .light
                    )
                    
                    RectangleFormView(
                        titulo: "Oscuro",
                        icono: "moon.fill",
                        coloresIcono: [Color.blue],
                        temaSeleccionado: .dark
                    )
                    
                    RectangleFormView(
                        titulo: "Dia/Noche",
                        icono: "custom.dayNight",
                        coloresIcono: [Color.white, Color.white],
                        temaSeleccionado: .dayNight,
                        isCustomImage: true
                    )
                }
            } //fin zstack tema
            .padding(.bottom, paddingVertical)
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                   
                    if appEstado.animaciones {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.isThemeExpanded.toggle()
                        }
                    }
                    else {
                        self.isThemeExpanded.toggle()
                    }
                    
                }) {
                    HStack(spacing: paddingCorto) {
                        Text("Más temas")
                            .font(.system(size: subTitle))
                            .bold()
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: iconSize * 0.65))
                            .bold()
//                            .foregroundColor(self.dynamicColor)
                            .rotationEffect(.degrees(isThemeExpanded ? 90 : 0))
                            .animation(appEstado.animaciones ? .easeInOut(duration: 0.3) : .none, value: isThemeExpanded)
                        
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, paddingCorto)
                
                ZStack {
                    if self.isThemeExpanded {
//                        HStack(alignment: .top) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: altoRectanguloFondo * 0.7)
                                    .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
                                
                                //MAS TEMAS
                                
                                HStack(spacing: 0) {
                                    MasTemas(tema: "verde", color1: .teal, color2: .green)
                                    
                                    MasTemas(tema: "rojo", color1: .red.opacity(0.6), color2: .red.opacity(0.9))
                                    
                                    // Azul claro a azul oscuro
                                    MasTemas(tema: "azul", color1: .blue.opacity(0.5), color2: .blue.opacity(0.8))
                                    
                                    // Naranja claro a naranja oscuro
                                    MasTemas(tema: "naranja", color1: .orange.opacity(0.4), color2: .orange.opacity(0.7))
                            }
                                
                            }
//                        }
//                        .padding(.top, 10)
                    }
                }
                .frame(height: isThemeExpanded ? altoRectanguloFondo * 0.7 : 0) // Animación del tamaño
                .animation(appEstado.animaciones ? .easeInOut(duration: 0.5) : .none, value: isThemeExpanded)
            }
            
        } //fin vstack tema
        .padding(.horizontal, appEstado.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
    }
    
}
