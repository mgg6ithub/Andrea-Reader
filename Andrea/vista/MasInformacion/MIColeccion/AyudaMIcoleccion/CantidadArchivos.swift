
import SwiftUI

#Preview {
    pMIcoleccion()
}

//
private struct pMIcoleccion: View {
    @State private var pantallaCompleta = true
    
    var body: some View {
        MasInfoCol(
            pantallaCompleta: $pantallaCompleta, vm: ModeloColeccion()
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

enum SeleccionTipo: String {
    case archivos
    case colecciones
}

struct PickerArchivosColecciones: View {
    @Binding var seleccion: SeleccionTipo
    
    let vm: ModeloColeccion
    let estadisticasColeccion: EstadisticasColeccion
    
    let iconS: CGFloat
    let subtitleS: CGFloat
    let subtitleC: Color
    
    @State private var archivos: Int = 0
    @State private var subcolecciones: Int = 0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            
            Button {
                seleccion = .archivos
                print("👉 Selección: archivos")
            } label: {
                HStack(alignment: .bottom, spacing: 2) {
                    Image(systemName: "text.document")
                        .font(.system(size: iconS))
                        .foregroundColor(vm.color)
                    
                    Text("\(archivos) archivos")
                        .font(.system(size: subtitleS))
                        .foregroundColor(subtitleC)
                }
                .opacity(seleccion == .archivos ? 1 : 0.35)
            }
            .buttonStyle(.plain)
            
            Divider()
                .frame(height: 16)
                .padding(.horizontal, 3)
            
            Button {
                seleccion = .colecciones
                print("👉 Selección: colecciones")
            } label: {
                HStack(alignment: .bottom, spacing: 3) {
                    Image(systemName: "folder")
                        .font(.system(size: iconS))
                        .foregroundColor(vm.color)
                    
                    Text("\(subcolecciones) subcolecciones")
                        .font(.system(size: subtitleS))
                        .foregroundColor(subtitleC)
                }
                .opacity(seleccion == .colecciones ? 1 : 0.35)
            }
            .buttonStyle(.plain)
        }
        .onReceive(estadisticasColeccion.$totalArchivos) { archivos = $0 }
        .onReceive(estadisticasColeccion.$totalSubColecciones) { subcolecciones = $0 }
    }
}


struct InfoRow: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let text: String
    var nombre: String? = nil
    let dato: Int
    
    @State private var mostrarPO: Bool = false
    
    private var subtitleS: CGFloat { ap.constantes.subTitleSize * 0.8 }
    private var subtitleC: Color { ap.temaResuelto.secondaryText }
    
    private var anchura: CGFloat { ap.resolucionLogica == .small ? .infinity : 230 }
    
    var body: some View {
        Button(action: {
            mostrarPO.toggle()
        }) {
            HStack(spacing: 2) {
                
                Text(text)
                    .font(.system(size: subtitleS))
                    .foregroundColor(subtitleC)
                
                Spacer()
                
                Text(ManipulacionSizes().formatearSize(dato))
                    .font(.system(size: subtitleS))
                    .foregroundColor(subtitleC)
                
            }
            .frame(width: anchura)
            .popover(isPresented: $mostrarPO) {
                if let nombre = nombre {
                    Text(nombre)
                        .font(.system(size: subtitleS))
                        .foregroundColor(subtitleC)
                        .padding()
                }
            }
        }
    }
}


struct EstadisticasPesoVista: View {
    @ObservedObject var estadisticas: EstadisticasColeccion
    let tipo: SeleccionTipo
    
    // Estados locales
    @State private var pesoPromedio: Int = 0
    @State private var masPesado: (String, Int) = ("", 0)
    @State private var menosPesado: (String, Int) = ("", 0)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            InfoRow(
                text: "Tamaño promedio",
                dato: pesoPromedio
            )
            
            InfoRow(
                text: "Más grande",
                nombre: masPesado.0,
                dato: masPesado.1
            )
            
            InfoRow(
                text: "Más pequeño",
                nombre: menosPesado.0,
                dato: menosPesado.1
            )
            
        }
        .onAppear {
            sincronizar() // inicial
        }
        .onChange(of: tipo) {
            sincronizar() // cuando cambie el picker
        }
        // 📌 Suscripciones reactivas según el tipo
        .onReceive(estadisticas.$pesoPromedioArchivos) { nuevo in
            if tipo == .archivos { pesoPromedio = nuevo }
        }
        .onReceive(estadisticas.$archivoMasPesado.combineLatest(estadisticas.$sizeArchivoMasPesado)) { (nombre, size) in
            if tipo == .archivos { masPesado = (nombre, size) }
        }
        .onReceive(estadisticas.$archivoMenosPesado.combineLatest(estadisticas.$sizeArchivoMenosPesado)) { (nombre, size) in
            if tipo == .archivos { menosPesado = (nombre, size) }
        }
        .onReceive(estadisticas.$pesoPromedioColecciones) { nuevo in
            if tipo == .colecciones { pesoPromedio = nuevo }
        }
        .onReceive(estadisticas.$coleccionMasPesada.combineLatest(estadisticas.$sizeColeccionMasPesada)) { (nombre, size) in
            if tipo == .colecciones { masPesado = (nombre, size) }
        }
        .onReceive(estadisticas.$coleccionMenosPesada.combineLatest(estadisticas.$sizeColeccionMenosPesada)) { (nombre, size) in
            if tipo == .colecciones { menosPesado = (nombre, size) }
        }
    }
    
    private func sincronizar() {
        switch tipo {
        case .archivos:
            pesoPromedio = estadisticas.pesoPromedioArchivos
            masPesado = (estadisticas.archivoMasPesado, estadisticas.sizeArchivoMasPesado)
            menosPesado = (estadisticas.archivoMenosPesado, estadisticas.sizeArchivoMenosPesado)
            
        case .colecciones:
            pesoPromedio = estadisticas.pesoPromedioColecciones
            masPesado = (estadisticas.coleccionMasPesada, estadisticas.sizeColeccionMasPesada)
            menosPesado = (estadisticas.coleccionMenosPesada, estadisticas.sizeColeccionMenosPesada)
        }
    }
}


