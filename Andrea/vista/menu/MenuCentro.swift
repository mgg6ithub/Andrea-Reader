import SwiftUI

struct BotonMenu<T: Equatable>: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let nombre: String
    let icono: String
    let valor: T
    let color: Color
    let valorActual: T
    let accion: () -> Void

    var isActive: Bool {
        valor == valorActual
    }

    var body: some View {
        Button(action: accion) {
            Label(nombre, systemImage: icono)
                .foregroundStyle(
                    isActive ? color : ap.temaActual.textColor,
                    isActive ? ap.temaActual.textColor : ap.temaActual.textColor,
                    ap.temaActual.textColor
                )
        }
    }
}


struct MenuCentro: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    private let sa: SistemaArchivos = SistemaArchivos.sa
    
    private var coleccionActualVM: ModeloColeccion {
        pc.getColeccionActual()
    }
    
    @State private var menuRefreshTrigger = UUID()
    
    @State private var mostrarDocumentPicker: Bool = false
    @State private var esNuevaColeccionPresionado: Bool = false
    @State private var nuevaColeccionNombre: String = ""

    var body: some View {
        
        HStack {
            
            Button(action: {
                withAnimation { menuEstado.seleccionMultiplePresionada = true }
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
                    sa.crearColeccion(nombre: nuevaColeccionNombre, en: coleccionActualVM.coleccion.url)
                    nuevaColeccionNombre = ""
                }
                Button("Cancelar", role: .cancel) {}
            }
            
            Menu {
                
                Label(coleccionActualVM.coleccion.nombre, systemImage: "folder")
                
                Section(header: Text("Vista")) {
                    BotonMenu(
                        nombre: "Cuadrícula",
                        icono: "square.grid.2x2",
                        valor: .cuadricula,
                        color: coleccionActualVM.color,
                        valorActual: coleccionActualVM.modoVista
                    ) {
                        coleccionActualVM.cambiarModoVista(modoVista: .cuadricula)
                        menuRefreshTrigger = UUID()
                    }

                    BotonMenu(
                        nombre: "Lista",
                        icono: "list.bullet",
                        valor: .lista,
                        color: coleccionActualVM.color,
                        valorActual: coleccionActualVM.modoVista
                    ) {
                        coleccionActualVM.cambiarModoVista(modoVista: .lista)
                        menuRefreshTrigger = UUID()
                    }
                }
                
                Section(header: Text("Ordenar")) {
                    BotonMenu(
                        nombre: "Aleatorio",
                        icono: "shuffle",
                        valor: .aleatorio,
                        color: coleccionActualVM.color,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .aleatorio)
                        menuRefreshTrigger = UUID()
                    }
                    
                    BotonMenu(
                        nombre: "Personalizada",
                        icono: "hand.draw.fill",
                        valor: .personalizado,
                        color: coleccionActualVM.color,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        
                    }
                    
                    BotonMenu(
                        nombre: "Nombre",
                        icono: "textformat.characters.arrow.left.and.right",
                        valor: .nombre,
                        color: coleccionActualVM.color,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .nombre)
                        menuRefreshTrigger = UUID()
                    }
                    
                    BotonMenu(
                        nombre: "Tamaño",
                        icono: "arrow.left.and.right.text.vertical",
                        valor: .tamano,
                        color: coleccionActualVM.color,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .tamano)
                        menuRefreshTrigger = UUID()
                    }
                    
                    BotonMenu(
                        nombre: "Paginas",
                        icono: "book.pages",
                        valor: .paginas,
                        color: coleccionActualVM.color,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        
                    }
                }
                
                Section(header: Text("Invertir Ordenacion")) {
                    Button(action: {
                        coleccionActualVM.invertir()
                        menuRefreshTrigger = UUID()
                    }) {
                        HStack {
                            
                            if coleccionActualVM.esInvertido {
                                Text("Menor a mayor")
                                Image(systemName: "text.insert")
                                    .foregroundColor(appEstado.temaActual.textColor)
                                    .padding()
                            }
                            else {
                                Text("Mayor a menor")
                                Image(systemName: "text.append")
                                    .foregroundColor(appEstado.temaActual.textColor)
                                    .padding()
                            }
                        }
                    }
                }
                
                
                Section(header: Text("Renombra y ordena a la vez")) {
                    Button(action: {
                        coleccionActualVM.smartSorting()
                    }) {
                        Label("Smart rename", systemImage: "brain")
                    }
                }
                
            } label: {
                Image(systemName: "square.grid.3x3.square")
                    .font(.system(size: appEstado.constantes.iconSize * 1.2))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(appEstado.constantes.iconColor.gradient)
                    .contentTransition(.symbolEffect(.replace))
                    .fontWeight(appEstado.constantes.iconWeight)
                    .contentShape(Rectangle())
            }
            .id(menuRefreshTrigger)
            .colorScheme(appEstado.temaActual == .dark ? .dark : .light)
            
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
            }
        }
        .id(coleccionActualVM.coleccion.id)

    }
}

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
//        let appStatePreview = AppEstado()   // Reemplaza con inicialización adecuada
////        let appEstadoPreview = AppEstado() // Reemplaza con inicialización adecuada
////        let appEstadoPreview = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
//        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
////        let appEstadoPreview = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad 9,8,7
////        let appEstadoPreview = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let appEstadoPreview = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let appEstadoPreview = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let menuEstadoPreview = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.pilaColecciones
//
//        return AndreaAppView()
//            .environmentObject(appStatePreview)
//            .environmentObject(appEstadoPreview)
//            .environmentObject(menuEstadoPreview)
//            .environmentObject(pc)
//    }
//}

