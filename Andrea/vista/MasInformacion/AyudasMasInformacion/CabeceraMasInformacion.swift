

import SwiftUI

#Preview {
    PreviewMasInformacion1()
}
//
private struct PreviewMasInformacion1: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInformacion(
            pantallaCompleta: $pantallaCompleta,
            vm: ModeloColeccion(),
            elemento: Archivo.preview
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct CabeceraMasInformacion: View {
    
    @EnvironmentObject var ap: AppEstado
    @ObservedObject var elemento: ElementoSistemaArchivos
    @Binding var pantallaCompleta: Bool
    
    var cDinamico: Color { ap.temaResuelto.colorContrario }
    var padding: CGFloat { pantallaCompleta ? 20 : 10 }
    private let constantes = ConstantesPorDefecto()
    
    @State private var isPressed: Bool = false
    @State private var isTitleEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var tituloElemento: String = ""
    
    init(elemento: ElementoSistemaArchivos, pantallaCompleta: Binding<Bool>) {
        self.elemento = elemento
        _pantallaCompleta = pantallaCompleta
        _tituloElemento = State(initialValue: elemento.nombre)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if pantallaCompleta {
                Button(action: {
                    isPressed = true
                    withAnimation(.easeInOut(duration: 0.25)) { ap.masInformacion = false }
                }) {
                    Image(systemName: "xmark.square.fill")
                        .font(.system(size: ap.constantes.iconSize * 1.3))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(cDinamico, Color.red)
                        .symbolEffect(.bounce, value: isPressed)
                }
                .frame(width: ap.constantes.iconSize * 1.3,
                       height: ap.constantes.iconSize * 1.3) // 👈 fuerza el tamaño al del icono
                .contentShape(Rectangle())
                
                Spacer()
            }
            
            ZStack {
                if isTitleEditing {
                    TextField("", text: $tituloElemento)
                        .bold()
                        .font(.system(size: ap.constantes.titleSize * 1.45))
                        .foregroundColor(ap.temaResuelto.tituloColor)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($isTextFieldFocused)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(ap.temaResuelto.tituloColor)
                                .offset(y: 6),
                            alignment: .bottom
                        )
                        .frame(maxWidth: .infinity) // ocupa el espacio libre
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .submitLabel(.done)
                        .onSubmit {
                            elemento.nombre = tituloElemento
                            
                            //Rename (persistencia)
                            SistemaArchivos.sa.renombrarElemento(elemento: elemento, nuevoNombre: tituloElemento)
                            
                            withAnimation { isTitleEditing = false }
                            print("Nuevo autor: \(tituloElemento)")
                        }
                        .onAppear {
                            // en cuanto aparezca el campo de texto, enfocar
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                isTextFieldFocused = true
                            }
                        }

                } else {
                    HStack {
                        Text(tituloElemento.isEmpty ? "desconocido" : tituloElemento)
                            .font(.system(size: ap.constantes.titleSize * 1.45))
                            .foregroundColor(ap.temaResuelto.tituloColor)
                            .bold()
                            .multilineTextAlignment(.leading)
                        Image(systemName: "pencil")
                            .font(.system(size: ap.constantes.iconSize * 0.5))
                            .foregroundColor(ap.temaResuelto.secondaryText)
                    }
                    .frame(height: 40, alignment: .topLeading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isTitleEditing = true
                        }
                    }
                }
            }
            .padding(.horizontal, pantallaCompleta ? 15 : 0)
            
            Spacer()
            
            Button(action: {
                pantallaCompleta.toggle()
            }) {
                HStack {
                                                        
                    Text(pantallaCompleta ? "Salir de Fullscreen" : "Fullscreen")
                        .font(.system(size: ap.constantes.subTitleSize * 0.9))
                        .foregroundColor(cDinamico)
                    
                    Divider()
                       .frame(width: 2, height: 20) // Ajusta la altura de la línea divisoria
                       .background(cDinamico) // Color de la línea divisoria
                       .clipShape(RoundedRectangle(cornerRadius: 40))
                    
                    Image(systemName: pantallaCompleta ? "square.resize.down" : "square.resize.up")
                        .font(.system(size: ap.constantes.iconSize * 0.9))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(cDinamico)
                        .animation(nil, value: pantallaCompleta)
                    
                }
                .padding(6 * ap.constantes.scaleFactor)
                .background(pantallaCompleta ? Color.red.opacity(0.8) : Color.gray.opacity(0.15))
                .cornerRadius(8)
                
            }
        }
        .padding(.horizontal, 15)
        .padding(.top, 5)
        .padding(.vertical, 15)
    }
}
