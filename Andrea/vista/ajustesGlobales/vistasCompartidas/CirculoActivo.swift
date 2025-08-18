
import SwiftUI

struct CirculoActivo: View {
    
    @EnvironmentObject var appEstado: AppEstado

    var isSection: Bool
    let color: Color
    
    var body: some View {
        
        Circle()
            .fill(isSection ? color : Color.clear)
            .shadow(
                color: isSection ? color : Color.clear,
                radius: 6
            )
            .frame(width: 8, height: 8)
        
    }
    
}
