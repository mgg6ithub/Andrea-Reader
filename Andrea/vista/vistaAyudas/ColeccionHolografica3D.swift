
import SwiftUI

struct BotonMenuSeleccionMiniaturaColeccion: View {
    
    @ObservedObject var coleccion: Coleccion
    let seleccionMiniatura: EnumTipoMiniaturaColeccion
    let color: Color
    let icono: String
    let titulo: String
    @Binding var mostrarPopoverPersonalizado: Bool
    var namespace: Namespace.ID
    
    var isSel: Bool { coleccion.tipoMiniatura == seleccionMiniatura }
    
    @Binding var hayMiniaturasAbanico: Bool
    
    var body: some View {
        Button {
//            if seleccionMiniatura == .personalizada { mostrarPopoverPersonalizado = true }
            if seleccionMiniatura == .abanico {
                coleccion.precargarMiniaturas()
                
                if coleccion.miniaturasBandeja.isEmpty {
                    print("No hay miniaturas...")
                    hayMiniaturasAbanico = true
                    return
                }
            }
                
            print("Has seleccionado la miniatura: ", seleccionMiniatura)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { coleccion.tipoMiniatura = seleccionMiniatura }
            PersistenciaDatos().guardarDatoArchivo(valor: seleccionMiniatura, elementoURL: coleccion.url, key: ClavesPersistenciaElementos().miniaturaColeccion)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: icono)
                Text(titulo)
            }
            .font(.system(size: 14, weight: isSel ? .bold : .medium))
            .foregroundColor(isSel ? .white : .gray)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(
                ZStack {
                    if isSel {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(color)
                            .matchedGeometryEffect(id: "selector", in: namespace)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

struct MensajeNoHayMiniaturas: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.red.opacity(0.85))   // fondo rojo semitransparente
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text("No hay miniaturas disponibles")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Importa archivos para generar miniaturas en modo abanico.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
        .frame(width: 280, height: 180) // tamaño del popover
    }
}

struct ColeccionHolografica3D: View {
    
    @Namespace private var namespace
    
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    @StateObject private var viewModel = ModeloMiniaturaArchivo()
    @State private var mostrarMiniatura = false
    @State private var mostrar = true
    
    @State var vertical: Double = 0
    @State var horizontal: Double = 0
    
    private let imageW: CGFloat = 340
    private let imageH: CGFloat = 510
    
    @State var mostrarPopoverPersonalizado: Bool
    @State var mostrarDocumentPicker: Bool = false
    
    @State var hayMiniaturasAbanico: Bool = false
    
    var col: Coleccion { vm.coleccion }
    var width: CGFloat =  270
    var height: CGFloat = 310
    
    init(vm: ModeloColeccion) {
        self.vm = vm
        self.mostrarPopoverPersonalizado = false
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial) // desenfoque real
                .ignoresSafeArea()
                
            Color.black.opacity(0.55) // capa oscura encima
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        ap.vistaPreviaColeccion = false
                    }
                }
            
            VStack(alignment: .center, spacing: 20) {
                HStack(spacing: 8) {
                    BotonMenuSeleccionMiniaturaColeccion(coleccion: vm.coleccion, seleccionMiniatura: .carpeta, color: vm.color, icono: "folder", titulo: "Carpeta", mostrarPopoverPersonalizado: $mostrarDocumentPicker, namespace: namespace, hayMiniaturasAbanico: $hayMiniaturasAbanico)
                    
                    BotonMenuSeleccionMiniaturaColeccion(coleccion: vm.coleccion, seleccionMiniatura: .abanico, color: vm.color, icono: "rectangle.on.rectangle.angled", titulo: "Abanico", mostrarPopoverPersonalizado: $mostrarDocumentPicker, namespace: namespace, hayMiniaturasAbanico: $hayMiniaturasAbanico)
                        .popover(isPresented: $hayMiniaturasAbanico) { MensajeNoHayMiniaturas() }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding(.top, 45)
                
                Spacer()
                
                // Carta con efecto holográfico
                ZStack {
                    MiniaturaColeccionView(coleccion: vm.coleccion, width: width, height: height)
                }
                .onAppear {
                    if vm.coleccion.tipoMiniatura == .abanico && vm.coleccion.miniaturasBandeja.isEmpty {
                        vm.coleccion.precargarMiniaturas()
                    }
                }
                .onChange(of: vm.coleccion.tipoMiniatura) {
                    if vm.coleccion.tipoMiniatura == .abanico && vm.coleccion.miniaturasBandeja.isEmpty {
                        vm.coleccion.precargarMiniaturas()
                    }
                }
                
                Spacer()
                
                // Panel inferior con información
//                if let info = ImagenInfo(imagen: viewModel.miniatura, url: archivo.imagenPersonalizada) {
                    VStack(alignment: .leading, spacing: 12) {
                        infoRow("Ruta:", "/Users/julio/Documents/Comics/SpiderMan01.cbz")
                        infoRow("Formato:", "CBZ")
                        infoRow("Dimensiones:", "1920 x 1080 px")
                        infoRow("Peso:", "4.8 MB")
                        infoRow("Calidad:", "Alta (300 dpi)")
                        infoRow("Ratio:", "16:9")
                        infoRow("Fecha modificación:", "5 sept 2025, 14:32")
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
//                }
                
            } //7FIN ZSTACK
//            .sheet(isPresented: $mostrarDocumentPicker) {
//                ImagePickerDocument(
//                    onPick: { urls in
//                        if let urlImagen = urls.first { //solamnetre la primera seleccionada
//                            print("✅ Imagen seleccionada:", urlImagen)
//                            SistemaArchivos.sa.crearColImagenesYCopiar(color: vm.color, archivo: archivo, urlImagen: urlImagen)
//                        }
//                    },
//                    onCancel: {
//                        print("❌ Cancelado")
//                    }
//                )
//            }

        }
    }
    
    
    // helper para filas de texto
    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 16))
        }
    }
    
}
