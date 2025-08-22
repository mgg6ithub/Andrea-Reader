
import SwiftUI

////MARK: - --- PREVIEW ---
struct AndreaAppView_Preview: PreviewProvider {
    static var previews: some View {
        // Instancias de ejemplo para los objetos de entorno
        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
//        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
//        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
//        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
        let me = MenuEstado() // Reemplaza con inicialización adecuada
        let pc = PilaColecciones.preview

        return AndreaAppView()
            .environmentObject(ap)
            .environmentObject(me)
            .environmentObject(pc)
    }
}

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

extension View {
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition { transform(self) } else { self }
    }
}


private struct TopInsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}


//MARK: - --- PREVIEW ---

struct AndreaAppView: View {
    @Environment(\.colorScheme) private var systemScheme
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
    
    var body: some View {
        let temaResuelto = ap.temaActual.resolved(for: systemScheme)
        ZStack {
            temaResuelto.backgroundGradient.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                VistaPrincipal()
                    .environmentObject(ap)
                    .environmentObject(me)
                    .environmentObject(pc)
                    .environmentObject(ne)
            }
            
            if ap.sideMenuVisible {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        ap.sideMenuVisible = false
                    }
                
                HStack {
                    SideMenu()
                        .frame(width: 300)
                        .offset(x: ap.sideMenuVisible ? 0 : -300)
                        .animation(.spring(), value: ap.sideMenuVisible)
                    
                    Spacer()
                }
                
            }
        }
        .onChange(of: ap.temaActual) {
            ap.temaResuelto = ap.temaActual.resolved(for: systemScheme)
        }
        .onChange(of: systemScheme) {
            ap.temaResuelto = ap.temaActual.resolved(for: systemScheme)
        }
        .onAppear {
            ap.temaResuelto = ap.temaActual.resolved(for: systemScheme)
        }
        // 3) Ignora el safe area superior del sistema: el hueco lo controlas tú
        .ignoresSafeArea(.container, edges: .top)

        // 4) Capta el top inset real cuando la barra esté visible y guárdalo
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: TopInsetKey.self, value: geo.safeAreaInsets.top)
            }
        )
        .onPreferenceChange(TopInsetKey.self) { top in
            // Sólo actualiza cuando la barra está visible (para no meter 0)
            if !me.barraEstado, top > 0 {
                me.statusBarTopInsetBaseline = top
            }
        }
        .statusBar(hidden: me.barraEstado)
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        
                        //CHECKEMOS SI ES DE DERCHA A IZQUIERDA PRIMERO
                        if value.translation.width < -100 {
                            if ap.sideMenuVisible {
                                ap.sideMenuVisible = false
                            }
                            else {
                                if let ultimo: Archivo = ap.ultimoArchivoLeido {
                                    ap.archivoEnLectura = ultimo
                                }
                            }
                        }
                        
                        if value.translation.width > 100 {
                            ap.sideMenuVisible = true
                        }
                        
                    }
                }
        )
        
    }
}

