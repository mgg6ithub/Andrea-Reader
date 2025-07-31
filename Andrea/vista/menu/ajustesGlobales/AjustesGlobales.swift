//
//  AjustesGlobales.swift
//  Andrea
//
//  Created by mgg on 30/5/25.
//

import SwiftUI

struct AjustesGlobales_Previews: PreviewProvider {
    static var previews: some View {
        // Instancias de ejemplo para los objetos de entorno
        let appEstadoPreview = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
        let menuEstadoPreview = MenuEstado() // Reemplaza con la inicialización adecuada

        return AjustesGlobales()
            .environmentObject(appEstadoPreview)
            .environmentObject(menuEstadoPreview)
    }
}



struct AjustesGlobales: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    private var padding: CGFloat = 20
    
    @State private var isPressed: Bool = false
    @State private var selectedSection: String? = nil
    @State private var isUserInteracting = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var sectionOffsets: [String: CGFloat] = [:]
    
    @State private var showEmptyState = false // Para controlar la animación
    
    var sections: [String] { menuEstado.sections }

    func updateActiveSection() {
        guard !isUserInteracting else { return }

        let screenCenter = UIScreen.main.bounds.height / 2

        let closest = sectionOffsets.min(by: {
            abs($0.value - screenCenter) < abs($1.value - screenCenter)
        })

        if let closestSection = closest?.key, selectedSection != closestSection {
            selectedSection = closestSection
        }
    }

    private let paddingHorizontal: CGFloat = ConstantesPorDefecto().horizontalPadding // 15
    private var paddingVertical: CGFloat  { ConstantesPorDefecto().verticalPadding  * appEstado.constantes.scaleFactor}// 20
    
    var body: some View {
            
            VStack(alignment: .center, spacing: 0) {
                    ZStack(alignment: .leading) {
                        // Imagen alineada a la izquierda
                        Image("book1")
                            .resizable()
                            .frame(width: 160, height: 160)
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(showEmptyState ? 1 : 0.9)
                            .opacity(showEmptyState ? 1 : 0)
                            .offset(y: showEmptyState ? 0 : 20)
                            .animation(.interpolatingSpring(stiffness: 100, damping: 10).delay(0.1), value: showEmptyState)
                            .padding(.leading, 0)
                        
                        // Texto centrado en pantalla, por encima de la imagen
                        HStack {
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 10) {
                                // Título centrado
                                Text("Ajustes generales")
                                    .font(.system(size: appEstado.constantes.titleSize * 1.7, weight: .bold))
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, paddingHorizontal)
                                    .offset(x: 35)
                                
                                Text("Aplica ajustes globales, personalizando la apariencia y funcionalidad de la aplicación. Ajusta el tema, los colores y modifica las opciones según tus preferencias.")
                                    .font(.system(size: appEstado.constantes.subTitleSize))
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .frame(width: 380 * appEstado.constantes.scaleFactor)
                                    .padding(.horizontal, paddingHorizontal)
                                    .offset(x: 35)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.top, paddingVertical)
                    .frame(maxWidth: .infinity, minHeight: 140) // Altura mínima para que imagen y texto se alineen bien
                    .onAppear { showEmptyState = true }
                    .onDisappear { showEmptyState = false }
                
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 2.5)
                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.vertical, 10)
                
                GeometryReader { hStackGeo in
                    HStack(spacing: 0) {
                        VStack {
                            Spacer()
                            
                            GeometryReader { geo in
                                let totalHeight = geo.size.height
                                let distPoints = totalHeight / CGFloat(sections.count) - 20
                                let totalHeightForLine = (distPoints + 17.5) * CGFloat(sections.count - 1)
                                
                                ZStack(alignment: .trailing) {
                                    VStack(alignment: .center, spacing: 0) {
                                        ForEach(Array(zip(sections.indices, sections)), id: \.1) { index, section in
                                            Button(action: {
                                                isPressed = true
                                                withAnimation(.interpolatingSpring(stiffness: 70, damping: 12)) {
                                                    selectedSection = sections[index]
                                                    isUserInteracting = true
                                                    scrollProxy?.scrollTo(sections[index], anchor: .top)
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Ajusta el tiempo según la duración de la animación
                                                    isUserInteracting = false
                                                }
                                            }) {//
                                                Punto(index: index, section: section, selectedSection: $selectedSection, isPressed: $isPressed, distPoints: distPoints)
                                            } //FIN BOTON DE DENTRO
                                            .buttonStyle(PlainButtonStyle())
                                        } //FIN FOREACH
                                    }
                                    .zIndex(1)
                                    
                                    Rectangle()
                                       .fill(Color.gray.opacity(0.5))
                                       .frame(width: 1, height: totalHeightForLine, alignment: .trailing)
                                       .zIndex(0)
                                    
                                } //FIN ZSTACK
                                .frame(maxHeight: .infinity)
                                
                                
                            } //gin geometry geo
                            .frame(maxHeight: .infinity)
                        } //fin vstack
                        .frame(maxHeight: .infinity)
                        .frame(maxWidth: 68)
                        
                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(alignment: .center, spacing: 0) {
                                    ForEach(sections, id: \.self) { section in
                                        VStack {
                                            
                                            GeometryReader { geo in
                                                Color.clear
                                                    .preference(key: ViewOffsetKey.self, value: geo.frame(in: .global).minY)
                                            }
                                            .frame(height: 0)
                                            
                                            Group {
                                                switch section {
                                                    case "TemaPrincipal":
                                                        AjustesTema(isSection: selectedSection == section)
                                                    
                                                        Rectangle()
                                                            .fill(Color.gray.opacity(0.5))
                                                            .frame(height: 1.1)
                                                            .padding(.horizontal, appEstado.resolucionLogica == .small ? 0 : paddingHorizontal * 2)
                                                    
                                                    case "AjustesMenu":
                                                        AjustesMenu()
                                                    
                                                case "SistemaArchivos":
                                                        AjustesSistemaColecciones(isSection: selectedSection == section)
                                                    
                                                    default:
                                                        EmptyView()
                                                }
                                            }
                                            .id(section)
                                        } //fin vstack dentro dforeach
                                        .background(GeometryReader { geo in
                                            Color.clear
                                                .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                                                    DispatchQueue.main.async {
                                                        
                                                        sectionOffsets[section] = newValue
                                                        if !isUserInteracting {
                                                            updateActiveSection()
                                                        }
                                                        
                                                        if !isUserInteracting, newValue > 100 {
                                                            selectedSection = sections.first
                                                        }
                                                    }
                                                }
                                        })
                                    }
                                }
                                
                            }
                            .scrollTargetLayout()
                            .scrollIndicators(.hidden)
                            .frame(maxHeight: .infinity)
                            .onAppear {
                                self.scrollProxy = proxy
                                if selectedSection == nil { // Si no hay sección seleccionada, selecciona la primera
                                    selectedSection = sections.first
                                    
                                }
                            }
                        }
                        
                    }//gin hstack spacing 0
                    .frame(height: hStackGeo.size.height)
                } //fin geometry hStackGeo
                
            } //FIN VSTACK GENERAL
            .padding(.horizontal, paddingHorizontal + 10) // 25
            .frame(
                maxHeight: .infinity,
                alignment: .center
            )
            .background(appEstado.temaActual.backgroundColor)
            .animation(.easeInOut, value: appEstado.temaActual)
    }
    
}



