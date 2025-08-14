
import SwiftUI

struct TogglePersonalizado: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var titulo: String
    var descripcion: String
    
    @Binding var opcionBinding: Bool
    
    var opcionTrue: String
    var opcionFalse: String
    
    var isInsideToggle: Bool
    var isDivider: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(titulo)
                .font(.headline)
                .foregroundColor(ap.temaActual.colorContrario)
            
            Text(descripcion)
                .font(.subheadline)
                .foregroundColor(ap.temaActual.secondaryText)
            
            if isInsideToggle {
                Toggle(isOn: Binding(
                    get: { self.opcionBinding },
                    set: { newValue in
                        withAnimation {
                            self.opcionBinding = newValue
                        }
                    }
                )) {
                    Text(opcionBinding ? opcionTrue : opcionFalse)
                        .font(.subheadline)
                        .foregroundColor(ap.temaActual.colorContrario)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))

            } else {
                Toggle(isOn: $opcionBinding) {
                    Text( opcionBinding ? opcionTrue : opcionFalse)
                        .font(.subheadline)
                        .foregroundColor(ap.temaActual.colorContrario)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            if isDivider && isInsideToggle {
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 0.5)
                    .padding(.vertical, 10)
            }
            
        }
        
    }
    
}
