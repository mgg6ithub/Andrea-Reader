import SwiftUI
import TipKit

extension View {
    func capaIconos(iconSize: CGFloat, c1: Color, c2: Color, fontW: Font.Weight, ajuste: CGFloat) -> some View {
        self.font(.system(size: iconSize * ajuste))
            .symbolRenderingMode(.palette)
            .foregroundStyle(c1.gradient, c2.gradient)
            .fontWeight(fontW)
            .contentShape(Rectangle())
    }
}

struct MenuCentro: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    @EnvironmentObject var pc: PilaColecciones
    
    // --- ESTADO ---
    @State private var menuRefreshTrigger = UUID()
    @State private var mostrarDocumentPicker: Bool = false
    @State private var esNuevaColeccionPresionado: Bool = false
    @State private var nuevaColeccionNombre: String = ""
    
    // --- VARIABLES CALCULADAS ---
    private let sa: SistemaArchivos = SistemaArchivos.sa
    private var const: Constantes { appEstado.constantes }
    private var iconColor: Color { const.iconColor }
    private var coleccionActualVM: ModeloColeccion {
        pc.getColeccionActual()
    }

    var body: some View {
        
        HStack {
            //MARK: --- SELECCION MULTIPLE DE ELEMENTOS ---
            Button(action: {
                withAnimation { menuEstado.seleccionMultiplePresionada = true }
            }) {
                Image("custom.hand.grid")
                    .capaIconos(iconSize: const.iconSize, c1: iconColor, c2: iconColor, fontW: const.iconWeight, ajuste: 1.35)
                    .contentTransition(.symbolEffect(.replace))
            }
            .offset(y: 0.6)
//MARK: - --- CONSEJO SELECCION MULTIPLE DE UNA COLECCION ---
//            .popoverTip(ConsejoSeleccionMultiple())
//MARK: - --- CONSEJO SELECCION MULTIPLE DE UNA COLECCION ---
            
            //MARK: --- IMPORTAR ELEMENTOS A LA APLICACION ---
            Button(action: {
                self.mostrarDocumentPicker.toggle()
                //MARK: - --- CONSEJO IMPORTAR ELEMENTOS COLECCION VACIA ---
                if #available(iOS 17.0, *) { ConsejoImportarElementos().invalidate(reason: .actionPerformed) }
            }) {
                Image(systemName: "tray.and.arrow.down")
                    .capaIconos(iconSize: const.iconSize, c1: iconColor, c2: iconColor, fontW: const.iconWeight, ajuste: 1.05)
            }
//MARK: - --- CONSEJO IMPORTAR ELEMENTOS COLECCION VACIA ---
            .popoverTip(ConsejoImportarElementos())
//MARK: - --- CONSEJO IMPORTAR ELEMENTOS COLECCION VACIA ---
            .sheet(isPresented: $mostrarDocumentPicker) {
                DocumentPicker(
                    onPick: { urls in
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
            
            //MARK: --- CREAR NUEVA COLECCION ---
            Button(action: {
                self.esNuevaColeccionPresionado.toggle()
                if #available(iOS 17.0, *) {
                    //MARK: - --- CONSEJO CREAR COLECCION BIBLIOTECA VACIA ---
                    ConsejoCrearColeccion().invalidate(reason: .actionPerformed)
                }
            }) {
                Image(systemName: "folder.badge.plus")
                    .capaIconos(iconSize: const.iconSize, c1: iconColor, c2: iconColor, fontW: const.iconWeight, ajuste: 1.05)
            }
//MARK: - --- CONSEJO CREAR COLECCION BIBLIOTECA VACIA ---
            .popoverTip(ConsejoCrearColeccion())
//MARK: - --- CONSEJO CREAR COLECCION BIBLIOTECA VACIA ---
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
                        if #available(iOS 17.0, *) { ConsejoSmartSorting().invalidate(reason: .actionPerformed) }
                        
                    }) {
                        Label("Smart rename", systemImage: "brain")
                    }
                    .popoverTip(ConsejoSmartSorting())
                }
                
            } label: {
                Image(systemName: "square.grid.3x3.square")
                    .capaIconos(iconSize: const.iconSize, c1: iconColor, c2: iconColor, fontW: const.iconWeight, ajuste: 1.2)
            }
            .id(menuRefreshTrigger)
            .colorScheme(appEstado.temaActual == .dark ? .dark : .light)
            .onTapGesture {
                print("Abriendo menu")
                ConsejoSmartSorting.menuAbierto = true
            }
            
            Button(action: {
                self.menuEstado.ajustesGlobalesPresionado.toggle()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .capaIconos(iconSize: const.iconSize, c1: iconColor, c2: iconColor, fontW: const.iconWeight, ajuste: 1.125)
            }
            .sheet(isPresented: $menuEstado.ajustesGlobalesPresionado) {
                AjustesGlobales()
            }
        }
        .id(coleccionActualVM.coleccion.id)
        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }

    }
}

struct BotonMenu<T: Equatable>: View {
    
    // --- ENTORNO ---
    @EnvironmentObject var ap: AppEstado
    
    // --- PARAMETROS ---
    let nombre: String
    let icono: String
    let valor: T
    let color: Color
    let valorActual: T
    let accion: () -> Void

    // ---V ARIABLES CALCULADAS ---
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

