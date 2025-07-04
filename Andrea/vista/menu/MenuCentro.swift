import SwiftUI

struct MenuCentro: View {
    
    @EnvironmentObject var appEstado: AppEstado1
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var sa: SistemaArchivos
    
    @State private var mostrarDocumentPicker: Bool = false
    @State private var esNuevaColeccionPresionado: Bool = false
    @State private var nuevaColeccionNombre: String = ""

    var body: some View {
        
        HStack {
            
            Button(action: {
                //ACTION
            }) {
                Image("custom.hand.grid")
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .contentTransition(.symbolEffect(.replace))
                    .fontWeight(appEstado.constantes.iconWeight)
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
            
            Button(action: {
                //ACTION
            }) {
                Image(systemName: "square.grid.3x3.square")
                    .font(.system(size: appEstado.constantes.iconSize * 1.3))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .fontWeight(appEstado.constantes.iconWeight)
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
                    .background(appEstado.temaActual.backgroundColor)
            }
            
        }
    }
}

