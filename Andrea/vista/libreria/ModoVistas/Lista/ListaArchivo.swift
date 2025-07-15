//
//  ListaArchivo.swift
//  Andrea
//
//  Created by mgg on 15/7/25.
//

import SwiftUI

struct ListaArchivo: View {
    
    @ObservedObject var archivo: Archivo
    @StateObject private var viewModel = ArchivoThumbnailViewModel()
    @ObservedObject var coleccionVM: ColeccionViewModel
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 0) {
            
            ZStack {
                if let img = viewModel.miniatura {
                    Image(uiImage: img)
                        .resizable()
                } else {
                    ProgressView()
                }
            }
            .frame(width: coleccionVM.altura - 47.5)
            
            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(archivo.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("Andrea la mas guapa del mundo pero que guapa es con esos pedazo de papos la madre que me pario. Hay diso mios que guapa es la pocala blablanskanks askdaskd algo mas no se que mas.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
//                        .lineLimit(scaleSize > 0.7 ? nil : 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                   
                    ProgresoLista(archivo: archivo, coleccionVM: coleccionVM)
                    
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    InformacionLista(archivo: archivo, coleccionVM: coleccionVM)
                }
            }
            .padding()
            
        } //HStack principal
        .frame(height: coleccionVM.altura)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .onAppear {
            
            viewModel.loadThumbnail(color: coleccionVM.color, for: archivo)

//            withAnimation(.easeOut(duration: 0.4).delay(Double.random(in: 0.2...0.4))) {
                isVisible = true
//            }
        }
        .onDisappear {
            viewModel.unloadThumbnail(for: archivo)
        }
    }
}
