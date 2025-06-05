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
                        .padding(.vertical, 10)
                        .padding(.bottom, 10)
                    
                    
                    HistorialColecciones()
                        .frame(height: 50)
//                        .border(.red)
                    
                    
                    ZStack {
                        
                        LibreriaEjemplo()
                            .padding()
                        
                    }
                    
                    Spacer()
                    
                }
                .preferredColorScheme(appEstado.temaActual == .dark ? .dark : .light)
                .padding(.horizontal, ConstantesPorDefecto().horizontalPadding)
            }
            .foregroundColor(appEstado.temaActual.textColor)
            .animation(.easeInOut, value: appEstado.temaActual)
        }
    }
}
