//
//  Toggle.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//
//

import Foundation
import SwiftUI

struct CurrentSettingToggle: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    
    var titulo: String
    var descripcion: String
    
    @Binding var opcionBinding: Bool
    
    var opcionTrue: String
    var opcionFalse: String
    let w: CGFloat
    
    var isInsideToggle: Bool
    var isDivider: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(titulo)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 10)
            
            Text(descripcion)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 0)
            
            if isInsideToggle {
                withAnimation(.easeInOut(duration: 0.3)) {
                    Toggle(isOn: $opcionBinding) {
                        Text( opcionBinding ? opcionTrue : opcionFalse)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: appEstado.constantes.iconColor))
                    .padding(.bottom, 2)
                }
            } else {
                Toggle(isOn: $opcionBinding) {
                    Text( opcionBinding ? opcionTrue : opcionFalse)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .toggleStyle(SwitchToggleStyle(tint: appEstado.constantes.iconColor))
                .padding(.bottom, 2)
            }
            
            if isDivider && isInsideToggle {
                Divider()
                    .frame(width: w - 110)
            }
            
        }
        .padding([.top, .bottom], isInsideToggle ? 10 : 20)
        .frame(width: w - 40)
        
    }
    
}
