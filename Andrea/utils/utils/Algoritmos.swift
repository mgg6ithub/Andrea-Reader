//
//  Algoritmos.swift
//  Andrea
//
//  Created by mgg on 3/7/25.
//

import SwiftUI

struct Algoritmos {
    
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
    
}
