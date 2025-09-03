
import Foundation
import SwiftUI

struct AjustesLecturaOpciones: View {
    
    @EnvironmentObject var ap: AppEstado
    
//    private let customKey: String = "customSettings"
    
    @ObservedObject var vm: ModeloColeccion
    
    @EnvironmentObject var viewSettings: ViewSettings
    
    @Binding var isPreviewPressed: Bool
    
    var colorPersonalizado: Color
        
    let colors: [Color] = [
        .red, .green, .blue, .yellow, .orange, .purple, .pink
    ]

    var const: Constantes { ap.constantes }
    var customFontColor: Color = .red
    var iconSize: CGFloat { const.iconSize }
    
    var body: some View {
        
        ZStack {
            Color(UIColor.systemGray5)
                .blur(radius: 2.5)

            VStack(alignment: .center, spacing: 15) {
                
//                ZStack {
//                    Button(action: {
//                        self.isPreviewPressed.toggle()
//                    }) {
//                        HStack {
//                            Spacer()
//                            Text("PREVIEW")
//                                .font(.system(size: 17))
//                                .foregroundColor(customFontColor.opacity(0.9))
//                                .bold()
//                            
//                            Image(self.isPreviewPressed ? "custom-camera" : "camera-slash")
//                                .frame(width: 20, height: 20)
//                                .font(.system(size: iconSize * 0.7))
//                                .transition(.symbolEffect)
//                                .symbolRenderingMode(.palette)
//                                .foregroundStyle(customFontColor.opacity(0.9))
//                                .animation(.easeInOut(duration: 0.15), value: isPreviewPressed)
//                                .padding(.bottom, 1)
//                            
//                            Spacer()
//                        }
//                    }
//                }
//                .padding(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5])) // Línea discontinua
//                        .foregroundColor(.secondary)
//                )
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Dimensiones")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        
                        Divider()
                            .background(.secondary)
                        
                        HStack {
                            
                            Button(action: {
                                self.viewSettings.isFullscreen = true
                            }) {
                                HStack {
                                    Image(systemName: "arrow.down.backward.and.arrow.up.forward")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(customFontColor.opacity(0.9), Color.clear, Color.clear)
                                        .animation(.easeInOut(duration: 0.3), value: self.viewSettings.isFullscreen)
                                
                                    Text("Completa")
                                        .font(.system(size: 13))
                                        .foregroundColor(customFontColor.opacity(0.9))
                                }
                                .padding(2.5)
                                .background(self.viewSettings.isFullscreen ? colorPersonalizado : Color.clear) // Azul más claro
                                .cornerRadius(5)
                            }
                            .buttonStyle(.plain)
                            
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isFullscreen) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                        }
                        .padding(.vertical, 2.5)
                        .onChange(of: viewSettings.isFullscreen) {
                            if viewSettings.isFullscreen {
                                self.viewSettings.isBorderless = false
                            }
                        }
                        
                        HStack {
                            
                            HStack {
                                Image(systemName: "arrow.up.right.and.arrow.down.left")
                                    .font(.system(size: iconSize * 0.6))
                                    .transition(.symbolEffect)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(customFontColor.opacity(0.9), Color.clear, Color.clear)
                                    .animation(.easeInOut(duration: 0.3), value: self.viewSettings.isBorderless)
                                
                                Text("Bordes")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                            }
                            .padding(2.5)
                            .background(self.viewSettings.isBorderless ? colorPersonalizado : Color.clear) // Azul más claro
                            .cornerRadius(5)
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isBorderless) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                        }
                        .padding(.vertical, 2.5)
                        .onChange(of: viewSettings.isBorderless) {
                            if viewSettings.isBorderless {
                                self.viewSettings.isFullscreen = false
                            }
                        }
                        
                        Divider()
                            .background(.secondary)
                        
                        Button(action: {
                            self.viewSettings.isDimensionPressed.toggle()
                        }) {
                            HStack {
                                Image("custom-ruler")
                                    .font(.system(size: iconSize * 0.6))
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .transition(.symbolEffect)
                                    .font(Font.title.weight(.regular))
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isDimensionPressed)
                                    .padding(.top, 2)
                                
                                Text("Ajustar margenes")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .bold()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: iconSize * 0.6))
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .transition(.symbolEffect)
                                    .rotationEffect(.degrees(viewSettings.isDimensionPressed ? 90 : 0))
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isDimensionPressed)
                                
                            }
                            .padding(.top, 2.5)
                        }
                        .buttonStyle(.plain)
                        .popover(isPresented: $viewSettings.isDimensionPressed, attachmentAnchor: .point(.leading), arrowEdge: .top) {
                            ZStack {
                                Color(UIColor.systemGray5)
//                                    .blur(radius: 2.5)
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.gray.opacity(0.2))
                                        
                                        VStack(alignment: .center, spacing: 0) {
                                            
                                            HStack {
                                                Text("Ajustar dimensiones")
                                                    .font(.footnote)
                                                    .foregroundColor(customFontColor.opacity(0.9))
                                                Spacer()
                                            }
                                            .padding(.bottom, 2)
                                            Divider()
                                            
                                            HStack {
                                                Image(systemName: "ruler")
                                                    .foregroundColor(.black)
                                                
                                                Text("Automaticamente")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                Toggle(isOn: $viewSettings.isAutomaticScreenAdjusting) {}
                                                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                                    .scaleEffect(0.75) // Reducir tamaño
                                                    .frame(width: 40, height: 20)
                                            }
                                            .padding(.vertical, 8)
                                            
                                            Divider()
                                        
                                        
                                            Text("Margen")
                                                .font(.system(size: 13))
                                                .foregroundColor(.black)
                                            
                                            Slider(value: $viewSettings.margin, in: 0...10, step: 1) // Slider de 0 a 100 con pasos de 1
//                                                                    .padding(.horizontal, 10)
                                            
                                            Text("Ajusta el borde de la pagina.")
                            
                                            Text("Padding")
                                                .font(.system(size: 13))
                                                .foregroundColor(.black)
                                            
                                            Slider(value: $viewSettings.padding, in: 0...10, step: 1) // Slider de 0 a 100 con pasos de 1
//                                                                    .padding(.horizontal, 20)
                                            
                                            Text("Ajusta el borde de la pagina.")
                                        }
                                        .padding(10)
                                    } // FIN ZSTACK
                                }
                                .padding(15)
                            } //ZStack principal
                            .frame(minWidth: 250, maxWidth: .infinity)
                        }
                        
                    }
                    .padding(10)
                } // FIN DIMENSIONES
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Orientación")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        
                        Divider()
                            .background(.secondary)
                        
                        HStack {
                            
                            HStack {
                                    Image(systemName: "arrow.up.and.down")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .symbolRenderingMode(.palette)
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isVertical)
                                
                                Text("Vertical")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                            }
                            .padding(.leading, 3)
                            .padding(2.5)
                            .background(self.viewSettings.isVertical ? colorPersonalizado : Color.clear) // Azul más claro
                            .cornerRadius(5)
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isVertical) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                                .onChange(of: self.viewSettings.isVertical) {
//                                    self.dp.saveKeyToFileInformation(fileURL: self.fileURL, key: "isVertical", value: self.viewSettings.isVertical)
                                    if self.viewSettings.isVertical {
                                        self.viewSettings.isHorizontal = false
                                    }
                                }
                        }
                        .padding(.vertical, 2.5)
                        
                        
                        HStack {
                            
                            HStack {
//                                if viewSettings.isHorizontal {
                                    //                                        Image(systemName: self.opciones1 ? "arrow-left-right-rounded" : "arrow.left.and.right")
                                    Image(systemName: "arrow.left.and.right")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isHorizontal)
//                                }
//                                else {
//                                    Image("custom.arrow.left.and.right.slash")
//                                        .font(.system(size: iconSize * 0.6))
//                                        .transition(.symbolEffect)
//                                        .foregroundColor(.black)
//                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isHorizontal)
//                                }
                                
                                Text("Horizontal")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                            }
                            .padding(2.5)
                            .background(self.viewSettings.isHorizontal ? colorPersonalizado : Color.clear) // Azul más claro
                            .cornerRadius(5)
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isHorizontal) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                                .onChange(of: self.viewSettings.isHorizontal) {
//                                    self.dp.saveKeyToFileInformation(fileURL: self.fileURL, key: "isHorizontal", value: self.viewSettings.isVertical)
                                    if self.viewSettings.isHorizontal {
                                        self.viewSettings.isVertical = false
                                    }
                                }
                        }
                        .padding(.vertical, 2.5)

