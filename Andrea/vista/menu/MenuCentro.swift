import SwiftUI

struct BotonMenu: View {
    
    let nombre: String
    let icono: String
    let isActive: Bool
    let accion: () -> Void

    
    var body: some View {
        
        Button(action: accion) {
            Label(nombre, systemImage: isActive ? "checkmark" : icono)
                .foregroundStyle(
                    isActive ? .green : .gray,
                    isActive ? .primary : .secondary,
                    .secondary
                )

        }
        
    }
    
}

struct MenuCentro: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    private let sa: SistemaArchivos = SistemaArchivos.sa
    
    private var modoVistaActual: EnumModoVista {
        PilaColecciones.pilaColecciones.getColeccionActual().modoVista
    }
    
    @State private var menuRefreshTrigger = UUID() // <-- Añadido
    
    @State private var mostrarDocumentPicker: Bool = false
    @State private var esNuevaColeccionPresionado: Bool = false
    @State private var nuevaColeccionNombre: String = ""
    
    @State private var sheetID = UUID()

    var body: some View {
        
        HStack {
            
            Button(action: {
                
            }) {
                Image("custom.hand.grid")
                    .font(.system(size: appEstado.constantes.iconSize * 1.35))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.black, appEstado.constantes.iconColor.gradient)
                    .contentTransition(.symbolEffect(.replace))
                    .fontWeight(appEstado.constantes.iconWeight)
                    .contentShape(Rectangle())
            }
            .offset(y: 0.6)
            
            //MARK: - IMPORTAR
            
            Button(action: {
                self.mostrarDocumentPicker.toggle()
            }) {
                Image(systemName: "tray.and.arrow.down")
                    .font(.system(size: appEstado.constantes.iconSize * 1.05))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .fontWeight(appEstado.constantes.iconWeight)
            }
            .sheet(isPresented: $mostrarDocumentPicker) {
                DocumentPicker(
                    onPick: { urls in
                        print("Seleccionado: \(urls)")
                        for url in urls {
                            sa.crearArchivo(archivoURL: url, coleccionDestino: PilaColecciones.pilaColecciones.getColeccionActual().coleccion.url)
                        }
                    },
                    onCancel: {
                        print("Cancelado")
                    },
                    allowMultipleSelection: true,
                    contentTypes: [.item]
                )
            }
            .offset(y: -2)
            
            //MARK: - CREAR COLECCION
            
            Button(action: {
                self.esNuevaColeccionPresionado.toggle()
            }) {
                Image(systemName: "folder.badge.plus")
                    .font(.system(size: appEstado.constantes.iconSize * 1.05))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .fontWeight(appEstado.constantes.iconWeight)
            }
            .alert("Crear una nueva colección:", isPresented: $esNuevaColeccionPresionado) {
                TextField("Nombre de colección", text: $nuevaColeccionNombre)
                Button("Aceptar") {
                    sa.crearColeccion(nombre: nuevaColeccionNombre, en: PilaColecciones.pilaColecciones.getColeccionActual().coleccion.url)
                }
                Button("Cancelar", role: .cancel) {}
            }
            
            Menu {
                
                Section(header: Text("Modos de vista")) {
                    
                    BotonMenu(
                        nombre: "Cuadrícula",
                        icono: "square.grid.2x2",
                        isActive: self.modoVistaActual == .cuadricula
                    ) {
                        let vm = PilaColecciones.pilaColecciones.getColeccionActual()
                        let coleccion = vm.coleccion
                        print("📦 Modificando modoVista para VM: \(coleccion.name) a cuadricula")
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { vm.modoVista = .cuadricula }
                        
                        PersistenciaDatos().guardarAtributo(coleccion: coleccion, atributo: "tipoVista", valor: EnumModoVista.cuadricula)
                        menuRefreshTrigger = UUID()
                    }

                    BotonMenu(
                        nombre: "Lista",
                        icono: "list.bullet",
                        isActive: self.modoVistaActual == .lista
                    ) {
                        let vm = PilaColecciones.pilaColecciones.getColeccionActual()
                        let coleccion = vm.coleccion
                        print("📦 Modificando modoVista para VM: \(coleccion.name) a lista")
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { vm.modoVista = .lista }
                        
                        PersistenciaDatos().guardarAtributo(coleccion: coleccion, atributo: "tipoVista", valor: EnumModoVista.lista)
                        menuRefreshTrigger = UUID()
                    }
                    
                }
            } label: {
                
//                Image("custom.hand.grid")
                Image(systemName: "square.grid.3x3.square")
                    .font(.system(size: appEstado.constantes.iconSize * 1.2))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .contentTransition(.symbolEffect(.replace))
                    .fontWeight(appEstado.constantes.iconWeight)
//                    .padding(12)                      // zona de toque ≥ 44×44
                    .contentShape(Rectangle())
                
            }
            .id(menuRefreshTrigger)
            
            Button(action: {
                self.menuEstado.isGlobalSettingsPressed.toggle()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: appEstado.constantes.iconSize * 1.125))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .fontWeight(appEstado.constantes.iconWeight)
            }
            .sheet(isPresented: $menuEstado.isGlobalSettingsPressed) {
              AjustesGlobales()
//                    .preferredColorScheme(appEstado.temaActual == .dark ? .dark : .light)
            }

            
        }
    }
}

struct AndreaAppView_Preview: PreviewProvider {
    static var previews: some View {
        // Instancias de ejemplo para los objetos de entorno
        let appStatePreview = AppEstado()   // Reemplaza con inicialización adecuada
//        let appEstadoPreview = AppEstado() // Reemplaza con inicialización adecuada
//        let appEstadoPreview = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//        let appEstadoPreview = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
//        let appEstadoPreview = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
//        let appEstadoPreview = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
//        let appEstadoPreview = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
        let menuEstadoPreview = MenuEstado() // Reemplaza con inicialización adecuada
        let pc = PilaColecciones.pilaColecciones

        return AndreaAppView()
            .environmentObject(appStatePreview)
            .environmentObject(appEstadoPreview)
            .environmentObject(menuEstadoPreview)
            .environmentObject(pc)
    }
}