struct AjustesGlobalesWrapper: View {
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado

    var body: some View {
        AjustesGlobales()
            // 🚫 QUITA ESTA LÍNEA: .id(appEstado.temaActual.rawValue)
            .environmentObject(appEstado)
            .environmentObject(menuEstado)
    }
}


struct Punto: View {
    
    @EnvironmentObject var appEstado: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    let index: Int
    let section: String
    @Binding var selectedSection: String?
    @Binding var isPressed: Bool
    let distPoints: CGFloat
    
    var sections: [String] { menuEstado.sections }
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: ConstantesPorDefecto().paddingCorto - 2) {
                Text(menuEstado.sectionTitle(section))
                    .font(.system(size: appEstado.constantes.smallTitleSize))
                    .foregroundColor(selectedSection == section ? appEstado.temaActual.textColor : appEstado.temaActual.secondaryText)
                    .frame(width: (menuEstado.anchoTexto - 10) * appEstado.constantes.scaleFactor, alignment: .leading)
                
                Circle()
                    .fill(selectedSection == section ? appEstado.constantes.iconColor : .gray)
                    .shadow(
                        color: selectedSection == section ? appEstado.constantes.iconColor : .gray,
                        radius: ((selectedSection == section ? 6 : 0))
                    )
                    .frame(width: 15, height: 15)
                    .overlay( //ANIMACION AVANZADA AL HACER CLICK
                        RoundedRectangle(cornerRadius: 10)
                            .stroke((selectedSection == section && isPressed) ? appEstado.constantes.iconColor : Color.clear, lineWidth: 4)
                                    .animation(.easeInOut(duration: 0.3), value: isPressed)
                            )
                    .shadow(color: (selectedSection == section && isPressed) ? appEstado.constantes.iconColor.opacity(0.3) : .clear, radius: (selectedSection == section && isPressed) ? 10 : 0, x: 0, y: (selectedSection == section && isPressed) ? 5 : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isPressed)
                    .frame(alignment: .trailing)
            }
            
            if index < sections.count - 1 {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 2, height: distPoints, alignment: .trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(maxWidth: (menuEstado.anchoIndicePuntos) * appEstado.constantes.scaleFactor)
        
        
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
