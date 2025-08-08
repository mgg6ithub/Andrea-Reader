//
//  RectangleDegradado.swift
//  Andrea
//
//  Created by mgg on 31/5/25.
//

import SwiftUI

struct MasTemas<T: Equatable>: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    // --- PARAMETROS ---
    let tema: EnumTemas
    let color1: Color
    let color2: Color
    var opcionSeleccionada: T
    @Binding var opcionActual: T
    
    // --- VARIABLES CALCULADAS ---
    var const: Constantes { ap.constantes }
    var isSelected: Bool { return opcionActual == opcionSeleccionada }
    
    var body: some View {
        
        VStack {
            Text(tema.rawValue)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                ap.temaActual = tema
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
                        .frame(width: const.cAnchoRect * 0.75, height: const.cAlturaRect * 0.75)
                        .shadow(color: ap.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: ap.shadows ? 5 : 0, x: 0, y: ap.shadows ? 2 : 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    isSelected
                                        ? (ap.temaActual == .dark ? Color.white : Color.black)
                                        : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                    
                    Image(systemName: "rectangle.fill")
                        .font(.system(size: ap.constantes.anchoRectangulo * 0.35))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [color1.opacity(0.4), color2.opacity(0.9)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.2), radius: ap.shadows ? 5 : 0 , x: 0, y: ap.shadows ? 5 : 0)
                }
            }
        }
        .padding(.bottom, 10)
    }
    
}
