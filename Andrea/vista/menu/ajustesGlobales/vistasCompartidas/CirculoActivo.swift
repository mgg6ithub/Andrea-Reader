//
//  CirculoActivo.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

struct CirculoActivo: View {
    
    @EnvironmentObject var appEstado: AppEstado

    var isSection: Bool
    
    var body: some View {
        
        Circle()
            .fill(isSection ? appEstado.constantes.iconColor : Color.clear)
            .shadow(
                color: isSection ? appEstado.constantes.iconColor : Color.clear,
                radius: 6
            )
            .frame(width: 8, height: 8)
        
    }
    
}
