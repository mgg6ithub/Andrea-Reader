
import SwiftUI

struct TogglePersonalizado: View {
    
    var titulo: String
    var descripcion: String
    
    @Binding var opcionBinding: Bool
    
    var opcionTrue: String
    var opcionFalse: String
//    let w: CGFloat
    
    var isInsideToggle: Bool
    var isDivider: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(titulo)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(descripcion)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if isInsideToggle {
                withAnimation(.easeInOut(duration: 0.3)) {
                    Toggle(isOn: $opcionBinding) {
                        Text( opcionBinding ? opcionTrue : opcionFalse)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding(.bottom, 10)
                }
            } else {
                Toggle(isOn: $opcionBinding) {
                    Text( opcionBinding ? opcionTrue : opcionFalse)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding(.bottom, 10)
            }
            
            if isDivider && isInsideToggle {
                Divider()
            }
            
        }
        
    }
    
}
