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

    @State private var mostrarDocumentPicker: Bool = false
    @State private var esNuevaColeccionPresionado: Bool = false
    @State private var nuevaColeccionNombre: String = ""
    
    // --- VARIABLES CALCULADAS ---
    private let sa: SistemaArchivos = SistemaArchivos.sa
    private var const: Constantes { appEstado.constantes }
    private var iconColor: Color { const.iconColor }
    
    @ObservedObject var coleccionActualVM: ModeloColeccion
    
    private var menuRefreshTrigger: UUID { coleccionActualVM.menuRefreshTrigger }

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
                        print("Importados ahora se ordena")
                        //Despues de importar aplicar ordenamiento automatico
                        coleccionActualVM.ordenarElementos(modoOrdenacion: self.coleccionActualVM.ordenacion)
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
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.modoVista
                    ) {
                        coleccionActualVM.cambiarModoVista(modoVista: .cuadricula)
                    }

                    BotonMenu(
                        nombre: "Lista",
                        icono: "list.bullet",
                        valor: .lista,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.modoVista
                    ) {
                        coleccionActualVM.cambiarModoVista(modoVista: .lista)
                    }
                }
                
                Section(header: Text("Ordenar")) {
                    BotonMenu(
                        nombre: "Aleatorio",
                        icono: "shuffle",
                        valor: .aleatorio,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .aleatorio)
                    }
                    
                    BotonMenu(
                        nombre: "Personalizada",
                        icono: "hand.draw.fill",
                        valor: .personalizado,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {

                    }
                    
                    BotonMenu(
                        nombre: "Nombre",
                        icono: "textformat.abc",
                        valor: .nombre,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .nombre)
                    }
                    
                    BotonMenu(
                        nombre: "Tamaño",
                        icono: "arrow.left.and.right.text.vertical",
                        valor: .tamano,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .tamano)
                    }
                    
                    BotonMenu(
                        nombre: "Paginas",
                        icono: "book.pages",
                        valor: .paginas,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .paginas)
                    }
                    
                    BotonMenu(
                        nombre: "Progreso",
                        icono: "progress.indicator",
                        valor: .progreso,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .progreso)
                    }
                    
                    BotonMenu(
                        nombre: "Fecha importación",
                        icono: "custom-calendar",
                        valor: .fechaImportacion,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .fechaImportacion)
                    }
                    
                    BotonMenu(
                        nombre: "Fecha modificación",
                        icono: "custom-calendar-clock",
                        valor: .fechaModificacion,
                        coleccionActualVM: coleccionActualVM,
                        valorActual: coleccionActualVM.ordenacion
                    ) {
                        coleccionActualVM.ordenarElementos(modoOrdenacion: .fechaModificacion)
                    }
                    
                }
                
                Section(header: Text("Invertir Ordenacion")) {
                    BotonMenu(nombre: "Invertir", icono: "arrow.triangle.swap", valor: true, coleccionActualVM: coleccionActualVM, valorActual: coleccionActualVM.esInvertido) {
                        coleccionActualVM.invertir()
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
            .id(coleccionActualVM.menuRefreshTrigger)
            .colorScheme(appEstado.temaActual == .dark ? .dark : .light)
            .onTapGesture {
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
        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
    }
}

struct BotonMenu<T: Equatable>: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let nombre: String
    let icono: String
    let valor: T
    @ObservedObject var coleccionActualVM: ModeloColeccion
    let valorActual: T
    let accion: () -> Void
    
    var isActive: Bool {
        valor == valorActual
    }
    
    private var dC: Color { ap.temaActual.textColor }
    
    var body: some View {
        Button {
            accion()  // ejecuta la acción pasada
            coleccionActualVM.menuRefreshTrigger = UUID() // refresca después
        } label: {
            if UIImage(systemName: icono) != nil {
                // SF Symbol
                Label(nombre, systemImage: icono)
                    .foregroundStyle(
                        isActive ? dC : dC.opacity(0.3),
                        isActive ? dC : dC.opacity(0.3),
                        dC
                    )
            } else {
                // Icono personalizado
                Label {
                    Text(nombre)
                } icon: {
                    Image(icono)
                        .renderingMode(.template)
                        .foregroundStyle(
                            isActive ? dC : dC.opacity(0.3),
                            isActive ? dC : dC.opacity(0.3),
                            dC
                        )
                }
            }
        }
    }
}



