

import SwiftUI


struct AjustesSistemaColecciones: View {
    
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
            
            Text("Sistema de archivos") //TITULO
                .font(.system(size: appEstado.constantes.titleSize, weight: .bold))
                .padding(.vertical, paddingVertical + 5) // 25
                .padding(.trailing, paddingHorizontal)
            
            Text("Los temas son combinaciones de colores que se aplican globalmente a toda la interfaz. Los temas claro y oscuro son los mas usados.")
                .font(.system(size: appEstado.constantes.subTitleSize))
                .foregroundColor(appEstado.temaActual.secondaryText)
                .frame(width: .infinity, alignment: .leading)
                .padding(.bottom, paddingVertical) // 20
            
            HStack {
                
                CirculoActivo(isSection: isSection)
                
                Text("Selecciona un tipo de sa.")
                    .font(.system(size: appEstado.constantes.subTitleSize))
                    .foregroundColor(appEstado.temaActual.secondaryText)
                    .frame(alignment: .leading)
                
                Spacer()
            }
            .padding(.bottom, paddingCorto)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.2))
                    .frame(
                        height: altoRectanguloFondo
                    )
                    .shadow(color: appEstado.temaActual == .dark ? .black.opacity(0.6) : .black.opacity(0.225), radius: appEstado.shadows ? 10 : 0, x: 0, y: appEstado.shadows ? 5 : 0)
                
                HStack(spacing: 0) {
                    
                    RectangleFormView<EnumTipoSistemaArchivos>(
                        titulo: "Tradicional",
                        icono: "folder.fill",
                        coloresIcono: [Color.black],
                        opcionSeleccionada: .tradicional,
                        opcionActual: $appEstado.sistemaArchivos
                    )
                    
                    RectangleFormView<EnumTipoSistemaArchivos>(
                        titulo: "Arbol",
                        icono: "tree.fill",
                        coloresIcono: [Color.black],
                        opcionSeleccionada: .arbol,
                        opcionActual: $appEstado.sistemaArchivos
                    )
                    
                }
            } //fin zstack tema
            .padding(.bottom, paddingVertical)
            
        }
        .padding(.horizontal, appEstado.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
    }
    
}
