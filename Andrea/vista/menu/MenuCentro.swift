import SwiftUI

struct BotonMenu: View {
    
    let nombre: String
    let icono: String
    let isActive: Bool
    let accion: () -> Void

    
    var body: some View {
        
        Button(action: accion) {
            Label(nombre, systemImage: icono)
                .foregroundColor(isActive ? .primary : .secondary)
        }
        
    }
    
}

struct MenuCentro: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    private let sa: SistemaArchivos = SistemaArchivos.getSistemaArchivosSingleton
    
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
                        isActive: menuEstado.modoVistaColeccion == .cuadricula
                    ) {
                        let vm = PilaColecciones.getPilaColeccionesSingleton.getColeccionActual()
                        let coleccion = vm.coleccion
                        print("📦 Modificando modoVista para VM: \(coleccion.name) a cuadricula")
                        vm.modoVista = .cuadricula
                        PersistenciaDatos().guardarAtributo(coleccion: coleccion, atributo: "tipoVista", valor: EnumModoVista.cuadricula)
                    }

                    BotonMenu(
                        nombre: "Lista",
                        icono: "list.bullet",
                        isActive: menuEstado.modoVistaColeccion == .lista
                    ) {
                        let vm = PilaColecciones.getPilaColeccionesSingleton.getColeccionActual()
                        let coleccion = vm.coleccion
                        print("📦 Modificando modoVista para VM: \(coleccion.name) a lista")
                        vm.modoVista = .lista
                        PersistenciaDatos().guardarAtributo(coleccion: coleccion, atributo: "tipoVista", valor: EnumModoVista.lista)
                        
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

