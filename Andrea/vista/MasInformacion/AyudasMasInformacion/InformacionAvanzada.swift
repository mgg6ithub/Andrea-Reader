

import SwiftUI

#Preview {
    PreviewMasInformacion2()
}
//
private struct PreviewMasInformacion2: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInformacionArchivo(
            vm: ModeloColeccion(),
            archivo: Archivo.preview,
            pantallaCompleta: $pantallaCompleta,
            escala: 1.0
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct InformacionAvanzadaFechas: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
    @ObservedObject var vm: ModeloColeccion
       
    let opacidad: CGFloat
    @Binding var masInfoPresionado: Bool
    
    private var const: Constantes { ap.constantes }
    private var titleS: CGFloat { const.titleSize }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Image(systemName: "calendar")
                        .font(.system(size: ap.constantes.iconSize * 0.8))

                    Text("Fechas")
                        .bold()
                        .font(.system(size: titleS))
                }
                
                GrupoDatoAvanzadoEditable(nombre: "Fecha de publicación", valor: archivo.yearPublicion != nil ? "\(archivo.yearPublicion!)" : "Desconocido")
                
//                if let fechaInicio = archivo.estadisticas.sesionesLectura.first?.inicio {
                if let fechaInicio = archivo.fechaPrimeraVezEntrado {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Primera lectura", valor: Fechas().formatDate1(fechaInicio))
                } else {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Primera lectura", valor: "desconocida")
                }
                
                if let fechaFin = archivo.estadisticas.sesionesLectura.last?.fin {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Última lectura", valor: Fechas().formatDate1(fechaFin))
                } else {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Última lectura", valor: "desconocida")
                }
                
                GrupoDatoAvanzadoSoloLectura(nombre: "Última modificación", valor: Fechas().formatDate1(SistemaArchivosUtilidades.sau.getElementModificationDate(elementURL: archivo.url)))
                
            }
            .padding()
        }
    }
}


struct InformacionAvanzadaFechasColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
       
    let opacidad: CGFloat
    @Binding var masInfoPresionado: Bool
    
    private var const: Constantes { ap.constantes }
    private var titleS: CGFloat { const.titleSize }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Image(systemName: "calendar")
                        .font(.system(size: ap.constantes.iconSize * 0.8))

                    Text("Fechas")
                        .bold()
                        .font(.system(size: titleS))
                }
                
                GrupoDatoAvanzadoEditable(nombre: "Fecha de creación", valor: Fechas().formatDate1(SistemaArchivosUtilidades.sau.obtenerFechaImportacionSistema(elementURL: vm.coleccion.url)))
                
                if let fechaInicio = vm.coleccion.fechaPrimeraVezEntrado {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Primera entrada", valor: Fechas().formatDate1(fechaInicio))
                } else {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Primera entrada", valor: "desconocida")
                }
                
                if let fechaFin = vm.coleccion.fechaUltimaVezEntrado {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Última entrada", valor: Fechas().formatDate1(fechaFin))
                } else {
                    GrupoDatoAvanzadoSoloLectura(nombre: "Última entrada", valor: "desconocida")
                }
                
                GrupoDatoAvanzadoSoloLectura(nombre: "Última modificación", valor: Fechas().formatDate1(SistemaArchivosUtilidades.sau.getElementModificationDate(elementURL: vm.coleccion.url)))
                
            }
            .padding()
        }
    }
}


