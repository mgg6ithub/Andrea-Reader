

import SwiftUI

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
////        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
////        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
//        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let me = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.preview
//
//        return AndreaAppView()
//            .environmentObject(ap)
//            .environmentObject(me)
//            .environmentObject(pc)
//    }
//}

struct MenuSeleccionMultipleArriba: View {
    
    @EnvironmentObject var me: MenuEstado
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    private let constantes = ConstantesPorDefecto()
    
    @State var isActive: Bool = true
    
    var body: some View {
        HStack(spacing: 15) {
            
            let totalElementos = vm.elementos.count
            if totalElementos > 0 {
                Text("\(totalElementos) \(totalElementos == 1 ? "elemento" : "elementos")")
                    .font(.system(size: ap.constantes.titleSize))
                    .minimumScaleFactor(0.7)
            } else {
                Text("El estante está listo, falta el primer libro.")
                    .font(.system(size: ap.constantes.subTitleSize))
                    .minimumScaleFactor(0.7)
            }
            
            let totalSeleccioandos = me.elementosSeleccionados.count
            if !me.elementosSeleccionados.isEmpty {
                HStack(spacing: 3.5) {
//                    withAnimation(.easeOut(duration: 0.3)) {
                        Text("\(totalSeleccioandos)")
//                    }
                    Text("\(totalSeleccioandos == 1 ? "seleccionado" : "seleccionados")")
                }
            }
            
            Spacer()
            
            Button(action: {
                if !me.todosSeleccionados {
                    me.seleccionarTodos()
                } else {
                    me.deseleccionarTodos()
                }
            }) {
                Text(me.todosSeleccionados ? "Deseleccionar todos" : "Seleccionar todos")
                    .font(.system(size: ap.constantes.subTitleSize))
            }
            
            Button(action: {
                withAnimation { me.seleccionMultiplePresionada = false }
            }) {
                Text("Cancelar")
                    .font(.system(size: ap.constantes.subTitleSize))
                
                Image(systemName: "xmark.square.fill")
                    .font(.system(size: 25))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(ap.temaActual.colorContrario, Color.red)
            }
            .padding(.horizontal, ConstantesPorDefecto().horizontalPadding * 0.8)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            .gray.opacity(isActive ? 0.4 : 0.2),
                            .gray.opacity(isActive ? 0.2 : 0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .shadow(color: .gray.opacity(0.275), radius: isActive ? 4 : 2, x: 0, y: 2)
            )

        }
        .padding(.horizontal, constantes.horizontalPadding)
    }
}
