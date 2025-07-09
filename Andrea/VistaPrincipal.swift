//
//  ContentView.swift
//  Andrea
//
//  Created by mgg on 28/5/25.
//

import SwiftUI

struct VistaPrincipal: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State private var ultimaID: UUID? = nil
    @Namespace private var gridNamespace
    
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
                       // Para cada cambio de colección, mostramos/ocultamos con transición
                       if let lastVM = pc.coleccionActualVM {
                           CuadriculaVista(vm: lastVM, namespace: gridNamespace)
                               .transition(.asymmetric(
                                   insertion: .opacity.combined(with: .scale(scale: 1.05, anchor: .top)),
                                   removal: .opacity
                               ))
                               .id(lastVM.coleccion.id) // fuerza vista nueva en cambio
                               .onAppear {
                                   if lastVM.appEstado == nil {
                                       lastVM.setAppEstado(appEstado)
                                   }
                                   lastVM.cargarElementos()
                               }
                               .onChange(of: appEstado.sistemaArchivos) { _ in
                                   lastVM.cargarElementos()
                               }
                       }
                   }
                   .animation(.spring(response: 0.5, dampingFraction: 0.7), value: pc.coleccionActualVM?.coleccion.id)
                    
                    Spacer()
                    
                }
//                .preferredColorScheme(appEstado.temaActual == .dark ? .dark : .light)
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
