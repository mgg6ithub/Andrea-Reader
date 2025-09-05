

import SwiftUI

#Preview {
    pMIcoleccion4()
}
//
private struct pMIcoleccion4: View {
    @State private var pantallaCompleta = false
    
    var body: some View {
        MasInfoCol(
            pantallaCompleta: $pantallaCompleta, vm: ModeloColeccion()
        )
//                .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667)) // Mock o real
//                .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852)) // Mock o real
                .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
    }
}

struct TituloYAjustesColeccion: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    @Binding var pantallaCompleta: Bool
    
    @State private var isTitleEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var tituloElemento: String = ""
    
    @State private var mostrarPopoverPersonalizado: Bool = false
    @Binding var mostrarDocumentPicker: Bool
    
    init(vm: ModeloColeccion, pantallaCompleta: Binding<Bool>, mostrarDocumentPicker: Binding<Bool>) {
        _vm = ObservedObject(initialValue: vm)
        _pantallaCompleta = pantallaCompleta
        _tituloElemento = State(initialValue: vm.coleccion.nombre)
        _mostrarDocumentPicker = mostrarDocumentPicker
    }
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 4) {
                Button(action: {
                    mostrarPopoverPersonalizado.toggle()
                }) {
                    if let urlIcono = vm.coleccion.icono {
                        if let imgIcono = ModeloMiniatura.modeloMiniatura.obtenerMiniaturaPersonalizada(archivo: Archivo(), color: vm.color, urlMiniatura: urlIcono) {
                            
                            Image(uiImage: imgIcono)
                                .resizable()
                                .font(.system(size: ap.constantes.iconSize * 0.8))
                                .onAppear {
                                    print("URL ICONO: ", urlIcono)
                                    print("Mostrando imagne: ", imgIcono)
                                }
                        }
                    } else {
                        VStack(alignment: .center, spacing: 1) {
                            Image(systemName: "plus.rectangle.on.rectangle")
                                .font(.system(size: ap.constantes.iconSize * 0.8))
                            
                            Text("icono")
                                .font(.system(size: ap.constantes.subTitleSize * 0.65))
                                .foregroundColor(ap.temaResuelto.secondaryText)
                        }
                        .offset(y: 5)
                    }
                }
                .buttonStyle(.plain)
                .frame(width: 40, height: 40)
                .popover(isPresented: $mostrarPopoverPersonalizado) {
                    ImportacionPersonalizada(mostrarDocumentPicker: $mostrarDocumentPicker, color: vm.color) // aquí puedes pasar también el archivo si lo necesitas
                }
                
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
            }
            .offset(y: 4)
            
            Spacer()
            SelectorAjustesLectura(vm: vm)
        }
        .frame(height: 70)
    }
}