//                        Divider()
                        
                        HStack {
                            
                            Button(action: {
                                self.viewSettings.isInverted.toggle()
                            }) {
                                HStack {
                                    Image(systemName: self.viewSettings.isInverted ? "arrow.right" : "arrow.left")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(customFontColor.opacity(0.9))
//                                                .animation(.easeInOut(duration: 0.3), value: viewSettings.isInverted)
                                    
                                    Text(self.viewSettings.isInverted ? "Normal" : "Invertir")
                                        .font(.system(size: 13))
                                        .foregroundColor(customFontColor.opacity(0.9))
                                }
                                .padding(2.5)
                                .background(Color.clear) // Azul más claro
                                .cornerRadius(5)
                            }
                        }
                        .padding(.vertical, 2.5)
                        
                        Divider()
                            .background(.secondary)
                        
                    }
                    .padding(10)
                } // FIN ORIENTACION
                
                ZStack { //pASO DE PAGINAS
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Paso de página")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        
                        Divider()
                    .background(.secondary)
                            .background(.secondary)
                        
                        HStack {
                            
                            Button(action: {
                                self.viewSettings.isSinglePage.toggle()
                            }) {
                                HStack {
                                    Image("custom-page")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .symbolRenderingMode(.palette)
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isSinglePage)
                                    
                                    
                                    Text("Paginada")
                                        .font(.system(size: 13))
                                        .foregroundColor(customFontColor.opacity(0.9))
                                }
                                .padding(2.5)
                                .background(self.viewSettings.isSinglePage ? colorPersonalizado : Color.clear) // Azul más claro
                                .cornerRadius(5)
                            }
                            .buttonStyle(.plain)
                            
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isSinglePage) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                        }
                        .padding(.vertical, 2.5)
                        .onChange(of: self.viewSettings.isSinglePage) {
                            if self.viewSettings.isSinglePage {
                                self.viewSettings.isContiousPage = false
                            }
                        }
                        
                        HStack {
                            HStack {
                                HStack(spacing: -2.5) {
                                    Image("custom-page")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .symbolRenderingMode(.palette)
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isContiousPage)
                                        .padding(0)
                                    
                                    Image("custom-page")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .symbolRenderingMode(.palette)
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isContiousPage)
                                        .padding(0)
                                    
                                }
                                
                                Text("Continua")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                            }
                            .padding(2.5)
                            .background(self.viewSettings.isContiousPage ? colorPersonalizado : Color.clear) // Azul más claro
                            .cornerRadius(5)
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isContiousPage) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                        }
                        .padding(.vertical, 2.5)
                        .onChange(of: viewSettings.isContiousPage) {
                            if viewSettings.isContiousPage {
                                self.viewSettings.isSinglePage = false
                            }
                        }
                        .padding(.bottom, 3.5)
                        Divider()
                    .background(.secondary)
                    }
                    .padding(10)
                    }
                        
                        ZStack { //pASO DE PAGINAS
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                            
                            VStack(alignment: .leading, spacing: 0) {

                        HStack {
                            Text("Movimiento para pasar página")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        Divider()
                            .background(.secondary)
                        
                        HStack {
                            
                            HStack {
                                Image("custom-hand-tap")
                                    .font(.system(size: iconSize * 0.6))
                                    .transition(.symbolEffect)
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .symbolRenderingMode(.palette)
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isSingleTap)
                                
                                Text("Toque")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                            }
                            .padding(2.5)
                            .background(self.viewSettings.isSingleTap ? colorPersonalizado : Color.clear)
                            .cornerRadius(5)
                            
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isSingleTap) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                        }
                        .padding(.vertical, 2.5)
//                        .onChange(of: self.viewSettings.isSingleTap) {
//                            if self.viewSettings.isSingleTap {
////                                self.viewSettings.isDelizar = false
//                                self.viewSettings.curlPageEffect = false
//                            }
//                        }
                        
//                                Divider()
//                .background(.secondary)
                        
                        HStack {
                            
                            HStack {
                                Image(systemName: "hand.draw")
                                    .font(.system(size: iconSize * 0.6))
                                    .transition(.symbolEffect)
                                    .foregroundColor(customFontColor.opacity(0.9))
//                                    .symbolRenderingMode(.palette)
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isDelizar)
                                
                                Text("Deslizar")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                            }
                            .padding(2.5)
                            .background(self.viewSettings.isDelizar ? colorPersonalizado : Color.clear)
                            .cornerRadius(5)
                            
                            
                            Spacer()
                            Toggle(isOn: $viewSettings.isDelizar) {}
                                .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                .scaleEffect(0.75) // Reducir tamaño
                                .frame(width: 40, height: 20)
                        }
                        .padding(.vertical, 2.5)
