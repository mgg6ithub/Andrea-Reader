//
//  Algoritmos.swift
//  Andrea
//
//  Created by mgg on 3/7/25.
//

import SwiftUI

struct Algoritmos {
    
    //MARK: --- ALGORITMO DE GENERACION DE INDICES DESDE EL CENTRO HACIA LOS LADOS ---
    
    func generarIndicesDesdeCentro(_ centro: Int, total: Int) -> [Int] {
        var indices: [Int] = []
        var offset = 0

        while indices.count < total {
            let forward = centro + offset
            if forward < total {
                indices.append(forward)
            }

            if offset != 0 {
                let backward = centro - offset
                if backward >= 0 {
                    indices.append(backward)
                }
            }

            offset += 1
        }

        return indices
    }
    
    //MARK: --- ALGORITMO DE ORDENACION ---
    
    func ordenarElementos(_ elementos: [ElementoSistemaArchivos], por tipoOrden: EnumOrdenaciones, esInvertido: Bool) -> [ElementoSistemaArchivos] {
        
        var tempElementos: [ElementoSistemaArchivos] = []
        
        switch tipoOrden {
        case .nombre:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                a.name.localizedStandardCompare(b.name) == .orderedAscending
            }
        case .aleatorio:
            tempElementos = elementos.shuffled()
        case .tamano:
            tempElementos = elementos.sorted {
                guard let a = $0 as? Archivo, let b = $1 as? Archivo else {
                    return false
                }
                return a.fileSize > b.fileSize
            }

//        case .paginas:
//            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
//                (a.totalPaginas ?? 0) < (b.totalPaginas ?? 0)
//            }
//        case .porcentaje:
//            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
//                (a.porcentajeLeido ?? 0) < (b.porcentajeLeido ?? 0)
//            }
        case .fechaImportacion:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                (a.creationDate ) < (b.creationDate )
            }
        case .fechaModificacion:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                (a.modificationDate ) < (b.modificationDate )
            }
        case .personalizado:
            tempElementos = elementos
        default:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                a.name.localizedStandardCompare(b.name) == .orderedAscending
            }
        }
        
        if esInvertido {
            return tempElementos.reversed()
        } else {
            return tempElementos
        }
        
    }
    
    
    
}
