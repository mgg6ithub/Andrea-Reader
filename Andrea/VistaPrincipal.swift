//
//  ContentView.swift
//  Andrea
//
//  Created by mgg on 28/5/25.
//

import SwiftUI

struct VistaPrincipal: View {
    
    @State private var animacionesInicialesActivadas = false
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    @State private var ultimaID: UUID? = nil
    @Namespace private var gridNamespace
    
    private var viewMode: EnumModoVista { menuEstado.modoVistaColeccion }
    
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
                        if let lastVM = pc.coleccionActualVM {
                            ContenidoColeccionVista(vm: lastVM, namespace: gridNamespace)
                        }
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 0.7),
                               value: viewMode)                   // para cambio de modo
                    .animation(.spring(response: 0.5, dampingFraction: 0.7),
                               value: pc.coleccionActualVM?.coleccion.id)
                    
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


struct ContenidoColeccionVista: View {
    
    @ObservedObject var vm: ColeccionViewModel
    @EnvironmentObject var appEstado: AppEstado
    var namespace: Namespace.ID

    var body: some View {
        Group {
            switch vm.modoVista {
            case .cuadricula:
                CuadriculaVista(vm: vm, namespace: namespace)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 1.05, anchor: .top)),
                        removal: .opacity
                    ))
                    .id("grid-\(vm.coleccion.id)")

            case .lista:
                ListaVista(vm: vm)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .id("list-\(vm.coleccion.id)")

            default:
                AnyView(Text("Vista desconocida"))
            }
        }
        .onAppear {
            if vm.appEstado == nil {
                vm.setAppEstado(appEstado)
            }
            vm.cargarElementos()
        }
        .onChange(of: appEstado.sistemaArchivos) { _ in
            vm.cargarElementos()
            print("👀 mostrándose vista con VM: \(vm.coleccion.name)")
        }
    }
    
}
