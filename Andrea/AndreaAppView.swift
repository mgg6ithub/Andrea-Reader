
import SwiftUI

//MARK: - --- PREVIEW ---
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
//        return AndreaAppView()
//            .environmentObject(ap)
//            .environmentObject(me)
//            .environmentObject(pc)
//    }
//}

extension PilaColecciones {
    static var preview: PilaColecciones {
        let pila = PilaColecciones(preview: true)
        let homeURL: URL = SistemaArchivosUtilidades.sau.home

        pila.colecciones = [
            ModeloColeccion.mock("HOME", url: homeURL),
            ModeloColeccion.mock("Coleccion1", url: homeURL.appendingPathComponent("Coleccion1")),
            ModeloColeccion.mock("Coleccion2", url: homeURL.appendingPathComponent("Coleccion2")),
            ModeloColeccion.mock("Coleccion3", url: homeURL.appendingPathComponent("Coleccion3"))
        ]

        pila.coleccionActualVM = pila.colecciones.last
        return pila
    }
}

extension ModeloColeccion {
    static func mock(_ nombre: String, url: URL) -> ModeloColeccion {
        ModeloColeccion(
            Coleccion(directoryName: nombre, directoryURL: url, fechaImportacion: Date(), fechaModificacion: Date(), favorito: true, protegido: true)
        )
    }
}

//MARK: - --- PREVIEW ---

struct AndreaAppView: View {
//    
//    @StateObject private var ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//    @StateObject private var ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//    @StateObject private var ap = AppEstado(screenWidth: 744, screenHeight: 1133) ipad mini 6 gen
    @StateObject private var ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
//    @StateObject private var ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
//    @StateObject private var ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//    @StateObject private var ap = AppEstado()
    @StateObject private var me = MenuEstado()//Inicalizamos el sistema de archivos
    @StateObject private var pc = PilaColecciones.pilaColecciones
    @StateObject private var ne = NotificacionesEstado.ne

    @State private var sideMenuVisible: Bool = false
    
    var body: some View {
        
        ZStack {
            VistaPrincipal()
                .environmentObject(ap)
                .environmentObject(me)
                .environmentObject(pc)
                .environmentObject(ne)
            
            if sideMenuVisible {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.sideMenuVisible = false
//                        print("FUNCIONA EL TAP")
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
                        
                        //CHECKEMOS SI ES DE DERCHA A IZQUIERDA PRIMERO
                        if value.translation.width < -100 {
                            if self.sideMenuVisible {
                                self.sideMenuVisible = false
                            }
                            else {
                                if let ultimo: Archivo = ap.ultimoArchivoLeido {
                                    ap.archivoEnLectura = ultimo
                                }
                            }
                        }
                        
                        if value.translation.width > 100 {
                            self.sideMenuVisible = true
                        }
                        
                    }
                }
        )
        
    }
}

