//
//  ContentView.swift
//  Andrea
//
//  Created by mgg on 28/5/25.
//

import SwiftUI

struct VistaPrincipal: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    
    var body: some View {
        NavigationStack {
            ZStack {
                appEstado.temaActual.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack {
                    
                    MenuVista()
                    
                    
                    HistorialColecciones()
                        .frame(height: 30)
                    
                    
                    ZStack {
                        
                        LibreriaEjemplo()
                            .padding()
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, ConstantesPorDefecto().horizontalPadding)
            }
            .foregroundColor(appEstado.temaActual.textColor)
            .animation(.easeInOut, value: appEstado.temaActual)
        }
    }
}
