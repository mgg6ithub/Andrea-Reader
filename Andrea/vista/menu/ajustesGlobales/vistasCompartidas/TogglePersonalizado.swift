
import SwiftUI

//struct AjustesGlobales_Previews: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
//        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let appEstadoPreview = AppEstado(screenWidth: 820, screenHeight: 1180) //iphone 15
//        
//        let menuEstadoPreview = MenuEstado() // Reemplaza con la inicialización adecuada
//
//        return AjustesGlobales()
//            .environmentObject(appEstadoPreview)
//            .environmentObject(menuEstadoPreview)
//    }
//}

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
                        .foregroundColor(.primary)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding(.bottom, 10)

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
