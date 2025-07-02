//
//  PersistenciaDatos.swift
//  Andrea
//
//  Created by mgg on 2/7/25.
//

import SwiftUI

struct PersistenciaDatos {
    
    //MARK:  --- COLECCION ---
    
    public func guardarPosicionScroll(coleccion: Coleccion) {
        let key = ManipulacionCadenas().borrarURLLOCAL(url: coleccion.url)
        UserDefaults.standard.set(coleccion.scrollPosition, forKey: key)
    }

    public func obtenerPosicionScroll(coleccion: Coleccion) -> Int {
        let key = ManipulacionCadenas().borrarURLLOCAL(url: coleccion.url)
        return UserDefaults.standard.integer(forKey: key)
    }

    
}