struct CantidadArchivos: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @ObservedObject var estadisticasColeccion: EstadisticasColeccion
    
    private var const: Constantes { ap.constantes }
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    
    private var iconS: CGFloat { const.iconSize * 0.7 }
    private var subtitleS: CGFloat { const.subTitleSize * 0.85 }
    private var subtitleC: Color { tema.secondaryText }
    
    @State private var seleccion: SeleccionTipo = .archivos
    private var anchura: CGFloat { ap.resolucionLogica == .small ? .infinity : 230 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Cantidad de archivos")
                .font(.system(size: ap.constantes.titleSize * 0.9))
                .bold()
                .foregroundColor(tema.tituloColor)
            
            HStack(alignment: .bottom, spacing: 3) {
                
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: iconS))
                    .foregroundColor(vm.color)
                
                Text("\(estadisticasColeccion.totalElementos) en total")
                    .font(.system(size: const.subTitleSize))
                    .foregroundColor(tema.colorContrario)
            }
            .padding(.bottom, 15)
            
            PickerArchivosColecciones(seleccion: $seleccion, vm: vm, estadisticasColeccion: estadisticasColeccion, iconS: iconS, subtitleS: subtitleS, subtitleC: subtitleC)
            
            Rectangle()
                .fill(Color.secondary.opacity(0.15))
                .frame(width: anchura, height: 1)
                .padding(.vertical, 4)
            
            if seleccion == .archivos {
                EstadisticasPesoVista(estadisticas: estadisticasColeccion, tipo: .archivos)
                    .onAppear {
                        if !vm.elementos.isEmpty {
                            estadisticasColeccion.calcularPesoArchivo(vm.elementos)
                        }
                    }
                    .onChange(of: vm.elementos) { _, elementos in
                        if !elementos.isEmpty {
                            estadisticasColeccion.calcularPesoArchivo(elementos)
                        }
                    }
            } else {
                EstadisticasPesoVista(estadisticas: estadisticasColeccion, tipo: .colecciones)
                    .onAppear {
                        if !vm.elementos.isEmpty {
                            estadisticasColeccion.calcularPesoSubcolecciones(vm.elementos)
                        }
                    }
                    .onChange(of: vm.elementos) { _, elementos in
                        if !elementos.isEmpty {
                            estadisticasColeccion.calcularPesoSubcolecciones(elementos)
                        }
                    }
            }

            Spacer()
        }
        
        Spacer()
        
        VStack(alignment: .center, spacing: 15) {
            ProgresoCircular(
                titulo: "tamaño",
                progreso: estadisticasColeccion.porcentajePesoTotal,
                progresoDouble: estadisticasColeccion.porcentajePesoTotalDouble,
                color: .red,
                anchuraLinea: 12,
                radio: 120
            )
            
            VStack(alignment: .center, spacing: 4) {
                HStack(spacing: 3) {
                    Image(systemName: "externaldrive")
                        .font(.system(size: const.iconSize * 0.65))
                        .foregroundColor(.red.opacity(0.85))
                    Text("Almacenamiento")
                        .font(.system(size: const.titleSize * 0.75))
                        .foregroundColor(tema.tituloColor)
                }
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text("Ocupa")
                        .font(.system(size: const.subTitleSize * 0.65))
                        .foregroundColor(tema.secondaryText.opacity(0.8))
                    Text(ManipulacionSizes().formatearSize(estadisticasColeccion.pesoTotalArchivos))
                        .font(.system(size: const.subTitleSize * 0.75))
                        .foregroundColor(tema.secondaryText)
                    Text("de")
                        .font(.system(size: const.subTitleSize * 0.65))
                        .foregroundColor(tema.secondaryText.opacity(0.8))
                    Text(ManipulacionSizes().formatearSize(estadisticasColeccion.ALMACENAMIENTOTALPROGRAMA))
                        .font(.system(size: const.subTitleSize * 0.75))
                        .foregroundColor(tema.secondaryText)
                }
            }
        }
        .padding(.top, 10)
        .padding(.trailing, 45)

    }
}
