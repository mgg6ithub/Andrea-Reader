
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
    
    var body: some View {
        Button {
//            if seleccionMiniatura == .personalizada { mostrarPopoverPersonalizado = true }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { coleccion.tipoMiniatura = seleccionMiniatura }
//            PersistenciaDatos().guardarDatoArchivo(valor: seleccionMiniatura, elementoURL: coleccion.url, key: ClavesPersistenciaElementos().miniaturaElemento)
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

struct ColeccionHolografica3D: View {
    
    @Namespace private var namespace
    
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var vm: ModeloColeccion
    
    @State var mostrarPopoverPersonalizado: Bool = false
    @State var mostrarDocumentPicker: Bool = false
    
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
                    BotonMenuSeleccionMiniaturaColeccion(coleccion: vm.coleccion, seleccionMiniatura: .carpeta, color: vm.color, icono: "folder", titulo: "Carpeta", mostrarPopoverPersonalizado: $mostrarDocumentPicker, namespace: namespace)
                    BotonMenuSeleccionMiniaturaColeccion(coleccion: vm.coleccion, seleccionMiniatura: .abanico, color: vm.color, icono: "rectangle.on.rectangle.angled", titulo: "Abanico", mostrarPopoverPersonalizado: $mostrarDocumentPicker, namespace: namespace)
                        }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding(.top, 45)
                .padding(.bottom, 80)
                
            }
        } //FIN ZSTACK
    }
