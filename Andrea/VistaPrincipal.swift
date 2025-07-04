//
//  ContentView.swift
//  Andrea
//
//  Created by mgg on 28/5/25.
//

import SwiftUI

struct VistaPrincipal: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    @EnvironmentObject var pc: PilaColecciones
    
    @State private var ultimaID: UUID? = nil
    
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
                    
                    
//                    ZStack {
                    if let lastVM = pc.coleccionActualVM {
                        CuadriculaVista(vm: lastVM)
                            .onAppear {
                                lastVM.cargarElementos()
                            }
                    }
                    
                    Spacer()
                    
                }
                .preferredColorScheme(appEstado.temaActual == .dark ? .dark : .light)
                .padding(.horizontal, ConstantesPorDefecto().horizontalPadding)
            }
            .foregroundColor(appEstado.temaActual.textColor)
            .animation(.easeInOut, value: appEstado.temaActual)
        }
        .onChange(of: pc.coleccionActualVM?.coleccion.id) { nuevaID in
            guard let nuevaID else { return }
            if nuevaID != ultimaID {
                ultimaID = nuevaID
                if let vm = pc.coleccionActualVM, vm.elementos.isEmpty {
                    vm.cargarElementos()
                }
            }
        }
    }
}
