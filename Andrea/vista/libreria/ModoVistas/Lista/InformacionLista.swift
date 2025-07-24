//
//  InformacionLista.swift
//  Andrea
//
//  Created by mgg on 15/7/25.
//

import SwiftUI

struct InformacionLista: View {
    
    let archivo: Archivo
    @ObservedObject var coleccionVM: ModeloColeccion
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            
            Text(archivo.fileType.rawValue)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Spacer()
            
            Text(String("\(archivo.fileSize / (1024 * 1024)) MB"))
                .foregroundColor(.gray)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()
            
//            Text(archivo.totalPaginas != nil ? "\(archivo.totalPaginas) pages" : "—")
//                .foregroundColor(.gray)
//                .font(.subheadline)
//                .lineLimit(1)
//                .minimumScaleFactor(0.5)

        }
    }
}
