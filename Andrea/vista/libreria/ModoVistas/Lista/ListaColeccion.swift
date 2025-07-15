//
//  ListaColeccion.swift
//  Andrea
//
//  Created by mgg on 15/7/25.
//

import SwiftUI

struct ListaColeccion: View {
    
    let coleccion: Coleccion
    
    var body: some View {
        HStack {
            
            Image(systemName: "folder")
            
            Text(coleccion.name)
            
        }
    }
}
