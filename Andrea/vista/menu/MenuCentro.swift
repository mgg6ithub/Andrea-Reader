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
    
    private let sa: SistemaArchivos = SistemaArchivos.getSistemaArchivosSingleton
    
    private var modoVistaActual: EnumModoVista {
        PilaColecciones.getPilaColeccionesSingleton.getColeccionActual().modoVista
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
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .contentTransition(.symbolEffect(.replace))
                    .fontWeight(appEstado.constantes.iconWeight)
                    .padding(12)                      // zona de toque ≥ 44×44
                    .contentShape(Rectangle())
            }
            
            //MARK: - IMPORTAR
            
            Button(action: {
                self.mostrarDocumentPicker.toggle()
            }) {
                Image(systemName: "tray.and.arrow.down")
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .fontWeight(appEstado.constantes.iconWeight)
            }
            .sheet(isPresented: $mostrarDocumentPicker) {
                DocumentPicker(
                    onPick: { urls in
                        print("Seleccionado: \(urls)")
                        for url in urls {
                            sa.crearArchivo(archivoURL: url, coleccionDestino: PilaColecciones.getPilaColeccionesSingleton.getColeccionActual().coleccion.url)
                        }
                    },
                    onCancel: {
                        print("Cancelado")
                    },
                    allowMultipleSelection: true,
                    contentTypes: [.item]
                )
            }
            
            //MARK: - CREAR COLECCION
            
            Button(action: {
                self.esNuevaColeccionPresionado.toggle()
            }) {
                Image(systemName: "folder.badge.plus")
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .fontWeight(appEstado.constantes.iconWeight)
            }
            .alert("Crear una nueva colección:", isPresented: $esNuevaColeccionPresionado) {
                TextField("Nombre de colección", text: $nuevaColeccionNombre)
                Button("Aceptar") {
                    sa.crearColeccion(nombre: nuevaColeccionNombre, en: PilaColecciones.getPilaColeccionesSingleton.getColeccionActual().coleccion.url)
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
                        let vm = PilaColecciones.getPilaColeccionesSingleton.getColeccionActual()
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
                        let vm = PilaColecciones.getPilaColeccionesSingleton.getColeccionActual()
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
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .contentTransition(.symbolEffect(.replace))
                    .fontWeight(appEstado.constantes.iconWeight)
                    .padding(12)                      // zona de toque ≥ 44×44
                    .contentShape(Rectangle())
                
            }
            .id(menuRefreshTrigger)
            
            Button(action: {
                self.menuEstado.isGlobalSettingsPressed.toggle()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
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

