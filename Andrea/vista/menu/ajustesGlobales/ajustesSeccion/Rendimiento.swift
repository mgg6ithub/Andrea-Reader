
import SwiftUI

struct Rendimiento: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    // --- PARAMETROS ---
    var isSection: Bool
    
    // --- VARIABLES CALCULADAS ---
    private let cpd = ConstantesPorDefecto()
    private var const: Constantes { ap.constantes }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            Text("Rendimiento")
                .font(.headline)
                .foregroundColor(ap.temaActual.colorContrario)
                .padding(.vertical, const.padding25) // 25
                .padding(.trailing, const.padding35)
            
            Text("Ajustes para mejorar el rendimiento del programa sacrificando el aspecto visual.")
                .font(.subheadline)
                .foregroundColor(ap.temaActual.secondaryText)
                .frame(width: .infinity)
                .padding(.bottom, cpd.padding20) // 20
            
            VStack(spacing: 0) {
                HStack {
                    CirculoActivo(isSection: isSection)
                    
                    Text("Modifica las sombras")
                        .font(.caption2)
                        .foregroundColor(ap.temaActual.secondaryText)
                        .frame(alignment: .leading)
                    
                    Spacer()
                }
                .padding(.bottom, cpd.padding5)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.2))
                        .shadow(color: ap.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: ap.shadows ? 10 : 0, x: 0, y: ap.shadows ? 5 : 0)
                    
                    VStack(spacing: 0) {
                        
                        TogglePersonalizado(titulo: "Sombras", descripcion: "Activa o desactiva las sombras de la interfaz.", opcionBinding: $ap.shadows, opcionTrue: "Deshabilitar sombras", opcionFalse: "Habilitar sombras", isInsideToggle: true, isDivider: true)
                        
                        Text("Las sombras pueden afectar al rendimiento del programa, ralentizando la experiencia del usuario. El clásico dilema entre estilo y rendimiento.")
                            .font(.subheadline)
                            .foregroundColor(ap.temaActual.secondaryText)
                            .padding(.top, 10)
                        
                    }
                    .padding()
                }
                .padding(.bottom, cpd.padding20)
                
            }
            
        }
        .padding(.horizontal, ap.resolucionLogica == .small ? 0 : const.padding35 * 2)
        
    }
}

