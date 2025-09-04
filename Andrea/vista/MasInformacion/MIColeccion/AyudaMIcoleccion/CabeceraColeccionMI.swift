
import SwiftUI


#Preview {
    pMIcoleccion2()
}
//
private struct pMIcoleccion2: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInfoCol(
            pantallaCompleta: $pantallaCompleta, vm: ModeloColeccion()
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

enum EnumSeccionColeccion: String, CaseIterable, Identifiable {
    
    case coleccion = "Colección"
    case progreso = "Progreso"
    
    var id: String { rawValue }
}


struct CabeceraColeccionMI: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @Binding var pantallaCompleta: Bool
    let escala: CGFloat
    
    @Binding var seleccionColeccion: EnumSeccionColeccion
    
    var cDinamico: Color { ap.temaResuelto.colorContrario }
    var padding: CGFloat { pantallaCompleta ? 20 : 10 }
    private let constantes = ConstantesPorDefecto()
    
    @State private var isPressed: Bool = false
    
    init(vm: ModeloColeccion, pantallaCompleta: Binding<Bool>, escala: CGFloat, seleccionColeccion: Binding<EnumSeccionColeccion>) {
        self.vm = vm
        _pantallaCompleta = pantallaCompleta
        self.escala = escala
        _seleccionColeccion = seleccionColeccion
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if pantallaCompleta {
                Button(action: {
                    isPressed = true
                    withAnimation(.easeInOut(duration: 0.25)) { ap.masInformacionColeccion = false }
                }) {
                    Image(systemName: "xmark.square.fill")
                        .font(.system(size: ap.constantes.iconSize * 1.3))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(cDinamico, Color.red)
                        .symbolEffect(.bounce, value: isPressed)
                }
                .frame(width: ap.constantes.iconSize * 1.3,
                       height: ap.constantes.iconSize * 1.3) // 👈 fuerza el tamaño al del icono
                .contentShape(Rectangle())
                .cornerRadius(4)
                
                Spacer()
            }
            
            ZStack {
                Picker("Sección", selection: $seleccionColeccion) {
                    ForEach(EnumSeccionColeccion.allCases) { seccion in
                        Text(seccion.rawValue).tag(seccion)
                    }
                }
                .pickerStyle(.segmented)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                )
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                pantallaCompleta.toggle()
            }) {
                HStack {
                                                        
                    Text(pantallaCompleta ? "Salir de Fullscreen" : "Fullscreen")
                        .font(.system(size: ap.constantes.subTitleSize * 0.9))
                        .foregroundColor(cDinamico)
                    
                    Divider()
                       .frame(width: 2, height: 20) // Ajusta la altura de la línea divisoria
                       .background(cDinamico) // Color de la línea divisoria
                       .clipShape(RoundedRectangle(cornerRadius: 40))
                    
                    Image(systemName: pantallaCompleta ? "square.resize.down" : "square.resize.up")
                        .font(.system(size: ap.constantes.iconSize * 0.9))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(cDinamico)
                        .animation(nil, value: pantallaCompleta)
                    
                }
                .padding(4 * ap.constantes.scaleFactor)
                .background(pantallaCompleta ? Color.red : Color(UIColor.systemGray3))
                .cornerRadius(4)
                
            }
        }
        .padding(.top, 5)
        .padding(.vertical, 15)
        
    }
}
