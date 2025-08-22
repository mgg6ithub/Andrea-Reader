

import SwiftUI

struct InformacionAvanzada: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
       @ObservedObject var vm: ModeloColeccion
       
       let opacidad: CGFloat
    @Binding var masInfoPresionado: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(Color.gray.opacity(opacidad))
//        //                .overlay(
//        //                        RoundedRectangle(cornerRadius: 25)
//        //                            .stroke(.black.opacity(0.6), lineWidth: 2) // borde gris oscuro
//        //                    )
//                        .shadow(color: .black.opacity(0.225), radius: 10, x: 0, y: 5)
//                        .zIndex(0)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Información avanzada")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        GrupoDatoAvanzado(nombre: "Pertenece a la colección", valor: vm.coleccion.nombre)
                        GrupoDatoAvanzado(nombre: "Numero de la colección", valor: "\(archivo.numeroDeLaColeccion ?? 0)")
                        GrupoDatoAvanzado(nombre: "Nombre original", valor:  archivo.nombreOriginal ?? "desconocido")
                        GrupoDatoAvanzado(nombre: "Ruta absoluta", valor: "\(archivo.url)")
                        GrupoDatoAvanzado(nombre: "Ruta relativa", valor: "\(archivo.relativeURL)")
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.25))
                        
                        Button(action: {
                            withAnimation { masInfoPresionado.toggle() }
                        }) {
                            HStack(spacing: 5) {
                                Text("Más informacion")
                                    .font(.subheadline)
                                    .padding(.bottom, 5)
                                
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: ap.constantes.iconSize * 0.5))
                                    .rotationEffect(.degrees(masInfoPresionado ? 90 : 0))
                            }
                        }
                        .buttonStyle(.plain)
                        
                        if masInfoPresionado {
                            VStack(alignment: .leading, spacing: 10) {
                                GrupoDatoAvanzado(nombre: "Editorial", valor: "Marvel")
                                GrupoDatoAvanzado(nombre: "Formato de escaneo", valor: archivo.formatoEscaneo ?? "desconocido")
                                GrupoDatoAvanzado(nombre: "Entidad del escaneador", valor: archivo.entidadEscaneo ?? "desconocido")
                                GrupoDatoAvanzado(nombre: "Resolución", valor: "333 pp")
                                GrupoDatoAvanzado(nombre: "Peso", valor: "2.13")
                                GrupoDatoAvanzado(nombre: "Fecha de importación del sistema", valor: "\(Fechas().formatDate1(SistemaArchivosUtilidades.sau.obtenerFechaImportacionSistema(elementURL: archivo.url)))")
                                GrupoDatoAvanzado(nombre: "Fecha de importación al programa", valor: "\(Fechas().formatDate1(archivo.fechaImportacion))")
                                GrupoDatoAvanzado(nombre: "Numero de aperturas", valor: "fechaCreacion")
                                GrupoDatoAvanzado(nombre: "Primera lectura", valor: "fechaCreacion")
                                GrupoDatoAvanzado(nombre: "Última lectura", valor: "ultimaLectura")
                                GrupoDatoAvanzado(nombre: "Última modificación", valor: "ultimaLectura")
                                GrupoDatoAvanzado(nombre: "Formato", valor: "formato")
                                GrupoDatoAvanzado(nombre: "ID único", valor: "idUnico")
                                GrupoDatoAvanzado(nombre: "ISBN", valor: "123123123")
                            }
                        }
                    }
                    .padding()
                }
    }
}


struct GrupoDatoAvanzado: View {
    let nombre: String
    @State var valor: String
    @State private var editando = false

    var body: some View {
        HStack(alignment: .top) {
            Text(nombre)
                .foregroundColor(.secondary)

            Spacer()

            if editando {
                TextField("", text: $valor, onCommit: {
                    print("Nuevo valor: \(valor)")
                    editando = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 200, alignment: .trailing)
            } else {
                Text(valor)
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.5)
                    .lineLimit(5)
                    .onTapGesture {
                        editando = true
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}
