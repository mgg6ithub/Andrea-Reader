
import SwiftUI

struct TogglePersonalizado: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var titulo: String
    var descripcion: String? = nil
    var iconoEjemplo: String? = nil
    
    @Binding var opcionBinding: Bool
    
    var opcionTrue: String
    var opcionFalse: String
    
    var isInsideToggle: Bool
    var isDivider: Bool
    
    private var colorActivarDesactivar: Color {
        if let _ = descripcion {
            return ap.temaActual.colorContrario
        } else {
            return ap.temaActual.secondaryText
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                if let icono = iconoEjemplo {
                    Group {
                        if UIImage(systemName: icono) != nil {
                            // Es un SF Symbol
                            Image(systemName: icono)
                        } else {
                            // Es una imagen personalizada de tus assets
                            Image(icono)
                                .if(titulo == "Seleccion multiple") { v in
                                    v.font(.system(size: ap.constantes.iconSize))
                                }
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.gray, ap.temaActual.colorContrario)
                        }
                    }
                    .frame(width: 30, height: 30)
                }
                
                Text(titulo)
                    .font(.headline)
                    .foregroundColor(ap.temaActual.colorContrario)
            }
            
            if let descripcion = descripcion {
                Text(descripcion)
                    .font(.subheadline)
                    .foregroundColor(ap.temaActual.secondaryText)
            }
            
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
                        .foregroundColor(colorActivarDesactivar)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))

            } else {
                Toggle(isOn: $opcionBinding) {
                    Text( opcionBinding ? opcionTrue : opcionFalse)
                        .font(.subheadline)
                        .foregroundColor(colorActivarDesactivar)
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

