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
    
    func ordenarElementos(_ elementos: [ElementoSistemaArchivos], por tipoOrden: EnumOrdenaciones, esInvertido: Bool, coleccionURL: URL? = nil) -> [ElementoSistemaArchivos] {
        
        var tempElementos: [ElementoSistemaArchivos] = []
        
        switch tipoOrden {
        case .personalizado:
            
            print("Ordenaiento personalizado")
            
            guard let coleccionURL = coleccionURL else { return [] }
            
            guard let ordenDict = PersistenciaDatos().obtenerAtributoConcreto(url: coleccionURL, atributo: "ordenPersonalizado") as? [String: Int] else {
                    return []
                }
                
            tempElementos = elementos.sorted { (a, b) -> Bool in
                let posA = ordenDict[a.url.absoluteString] ?? Int.max
                let posB = ordenDict[b.url.absoluteString] ?? Int.max
                return posA < posB
            }

            
        case .nombre:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                a.nombre.localizedStandardCompare(b.nombre) == .orderedAscending
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

        case .paginas:
            tempElementos = elementos.sorted {
                guard let a = $0 as? Archivo, let b = $1 as? Archivo else {
                    return false
                }
                let pagA = a.totalPaginas ?? -1
                let pagB = b.totalPaginas ?? -1
                return pagA > pagB
            }

        case .porcentaje:
            tempElementos = elementos.sorted {
                guard let a = $0 as? Archivo, let b = $1 as? Archivo else {
                    return false
                }
                return a.progreso > b.progreso
            }
            
        case .fechaImportacion:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                (a.fechaImportacion ) < (b.fechaImportacion )
            }
            
        case .fechaModificacion:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                (a.fechaModificacion ) < (b.fechaModificacion )
            }
            
        case .personalizado:
            tempElementos = elementos
            
        default:
            tempElementos = elementos.sorted { (a: ElementoSistemaArchivos, b: ElementoSistemaArchivos) in
                a.nombre.localizedStandardCompare(b.nombre) == .orderedAscending
            }
        }
        
        if esInvertido {
            return tempElementos.reversed()
        } else {
            return tempElementos
        }
        
    }
    
    
}
