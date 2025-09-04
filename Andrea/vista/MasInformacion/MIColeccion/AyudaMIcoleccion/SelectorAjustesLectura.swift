import SwiftUI

#Preview {
    pMIcoleccion3()
}
//
private struct pMIcoleccion3: View {
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

struct SelectorAjustesLectura: View {
    
    @EnvironmentObject var ap: AppEstado
    
    @ObservedObject var vm: ModeloColeccion
    
    @State private var sm: Bool = true
    @State private var ajustesLectura: Bool = true
    
    private var dynamicColor: Color { ap.temaResuelto.colorContrario }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("Ajustes de lectura")
                    .font(.system(size: ap.constantes.titleSize * 0.9))
                    .bold()
                    .foregroundColor(ap.temaResuelto.tituloColor)
                
                HStack(alignment: .bottom, spacing: 3) {
                    Image(systemName: "book.and.wrench")
                    .font(.system(size: ap.constantes.iconSize * 0.65))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(dynamicColor)
                    
                    Text("Modifica los ajustes")
                        .font(.system(size: ap.constantes.subTitleSize * 0.9))
                        .foregroundColor(ap.temaResuelto.secondaryText)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.ajustesLectura.toggle()
                    }
                }) {
                    
                    if sm {
                        ZStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("manga")
                                    .font(.subheadline)
                                    .foregroundColor(vm.color.brightness() > 0.5 ? .black : .white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.6)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("-paginado")
                                        .font(.system(size: 8))
                                        .foregroundColor(vm.color.brightness() > 0.5 ? .black : .white)
                                        .lineLimit(1)
                                    
                                    Text("-completa")
                                        .font(.system(size: 8))
                                        .foregroundColor(vm.color.brightness() > 0.5 ? .black : .white)
                                        .lineLimit(1)
                                }
                                .padding(.leading, 3.5)
                            }
                            .scaleEffect(self.ajustesLectura ? 0.6 : 1.0)
                            .padding(3.5)
                            .frame(width: 55, height: 55, alignment: .topLeading)
                            .zIndex(1)
                            
                            Image(systemName: "rectangle.fill")
                                .resizable()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(vm.color.gradient)
                                .frame(width: ajustesLectura ? 50 : 55, height: ajustesLectura ? 50 : 55) // Tamaño reducido si está activo
                                .rotationEffect(.degrees(90))
                                .symbolEffect(.bounce, value: ajustesLectura)
                            
                            if ajustesLectura {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 2.5, dash: [5]))
                                    .foregroundColor(ajustesLectura ? dynamicColor : vm.color)
                                //                                    .shadow(color: ajustesLectura ? Color.black.opacity(1.0) : .clear, radius: 5, x: 0, y: 2.5)
                                    .frame(width: 55, height: 55) // Tamaño original del borde
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: ajustesLectura)
                        
                    } else {
                        ZStack {
                            
                            Image(systemName: "plus")
                                .font(.system(size: ap.constantes.iconSize))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(dynamicColor)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 2.5, dash: [5]))
                                .foregroundColor(dynamicColor)
                            //                                    .shadow(color: ajustesLectura ? Color.black.opacity(1.0) : .clear, radius: 5, x: 0, y: 2.5)
                                .frame(width: 55, height: 55)
                                .zIndex(1)
                        }
                    }
                    
                }
//                .padding(.trailing, 45)
//                .padding(.bottom, 20)
//                        .dropDestination(for: ReadSettingTransferData.self) { droppedItem, location in
//                            guard let droppedData = droppedItem.first else {
//                                return false // Si no hay datos válidos, cancela el drop
//                            }
//                            let settingName = droppedData.originalModelName
//                            let sm = ReadSettingsManager.getReadSettingsManager.getReadSettingModelByName(settingName: settingName)
//
//                            dir.readSettingsModel = sm
//                            DataPersistence.getDataPersistence().saveDirectoryModelName(for: dir.url, modelName: settingName)
//
//                            elementModel.appState.objectWillChange.send()
//                            self.ajustesLectura = false
//
//                            return true
//                        }
                    }
            
        }
    }
}
