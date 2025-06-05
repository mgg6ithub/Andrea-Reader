//
//  RigthMenu.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

struct MenuDerecha: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            
            Button(action: {
//                withAnimation {
//                    self.isMultipleSelectionPressed = true
//                }
            }) {
                Image(systemName: "checkmark.rectangle.stack")
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .contentTransition(.symbolEffect(.replace))
                    .fontWeight(appEstado.constantes.iconWeight)
            }
            
        }
        .frame(maxWidth: 70)
        
    }
    
}