struct InformacionAvanzada: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var archivo: Archivo
       @ObservedObject var vm: ModeloColeccion
       
       let opacidad: CGFloat
    @Binding var masInfoPresionado: Bool
    private var const: Constantes { ap.constantes }
    private var titleS: CGFloat { const.titleSize }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Image(systemName: "info.square")
                        .font(.system(size: ap.constantes.iconSize * 0.8))
                    
                    Text("Información avanzada")
                        .bold()
                        .font(.system(size: titleS))
                }
                
                GrupoDatoAvanzadoSoloLectura(nombre: "Nombre original", valor:  archivo.nombreOriginal ?? "desconocido")
                GrupoDatoAvanzadoEditable(nombre: "Número de la colección", valor: archivo.numeroDeLaColeccion != nil ? "\(archivo.numeroDeLaColeccion!)" : "Desconocido")
                GrupoDatoAvanzadoEditable(nombre: "Total de números", valor: archivo.totalNumerosColeccion != nil ? "\(archivo.totalNumerosColeccion!)" : "Desconocido")
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.25))
                
                Button(action: {
                    withAnimation { masInfoPresionado.toggle() }
                }) {
                    HStack(spacing: 5) {
                        Text(masInfoPresionado ? "Menos información" : "Más información")
                            .font(.system(size: titleS))
                            .bold()
                            .padding(.bottom, 5)
                        
                        Image(systemName: "chevron.forward")
                            .font(.system(size: ap.constantes.iconSize * 0.7))
                            .rotationEffect(.degrees(masInfoPresionado ? -90 : 90))
                            .offset(y: -2)
                    }
                }
                .buttonStyle(.plain)
                
                if masInfoPresionado {
                    VStack(alignment: .leading, spacing: 10) {
                        GrupoDatoAvanzadoEditable(nombre: "Editorial", valor: archivo.editorial ?? "desconocido")
                        GrupoDatoAvanzadoEditable(nombre: "Formato de escaneo", valor: archivo.formatoEscaneo ?? "desconocido")
                        GrupoDatoAvanzadoEditable(nombre: "Entidad del escaneador", valor: archivo.entidadEscaneo ?? "desconocido")
                        GrupoDatoAvanzadoSoloLectura(nombre: "Fecha de importación del sistema", valor: "\(Fechas().formatDate1(SistemaArchivosUtilidades.sau.obtenerFechaImportacionSistema(elementURL: archivo.url)))")
                        GrupoDatoAvanzadoSoloLectura(nombre: "Fecha de importación al programa", valor: "\(Fechas().formatDate1(archivo.fechaImportacion))")
                        GrupoDatoAvanzadoSoloLectura(nombre: "Primera lectura", valor: "fechaCreacion")
                        GrupoDatoAvanzadoSoloLectura(nombre: "Última lectura", valor: "ultimaLectura")
                        GrupoDatoAvanzadoSoloLectura(nombre: "Última modificación", valor: "ultimaLectura")
                        GrupoDatoAvanzadoSoloLectura(nombre: "ID único", valor: "\(archivo.id)")
                        GrupoDatoAvanzadoSoloLectura(nombre: "Ruta absoluta", valor: "\(archivo.url.path)")
                        GrupoDatoAvanzadoSoloLectura(nombre: "Ruta relativa", valor: "\(archivo.relativeURL)")
                    }
                }
            }
            .padding()
        }
    }
}

struct GrupoDatoAvanzadoSoloLectura: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let nombre: String
    let valor: String
    
    private var const: Constantes { ap.constantes }
    private var titleS: CGFloat { const.titleSize * 0.75 }

    var body: some View {
        HStack(alignment: .top) {
            Text(nombre)
                .font(.system(size: titleS))
                .foregroundColor(ap.temaResuelto.secondaryText)

            Spacer()
            
            Text(valor)
                .multilineTextAlignment(.trailing)
                .lineLimit(3)                 // 👉 permite hasta 5 líneas
                .minimumScaleFactor(0.5)      // 👉 reducirá la fuente si no cabe
                .font(.system(size: titleS))

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}


struct GrupoDatoAvanzadoEditable: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let nombre: String
    @State var valor: String
    @State private var editando = false

    private var const: Constantes { ap.constantes }
    private var titleS: CGFloat { const.titleSize * 0.75 }
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 2) {
                Text(nombre)
                    .font(.system(size: titleS))
                    .foregroundColor(ap.temaResuelto.secondaryText)
                Image(systemName: "pencil")
                    .font(.system(size: ap.constantes.iconSize * 0.5))
                    .foregroundColor(ap.temaResuelto.secondaryText)
            }
            .contentShape(Rectangle())

            Spacer()

            if editando {
                TextField("", text: $valor, onCommit: {
                    print("Nuevo valor: \(valor)")
                    editando = false
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 200, alignment: .trailing)
                .font(.system(size: titleS))
            } else {
                Text(valor)
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.5)
                    .lineLimit(5)
                    .onTapGesture {
                        editando = true
                    }
                    .font(.system(size: titleS))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}
