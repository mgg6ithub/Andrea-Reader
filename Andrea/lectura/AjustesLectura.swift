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
            PopOutCollectionsView(tipoMenuPO: .ajustesLectura, vm: vm) { isExpandable in
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "book.and.wrench")
                            .font(.system(size: ap.constantes.iconSize * 0.95))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(vm.color, Color.black)
                            .symbolEffect(.bounce, value: isPressed)
                            .fontWeight(.thin)
                            .padding(7.4)
                            .background(Color.gray.opacity(0.5).gradient)
                            .cornerRadius(5)
                            .shadow(color: Color.black.opacity(0.25), radius: 2.5, x: 0, y: 2)
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
