//
//  ArchivoProtocolo.swift
//  Andrea
//
//  Created by mgg on 3/6/25.
//

import SwiftUI

protocol ProtocoloArchivo: ElementoSistemaArchivosProtocolo {
    var fileTotalPages: Int { get set }
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
    
    var imagenArchivo: ImagenArchivo { get set }
    
//    func crearImagenArchivo(tipoArchivo: EnumTipoArchivos, miniaturaPortada: UIImage?, miniaturaContraPortada: UIImage?) -> ImagenArchivo //Se crea un modelo con dos miniaturas la de delante y atras del archivo
    func crearImagenArchivo() -> ImagenArchivo
    
    func viewContent() -> AnyView
//    func showViewContentMenu(elementModel: ElementModel) -> AnyView
    
    func getTotalPages() -> Int
    func setCurrentPage(currentPage: Int) -> Void
}
