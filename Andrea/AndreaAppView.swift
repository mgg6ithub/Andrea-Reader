
import SwiftUI

struct AndreaAppView: View {
    
//    @StateObject private var ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//    @StateObject private var ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//    @StateObject private var ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
    @StateObject private var ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
//    @StateObject private var ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
//    @StateObject private var ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//    @StateObject private var ap = AppEstado()
    @StateObject private var me = MenuEstado()//Inicalizamos el sistema de archivos
    @StateObject private var pc = PilaColecciones.preview

    @State private var sideMenuVisible: Bool = false
    
    var body: some View {
        
        ZStack {
            VistaPrincipal()
                .environmentObject(ap)
                .environmentObject(me)
                .environmentObject(pc)
            
            if sideMenuVisible {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.sideMenuVisible = false
                    }
                
                HStack {
                    SideMenu()
                        .frame(width: 300)
                        .offset(x: sideMenuVisible ? 0 : -300)
                        .animation(.spring(), value: sideMenuVisible)
                    
                    Spacer()
                }
                
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        if value.translation.width > 100 {
                            self.sideMenuVisible = true
                        }
                    }
                }
        )
        
    }
    
}

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
//        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
////        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
////        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let me = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.preview
//        
//
//        return AndreaAppView()
//            .environmentObject(ap)
//            .environmentObject(me)
//            .environmentObject(pc)
//    }
//}

extension PilaColecciones {
    static var preview: PilaColecciones {
        let pila = PilaColecciones(preview: true)
        pila.colecciones = [
            ModeloColeccion.mock("Colección 1"),
            ModeloColeccion.mock("Colección 2")
        ]
        pila.coleccionActualVM = pila.colecciones.first
        return pila
    }
}

extension ModeloColeccion {
    static func mock(_ nombre: String) -> ModeloColeccion {
        ModeloColeccion(
            Coleccion(directoryName: nombre, directoryURL: URL(fileURLWithPath: ""), creationDate: Date(), modificationDate: Date(), favorito: true, protegido: true)
        )
    }
}


