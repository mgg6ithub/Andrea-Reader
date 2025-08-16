import SwiftUI

struct TogglePersonalizado<T: Equatable>: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var titulo: String
    var descripcion: String? = nil
    var iconoEjemplo: String? = nil
    
    @Binding var opcionBinding: T
    var opcionSeleccionada: T? = nil // si es enum, aquí dices qué valor quieres
    var opcionTrue: String
    var opcionFalse: String
    
    var isInsideToggle: Bool
    var isDivider: Bool
    
    private var colorActivarDesactivar: Color {
        if descripcion != nil {
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
                            Image(systemName: icono)
                                .foregroundColor(ap.temaActual.colorContrario)
                        } else {
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
            
            Toggle(isOn: Binding(
                get: {
                    if let opcionSeleccionada {
                        return opcionBinding == opcionSeleccionada
                    } else if let boolValue = opcionBinding as? Bool {
                        return boolValue
                    } else {
                        return false
                    }
                },
                set: { newValue in
                    withAnimation {
                        if let opcionSeleccionada {
                            if newValue {
                                opcionBinding = opcionSeleccionada
                            }
                        } else if opcionBinding is Bool {
                            opcionBinding = (newValue as! T)
                        }
                    }
                }
            )) {
                Text(
                    ( (opcionSeleccionada != nil && opcionBinding == opcionSeleccionada) ||
                      (opcionSeleccionada == nil && (opcionBinding as? Bool) == true)
                    )
                    ? opcionTrue
                    : opcionFalse
                )
                .font(.subheadline)
                .foregroundColor(colorActivarDesactivar)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            if isDivider && isInsideToggle {
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 0.5)
                    .padding(.vertical, 10)
            }
        }
    }
}


