
import SwiftUI

//struct AjustesGlobales_Previews1: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
//        let appEstadoPreview = AppEstado(screenWidth: 375, screenHeight: 667)
////        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let appEstadoPreview = AppEstado(screenWidth: 820, screenHeight: 1180) //iphone 15
//        
//        let menuEstadoPreview = MenuEstado() // Reemplaza con la inicialización adecuada
//
//        return AjustesGlobales()
//            .environmentObject(appEstadoPreview)
//            .environmentObject(menuEstadoPreview)
//    }
//}

struct Rendimiento: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    private let cpd = ConstantesPorDefecto()
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * appEstado.constantes.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * appEstado.constantes.scaleFactor} // 20
    private var altoRectanguloFondo: CGFloat {menuEstado.altoRectanguloFondo * appEstado.constantes.scaleFactor}
    
    private var paddingCorto: CGFloat { cpd.paddingCorto }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            Text("Rendimiento")
//                .font(.system(size: appEstado.constantes.titleSize, weight: .bold))
                .font(.headline)
                .padding(.vertical, paddingVertical + 5) // 25
                .padding(.trailing, paddingHorizontal)
            
            Text("Ajustes para mejorar el rendimiento del programa sacrificando el aspecto visual.")
//                .font(.system(size: appEstado.constantes.subTitleSize))
                .font(.subheadline)
                .foregroundColor(appEstado.temaActual.secondaryText)
                .frame(width: .infinity)
                .padding(.bottom, paddingVertical) // 20
            
            VStack(spacing: 0) {
                HStack {
                    CirculoActivo(isSection: isSection)
                    
                    Text("Modifica las sombras")
//                        .font(.system(size: appEstado.constantes.subTitleSize))
                        .font(.caption2)
                        .foregroundColor(appEstado.temaActual.secondaryText)
                        .frame(alignment: .leading)
                    
                    Spacer()
                }
                .padding(.bottom, paddingCorto)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.2))
                        .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
                    
                    
                    VStack(spacing: 0) {
                        
                        TogglePersonalizado(titulo: "Sombras", descripcion: "Activa o desactiva las sombras de la interfaz.", opcionBinding: $appEstado.shadows, opcionTrue: "Deshabilitar sombras", opcionFalse: "Habilitar sombras", isInsideToggle: true, isDivider: true)
                        
                        Text("Las sombras pueden afectar al rendimiento del programa, ralentizando la experiencia del usuario. El clásico dilema entre estilo y rendimiento.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 10)
                        
                    }
                    .padding()
                }
                .padding(.bottom, paddingVertical)
                
            }
            
        }
        .padding(.horizontal, appEstado.resolucionLogica == .small ? 0 : paddingHorizontal * 2)
        
    }
}

