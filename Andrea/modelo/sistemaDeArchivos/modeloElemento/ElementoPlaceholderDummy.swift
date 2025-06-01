//
//  ElementoPlaceholderDummy.swift
//  Andrea
//
//  Created by mgg on 1/6/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ElementoPlaceholder: ElementoSistemaArchivosProtocolo {
    
    var id: UUID = UUID()
    var name: String = "Cargando..."
    var description: String? = nil
    var url: URL = URL(fileURLWithPath: "/placeholder")
    
    var relativeURL: String {
        return url.lastPathComponent
    }
    
    var creationDate: Date = Date()
    var modificationDate: Date = Date()
    var firstTimeAccessedDate: Date? = nil
    var lastAccessDate: Date? = nil
    
    func getConcreteInstance() -> Self {
        return self
    }
    
    // MARK: - Transferable
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.name)
    }
}

