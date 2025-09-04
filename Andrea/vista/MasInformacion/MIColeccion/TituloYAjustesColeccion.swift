

import SwiftUI

struct TituloYAjustesColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @Binding var pantallaCompleta: Bool
    
    @State private var isTitleEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var tituloElemento: String = ""
    
    var body: some View {
        HStack {
            ZStack {
                if isTitleEditing {
                    TextField("", text: $tituloElemento)
                        .bold()
                        .font(.system(size: ap.constantes.titleSize * 1.55))
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
                            vm.coleccion.nombre = tituloElemento
                            
                            //Rename (persistencia)
                            SistemaArchivos.sa.renombrarElemento(elemento: vm.coleccion, nuevoNombre: tituloElemento)
                            
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
                            .font(.system(size: ap.constantes.titleSize * 1.55))
                            .foregroundColor(ap.temaResuelto.tituloColor)
                            .bold()
                            .multilineTextAlignment(.leading)
                        Image(systemName: "pencil")
                            .font(.system(size: ap.constantes.iconSize * 0.7))
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
            SelectorAjustesLectura(vm: vm)
        }
        .padding(.horizontal, 20)
    }
}
