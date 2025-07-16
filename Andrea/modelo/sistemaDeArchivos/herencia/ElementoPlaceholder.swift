//
//  ElementoPlaceholderDummy.swift
//  Andrea
//
//  Created by mgg on 1/6/25.
//

import SwiftUI
import UniformTypeIdentifiers

class ElementoPlaceholder: ElementoSistemaArchivos {
    
    override init() {
        super.init()
        self.name = "Cargando..."
        self.url = URL(fileURLWithPath: "/placeholder")
        // Puedes ajustar creationDate/modificationDate si hace falta
    }

    // Si necesitas una representación Transferable igual que antes:
//    override class var transferRepresentation: some TransferRepresentation {
//        ProxyRepresentation(exporting: \.name)
//    }
}

