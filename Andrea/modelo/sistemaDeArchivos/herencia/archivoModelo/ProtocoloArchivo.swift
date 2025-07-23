//
//  ArchivoProtocolo.swift
//  Andrea
//
//  Created by mgg on 3/6/25.
//

import SwiftUI

protocol ProtocoloArchivo: ElementoSistemaArchivosProtocolo {
    
    var totalPaginas: Int { get set }
    var fileType: EnumTipoArchivos { get }
    var fileSize: Int { get }
    var isProtected: Bool { get set }
    
    //POSIBLE INFORMACION EXTRAIDA DEL ARCHIVO QUE SE IMPORTE
    var fileOriginalName: String? { get set }
    var scanFormat: String? { get set }
    var fileOirinalScannedSource: String? { get set}
    var fileOriginalDate: Date? { get set }
    var colectionCurrentIssue: Int? { get set }
    var colectionTotalIssues: Int? { get set }
    
    func viewContent() -> AnyView
    
    func getTotalPages() -> Int
    func setCurrentPage(currentPage: Int) -> Void
    
    func extractPageData(named: String) -> Data?
}
