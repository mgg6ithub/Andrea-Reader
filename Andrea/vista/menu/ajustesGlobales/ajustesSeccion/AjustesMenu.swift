
import SwiftUI

struct AjustesMenu: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    private let cpd = ConstantesPorDefecto()
    private var paddingHorizontal: CGFloat { (cpd.horizontalPadding + 20) * ap.constantes.scaleFactor}
    private var paddingVertical: CGFloat {cpd.verticalPadding * ap.constantes.scaleFactor} // 20
//    private var altoRectanguloFondo: CGFloat { ap.constantes.altoRectanguloFondo }
    
    @State var opcion1: Bool = false
    @State var opcion2: Bool = false
    @State var opcion3: Bool = false
    @State var opcion4: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.2))
                    .shadow(color: ap.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: ap.shadows ? 10 : 0, x: 0, y: ap.shadows ? 5 : 0)
                
                VStack(spacing: 0) {
                    
                    TogglePersonalizado(titulo: "Test", descripcion: "Activa o desactiva el test de la interfaz.", opcionBinding: $ap.shadows, opcionTrue: "Deshabilitar test", opcionFalse: "Habilitar test", isInsideToggle: true, isDivider: true)
                    
                    Text("Las sombras pueden afectar al rendimiento del programa, ralentizando la experiencia del usuario. El clásico dilema entre estilo y rendimiento.")
                        .font(.subheadline)
                        .foregroundColor(ap.temaActual.secondaryText)
                        .padding(.top, 10)
                    
                    if ap.shadows {
                        VStack(spacing: 0) {
                            
//                            withAnimation(.easeInOut(duration: 0.3)) {
                                Toggle(isOn: $opcion1) {
                                    Text( opcion1 ? "activado" : "desactivado")
                                        .font(.subheadline)
                                        .foregroundColor(ap.temaActual.colorContrario)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                            
                            Text("Descripción del toggle corta.")
                                .font(.caption2)
                                .foregroundColor(ap.temaActual.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)

//                            }
                            
                            Divider()
                            
//                            withAnimation(.easeInOut(duration: 0.3)) {
                                Toggle(isOn: $opcion2) {
                                    Text( opcion2 ? "activado" : "desactivado")
                                        .font(.subheadline)
                                        .foregroundColor(ap.temaActual.colorContrario)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                                .padding(.bottom, 10)
//                            }
                            Divider()
//                            withAnimation(.easeInOut(duration: 0.3)) {
                                Toggle(isOn: $opcion3) {
                                    Text( opcion3 ? "activado" : "desactivado")
                                        .font(.subheadline)
                                        .foregroundColor(ap.temaActual.colorContrario)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                                .padding(.bottom, 10)
//                            }
                            Divider()
//                            withAnimation(.easeInOut(duration: 0.3)) {
                                Toggle(isOn: $opcion4) {
                                    Text( opcion4 ? "activado" : "desactivado")
                                        .font(.subheadline)
                                        .foregroundColor(ap.temaActual.colorContrario)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                                .padding(.bottom, 10)
//                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
//                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.4), value: ap.shadows)
                    }
                    
                }
                .padding()
            }
            .padding(.vertical, paddingVertical)
        }
        .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
    }
}