//                        .onChange(of: viewSettings.isDelizar) {
//                            if self.viewSettings.isDelizar {
//                                self.viewSettings.isSingleTap = false
//                                self.viewSettings.curlPageEffect = false
//                            }
//                        }
                        
//                                Divider()
                        
                        if viewSettings.isSinglePage {
                            HStack {
                                
                                HStack {
                                    
                                    Image(systemName: "book.pages")
                                      .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .foregroundColor(customFontColor.opacity(0.9))
    //                                    .symbolRenderingMode(.palette)
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.curlPageEffect)

                                    
                                    Text("Efecto real")
                                        .font(.system(size: 13))
                                        .foregroundColor(customFontColor.opacity(0.9))
                                }
                                .padding(2.5)
                                .background(self.viewSettings.curlPageEffect ? colorPersonalizado : Color.clear)
                                .cornerRadius(5)
                                
                                
                                Spacer()
                                Toggle(isOn: $viewSettings.curlPageEffect) {}
                                    .toggleStyle(SwitchToggleStyle(tint: colorPersonalizado))
                                    .scaleEffect(0.75) // Reducir tamaño
                                    .frame(width: 40, height: 20)
                            }
                            .padding(.vertical, 2.5)
//                            .onChange(of: viewSettings.curlPageEffect) {
//                                if self.viewSettings.curlPageEffect {
//
//                                    self.viewSettings.isSingleTap = false
//                                    self.viewSettings.isDelizar = false
//
//                                }
//                            }
                        }
                                
                        Divider()
                            .background(.secondary)
                        
                                Button(action: {
                                    self.viewSettings.autoScroll.toggle()
                                }) {
                                    HStack {
                                        
                                        Image(self.viewSettings.autoScroll ? "auto-run" : "auto-pause")
                                            .font(.system(size: iconSize * 0.6))
                                            .transition(.symbolEffect)
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(customFontColor.opacity(0.9), colorPersonalizado)
                                        
                                        Text("Automatizar")
                                            .font(.system(size: 13))
                                            .foregroundColor(customFontColor.opacity(0.9))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .font(.system(size: iconSize * 0.6))
                                            .transition(.symbolEffect)
                                            .foregroundColor(self.viewSettings.autoScroll ? colorPersonalizado : customFontColor.opacity(0.9))
//                                                    .symbolEffect(.rotate.byLayer, options: .repeat(.infinity), value: self.viewSettings.autoScroll)
                                        
                                    }
                                }
                                .padding(.vertical, 8)
                                .buttonStyle(.plain)
                        
                        
                        Divider()
                                    .background(.secondary)
                                
                            Button(action: { // MAS EFECTOS
                                viewSettings.isMoreEffectsPressed.toggle()
                            }) {
                                HStack {
                                    Image("effects1")
                                        .font(.system(size: iconSize * 0.6))
                                        .transition(.symbolEffect)
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isMoreEffectsPressed)
                                        .padding(.top, 1.5)
                                        
                                    Text("Más efectos")
                                        .font(.system(size: 13))
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .font(Font.title.weight(.regular))
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.forward")
                                        .font(.system(size: iconSize * 0.6))
                                        .foregroundColor(customFontColor.opacity(0.9))
                                        .transition(.symbolEffect)
                                        .rotationEffect(.degrees(viewSettings.isMoreEffectsPressed ? 90 : 0))
                                        .animation(.easeInOut(duration: 0.3), value: viewSettings.isMoreEffectsPressed)
                                    
                                }
                                .padding(.top, 2.5)
                            }
                            .buttonStyle(.plain)
                            .popover(isPresented: $viewSettings.isMoreEffectsPressed, attachmentAnchor: .point(.leading), arrowEdge: .top) {
                                ZStack {
                                    Color(UIColor.systemGray5)
//                                        .blur(radius: 2.5)
                                    
                                    VStack(alignment: .leading, spacing: 15) {
                                        ZStack {
                                            
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.gray.opacity(0.2))
                                            
                                            VStack(alignment: .center, spacing: 0) {
                                                
                                                HStack {
                                                    Text("Ajustar dimensiones")
                                                        .font(.footnote)
                                                        .foregroundColor(customFontColor.opacity(0.9))
                                                    Spacer()
                                                }
                                                .padding(.bottom, 2)
                                                Divider()
                                                    .background(.secondary)
                                                
                                                HStack {
                                                    Image(systemName: "ruler")
                                                        .foregroundColor(customFontColor.opacity(0.9))
                                                    
                                                    Text("Automaticamente")
                                                        .font(.system(size: 13))
                                                        .foregroundColor(customFontColor.opacity(0.9))
                                                    
                                                    Spacer()
                                                    
//                                                    Toggle(isOn: $isZoomOut1) {}
//                                                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
//                                                        .scaleEffect(0.75) // Reducir tamaño
//                                                        .frame(width: 40, height: 20)
                                                }
                                                .padding(.vertical, 8)
                                                
                                                Divider()
                                                    .background(.secondary)
                                            
                                            
                                                Text("Margen")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(customFontColor.opacity(0.9))
                                                
//                                                Slider(value: $margen, in: 0...10, step: 1) // Slider de 0 a 100 con pasos de 1
////                                                                    .padding(.horizontal, 10)
                                                
                                                Text("Ajusta el borde de la pagina.")
                                
                                                Text("Padding")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(customFontColor.opacity(0.9))
                                                
//                                                Slider(value: $padding, in: 0...10, step: 1) // Slider de 0 a 100 con pasos de 1
////                                                                    .padding(.horizontal, 20)
                                                
                                                Text("Ajusta el borde de la pagina.")
                                            }
                                            .padding(10)
                                        } // FIN ZSTACK
                                    }
                                    .padding(15)
                                } //ZStack principal
                                .frame(minWidth: 250, maxWidth: .infinity)
                            } //FIN POPOVER MAS EFECTOS
                        
                        
                    } //FIN VSTACK PASO DE PAGINA
                    .padding(10)
                    

                    
                } //FIN PASO DE PAGINA
                    
                
                ZStack { //ZOOM
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Zoom")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        Divider()
                            .background(.secondary)
                        
                        Button(action: {
                            self.viewSettings.isZoom.toggle()
                        }) {
                            HStack {
                                Image("custom-page-lupa")
                                    .font(.system(size: iconSize * 0.6))
                                    .transition(.symbolEffect)
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isZoom)
                                    .padding(.top, 1)
                                
                                Text("Ajustar zoom")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .font(Font.title.weight(.regular))
                                    .bold()
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: iconSize * 0.6))
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .transition(.symbolEffect)
                                    .rotationEffect(.degrees(viewSettings.isZoom ? 90 : 0))
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isZoom)
                            }
                            .padding(.top, 2.5)
                        }
                        .buttonStyle(.plain)
                        .popover(isPresented: $viewSettings.isZoom) {
                            ZStack {
                                Color(UIColor.systemGray5)
//                                    .blur(radius: 2.5)
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.gray.opacity(0.2))
                                        
                                        VStack(alignment: .center, spacing: 0) {
                                            HStack {
                                                
                                                Text("Zoomout")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(customFontColor.opacity(0.9))
                                                
                                                Spacer()
                                                Toggle(isOn: $viewSettings.isZoomOut) {}
                                                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                                    .scaleEffect(0.75) // Reducir tamaño
                                                    .frame(width: 40, height: 20)
                                                
                                            }
                                            
                                            HStack {
                                                
                                                Text("Zoom individual")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(customFontColor.opacity(0.9))
                                                Spacer()
                                                Toggle(isOn: $viewSettings.isIndividualZoom) {}
                                                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                                    .scaleEffect(0.75) // Reducir tamaño
                                                    .frame(width: 40, height: 20)
                                                
                                            }
                                            
                                            HStack {
                                                
                                                Text("Centrar zoom")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(customFontColor.opacity(0.9))
                                                Spacer()
                                                Toggle(isOn: $viewSettings.isZoomCentered) {}
                                                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                                    .scaleEffect(0.75) // Reducir tamaño
                                                    .frame(width: 40, height: 20)
                                                
                                            }
                                        }
                                        .padding(10)
                                    }
                                }
                                .padding(15)
                            }
                            .frame(minWidth: 250, maxWidth: .infinity)
                        }
                    }
                    .padding(10)
                }
                
                
                ZStack { //COLORES
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                    
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Colores")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.bottom, 2)
                    Divider()
                        .background(.secondary)
                    
                    VStack {
                        Button(action: {
                            viewSettings.isColorPressed.toggle()
                        }) {
                            HStack {
                                Image("aqi")
                                    .font(.system(size: iconSize * 0.6))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.red, .cyan, .green)
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isColorPressed)
                                Text("Color de fondo")
                                    .font(.system(size: 13))
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .bold()
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: iconSize * 0.6))
                                    .foregroundColor(customFontColor.opacity(0.9))
                                    .transition(.symbolEffect)
                                    .rotationEffect(.degrees(viewSettings.isColorPressed ? 90 : 0))
                                    .animation(.easeInOut(duration: 0.3), value: viewSettings.isColorPressed)
                            }
                            .padding(.vertical, 2.5)
                        }
                        .padding(.top, 2.5)
                        .buttonStyle(.plain)
                    }
                    .popover(isPresented: $viewSettings.isColorPressed, attachmentAnchor: .point(.leading), arrowEdge: .top) {
                        ZStack {
                            Color(UIColor.systemGray5)
//                                .blur(radius: 2.5)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                ZStack {
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.2))
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Text("Colores recientes")
                                                .font(.footnote)
                                                .foregroundColor(customFontColor.opacity(0.9))
                                            Spacer()
                                        }
                                        
                                        Divider()
                                            .background(.secondary)
                                        
                                        HStack {
                                            ForEach(colors, id: \.self) { color in
                                                Button(action: {
                                                    viewSettings.selectedBackgroundColor = color
                                                }) {
                                                    Circle()
                                                        .fill(color)
                                                        .font(.system(size: iconSize * 0.6))
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.white, lineWidth: 1.5)
                                                            //                                                                    .stroke(appState.currentColor == color ? (appState.currentTheme == .dark ? Color.white : customFontColor.opacity(0.9)) : Color.clear, lineWidth: 1.5)
                                                        )
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.vertical, 2.5)
                                        ColorPicker("Paleta de colores", selection: $viewSettings.selectedBackgroundColor)
                                            .padding(.trailing, -4)
                                            .font(.system(size: 13))
                                            .foregroundColor(customFontColor.opacity(0.9))
                                            .padding(.vertical, 2.5)
                                        Divider()
                                    }
                                    .padding(10)
                                }
                            }
                            .padding(15)
                        } //ZStack dentro color reciente palte
                        .frame(minWidth: 250, maxWidth: .infinity)
                    }
                    }
                    .padding(10)
                    
                } //FIN COLROES
                
                HStack(alignment: .center, spacing: 10) {
                    
                    Button(action: {
                        
//                        if let file = elementModel.selectedElement as? File {
//                            let fileURL = file.url
//                            print("Reseteando a los ajustes de la coleccion")
//                            self.dp.saveKeyToFileInformation(fileURL: fileURL, key: customKey, value: false)
//                            
//                            let parentURL = fileURL.deletingLastPathComponent()
//                            if let parentDirInstance = FileSystem.getFileSystemInstance.directoryOnlyCache[parentURL] {
//                                if let parentModel = parentDirInstance.readSettingsModel {
//                                    self.viewSettings.resetParentSettings(parentModel.toDictionaryOnlySettings())
//                                }
//                            }
//                        } else {
//                            print("Imposible resetear los ajuste mala URL")
//                        }
                        
                        
                    }) {
                        Text("Resetar")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal, 12)
                    .background(.red)
                    .cornerRadius(10)
                    
                    Button(action: {
                        
//                        if let file = elementModel.selectedElement as? File {
//                            
//                            let fileURL = file.url
//                            
//                            self.dp.saveKeyToFileInformation(fileURL: fileURL, key: customKey, value: true)
//                            self.dp.saveKeyToFileInformation(fileURL: fileURL, key: customKey + "Values", value: viewSettings.toDictionary())
//                            
//                            self.dp.printJSONData()
//                            
////                            showPopover = false
//                            isPreviewPressed = false
//                        }
//                        else {
//                            print("MAL LA URL PARA EL ARCHIVO Y NO SE PUEDE GUARDAR UN SETTING INDIVIDUAL")
//                        }
                        
                    }) {
                        Text("Guardar")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal, 12)
                    .background(.green)
                    .cornerRadius(10)
                    
                }
                
                
            }
//            .padding([.leading, .trailing, .bottom], 10)
            .padding(10)

        } // FIN Zstack
        
    }
    
}
