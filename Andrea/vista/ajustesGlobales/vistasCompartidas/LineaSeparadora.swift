//
//  LineaSeparadora.swift
//  Andrea
//
//  Created by mgg on 31/5/25.
//

import SwiftUI

struct LineaSeparadora: View {
    
    private let paddingHorizontal: CGFloat = ConstantesPorDefecto().horizontalPadding
    
    var body: some View {
        
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(height: 1.1)
            .padding(.horizontal, paddingHorizontal)
        
    }
    
}
