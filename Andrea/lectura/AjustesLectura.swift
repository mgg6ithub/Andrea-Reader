//
//  AjustesLectura.swift
//  Andrea
//
//  Created by mgg on 3/9/25.
//

import SwiftUI

struct AjustesLectura: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @State private var isPressed: Bool = false
    @State private var isPreviewPressed: Bool = false
    
    var body: some View {
        ZStack {
            PopOutCollectionsView(tipoMenuPO: .ajustesLectura) { isExpandable in
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "book.and.wrench")
                                .font(.system(size: ap.constantes.iconSize * 0.95))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(vm.color, Color.black)
                                .symbolEffect(.bounce, value: isPressed)
                                .fontWeight(.thin)
                        }
                        .padding(7.4)
                        .background(Color.gray.opacity(0.5).gradient)
                        .shadow(color: Color.black.opacity(0.25),
                                radius: 2.5,
                                x: 0, y: 2)
                        .cornerRadius(5)
                    }
                }
                .onChange(of: isExpandable) { old, newValue in
                    // Actualizamos binding inmediato
//                    topRigthMenuButtonPressed = newValue
                    if newValue {
                        // al expandir, aplicamos estilo inmediatamente
                        withAnimation {
//                            headerDecorated = true
                        }
                    } else {
                        // al cerrar, esperamos 0.3s antes de quitar estilo
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                            headerDecorated = false
                        }
                    }
                }

            } content: { isExpandable, cerrarMenu in
                
                @StateObject var viewSettings = ViewSettings()
                
                AjustesLecturaOpciones(vm: vm, isPreviewPressed: $isPreviewPressed, colorPersonalizado: vm.color)
                    .environmentObject(viewSettings)
                .frame(width: 300)
                .cornerRadius(15)
                .fixedSize()
            }
        }
    }
}
