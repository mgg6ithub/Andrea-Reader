
import SwiftUI

//struct AndreaAppView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Instancias de ejemplo para los objetos de entorno
////        let ap = AppEstado(screenWidth: 375, screenHeight: 667) // > iphone 8
////        let ap = AppEstado(screenWidth: 393, screenHeight: 852) //iphone 15
//        let ap = AppEstado(screenWidth: 744, screenHeight: 1133) //ipad mini 6 gen
////        let ap = AppEstado(screenWidth: 820, screenHeight: 1180) //ipad 10
////        let ap = AppEstado(screenWidth: 834, screenHeight: 1194) //ipad Pro 11
////        let ap = AppEstado(screenWidth: 1024, screenHeight: 1366) //ipad Pro 12.92"
//        let me = MenuEstado() // Reemplaza con inicialización adecuada
//        let pc = PilaColecciones.preview
//
//        return AndreaAppView()
//            .environmentObject(ap)
//            .environmentObject(me)
//            .environmentObject(pc)
//    }
//}

struct AjustesGlobales: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    private var padding: CGFloat = 20

    @State private var isPressed: Bool = false
    @State private var selectedSection: String? = nil
    @State private var isUserInteracting = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var sectionOffsets: [String: CGFloat] = [:]
    @State private var haHechoScroll: Bool = false
    @State private var scrollInicial: CGFloat? = nil
    
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
    private var paddingVertical: CGFloat  { ConstantesPorDefecto().verticalPadding  * ap.constantes.scaleFactor}// 20
    
    var constanteResizable: CGFloat {
        if ap.resolucionLogica == .small {
            return ap.constantes.scaleFactor * 0.9
        } else {
            return ap.constantes.scaleFactor
        }
    }
    
    var body: some View {
            
            VStack(alignment: .center, spacing: 0) {
//                    ZStack(alignment: .leading) {
//                        // Imagen alineada a la izquierda
//                        Image("book4")
//                            .resizable()
//                            .frame(width: 160 * constanteResizable, height: 160 * constanteResizable)
//                            .aspectRatio(contentMode: .fit)
//                            .scaleEffect(showEmptyState ? 1 : 0.9)
//                            .opacity(showEmptyState ? 1 : 0)
//                            .offset(y: showEmptyState ? 0 : 20)
//                            .animation(.interpolatingSpring(stiffness: 100, damping: 10).delay(0.1), value: showEmptyState)
//                            .padding(.leading, 0)
//                        
//                        // Texto centrado en pantalla, por encima de la imagen
//                        HStack {
//                            Spacer()
//                            
//                            VStack(alignment: .center, spacing: 10) {
//                                // Título centrado
//                                Text("Ajustes generales")
//                                    .font(.system(size: appEstado.constantes.titleSize * 1.7, weight: .bold))
//                                    .bold()
//                                    .multilineTextAlignment(.center)
//                                    .padding(.horizontal, paddingHorizontal)
//                                    .offset(x: 30)
//                                
//                                Text("Aplica ajustes globales, personalizando la apariencia y funcionalidad de la aplicación. Ajusta el tema, los colores y modifica las opciones según tus preferencias.")
//                                    .font(.system(size: appEstado.constantes.subTitleSize))
//                                    .bold()
//                                    .multilineTextAlignment(.center)
//                                    .frame(width: 380 * appEstado.constantes.scaleFactor)
//                                    .padding(.horizontal, paddingHorizontal)
//                                    .padding(.bottom, 10)
//                                    .offset(x: 30)
//                            }
//                            
//                            Spacer()
//                        }
//                    }
//                    .padding(.top, paddingVertical)
//                    .frame(maxWidth: .infinity, minHeight: 140) // Altura mínima para que imagen y texto se alineen bien
//                    .onAppear { showEmptyState = true }
//                    .onDisappear { showEmptyState = false }
                
                Text("Ajustes generales")
                    .font(.system(size: ap.constantes.titleSize * 1.7, weight: .bold))
                    .foregroundColor(ap.temaActual.colorContrario)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, paddingHorizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                if ap.resolucionLogica == .small {
                    IndicesHorizontal(sections: sections, selectedSection: $selectedSection, scrollProxy: $scrollProxy)
                        .padding(.bottom, 10)
                }
                
                if haHechoScroll {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 2.5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                GeometryReader { hStackGeo in
                    if ap.resolucionLogica == .medium || ap.resolucionLogica == .big {
                        HStack(spacing: 0) { //Cambiar por VStack si resolucionLogica es .small y el menu de los indices por el horizontal para ponerlo encima
                            IndicesVertical(isPressed: $isPressed, selectedSection: $selectedSection, isUserInteracting: $isUserInteracting, scrollProxy: $scrollProxy, sections: sections)
                            ContenidoAjustes(sections: sections, selectedSection: $selectedSection, paddingHorizontal: paddingHorizontal, sectionOffsets: $sectionOffsets, isUserInteracting: $isUserInteracting, scrollProxy: $scrollProxy, haHechoScroll: $haHechoScroll, scrollInicial: $scrollInicial)
                        }//gin hstack spacing 0
                        .frame(height: hStackGeo.size.height)
                    } else if ap.resolucionLogica == .small {
                        ContenidoAjustes(sections: sections, selectedSection: $selectedSection, paddingHorizontal: paddingHorizontal, sectionOffsets: $sectionOffsets, isUserInteracting: $isUserInteracting, scrollProxy: $scrollProxy, haHechoScroll: $haHechoScroll, scrollInicial: $scrollInicial)
                    }
                } //fin geometry hStackGeo
                
            } //FIN VSTACK GENERAL
            .padding(.horizontal, paddingHorizontal + 10) // 25
            .frame(
                maxHeight: .infinity,
                alignment: .center
            )
            .background(ap.temaActual.backgroundColor)
            .animation(.easeInOut, value: ap.temaActual)
    }
    
}

struct ContenidoAjustes: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var sections: [String]
    @Binding var selectedSection: String?
    let paddingHorizontal: CGFloat
    
    @Binding var sectionOffsets: [String: CGFloat]
    @Binding var isUserInteracting: Bool
    @Binding var scrollProxy: ScrollViewProxy?
    @Binding var haHechoScroll: Bool
    @Binding var scrollInicial: CGFloat?

    
    var constanteResizable: CGFloat {
        if ap.resolucionLogica == .small {
            return ap.constantes.scaleFactor * 0.8
        } else {
            return ap.constantes.scaleFactor
        }
    }
    
    @State private var showEmptyState = false
    @State private var isScrollInitialized = false
    private var paddingVertical: CGFloat { ConstantesPorDefecto().verticalPadding * ap.constantes.scaleFactor }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack(spacing: 0) {
                        
                        Image("book4")
                            .resizable()
                            .frame(width: 160 * constanteResizable, height: 160 * constanteResizable)
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(showEmptyState ? 1 : 0.9)
                            .opacity(showEmptyState ? 1 : 0)
                            .offset(y: showEmptyState ? 0 : 20)
                            .animation(.interpolatingSpring(stiffness: 100, damping: 10).delay(0.1), value: showEmptyState)
                        
                        Text("Aplica ajustes globales, personalizando la apariencia y funcionalidad de la aplicación. Ajusta el tema, los colores y modifica las opciones según tus preferencias.")
                            .font(.system(size: ap.constantes.titleSize))
                            .multilineTextAlignment(.center)
                        
                    }
                    .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2)
                    // 🎨 ANIMACIÓN MODERNA DE SCROLL
                    .opacity(haHechoScroll ? 0.0 : 1.0)
                    .scaleEffect(haHechoScroll ? 0.95 : 1.0)
                    .offset(y: haHechoScroll ? -10 : 0)
                    .blur(radius: haHechoScroll ? 2 : 0)
                    .animation(.easeInOut(duration: 0.4), value: haHechoScroll)
                    .id("top")
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    // Delay mínimo para asegurar que la vista esté completamente cargada
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        scrollInicial = geo.frame(in: .global).minY
                                        haHechoScroll = false
                                        isScrollInitialized = true
                                        print("🔵 Scroll inicial establecido: \(scrollInicial ?? 0)")
                                    }
                                }
                                .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                                    handleScrollChange(newY: newValue)
                                }
                        }
                    )
                    .onAppear {
                        showEmptyState = true
                    }
                    .onDisappear {
                        showEmptyState = false
                        isScrollInitialized = false
                    }
                    
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
                                    
                                        DividerPersonalizado(paddingHorizontal: paddingHorizontal)
                                    
                                    case "SistemaArchivos":
                                            AjustesSistemaColecciones(isSection: selectedSection == section)
                                        
                                        DividerPersonalizado(paddingHorizontal: paddingHorizontal)
                                        
                                    case "Rendimiento":
                                        Rendimiento(isSection: selectedSection == section)
                                        
                                        DividerPersonalizado(paddingHorizontal: paddingHorizontal)
                                        
                                    case "AjustesMenu":
                                        AjustesMenu(isSection: selectedSection == section)
                                    
                                    case "AjustesHistorial":
                                        AjustesHistorial()
                                    
                                    default:
                                        EmptyView()
                                }
                            }
                            .id(section)
                        }
                        .background(GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                                    sectionOffsets[section] = newValue
                                    if !isUserInteracting {
                                        updateActiveSection()
                                    }
                                    
                                    if !isUserInteracting, newValue > 100 {
                                        selectedSection = sections.first
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
                if selectedSection == nil {
                    selectedSection = sections.first
                }
            }
        }
    }
    
    // Función privada para manejar los cambios de scroll de forma más eficiente
    private func handleScrollChange(newY: CGFloat) {
        // Solo procesar si la inicialización está completa
        guard isScrollInitialized, let inicial = scrollInicial else {
            print("⚠️ Scroll no inicializado aún")
            return
        }
        
        let diferencia = inicial - newY // Cambiamos el abs() para detectar la dirección
        let tolerancia: CGFloat = 20
        
        // Si el valor actual es mayor que el inicial + tolerancia, hay scroll hacia abajo
        let hayScrollHaciaAbajo = diferencia > tolerancia
        
        // Solo actualizamos si hay un cambio real de estado
        if hayScrollHaciaAbajo != haHechoScroll {
            haHechoScroll = hayScrollHaciaAbajo
            
            print(hayScrollHaciaAbajo ? "🔴 SCROLL HACIA ABAJO - OCULTAR CONTENIDO" : "🟢 ARRIBA DEL TODO - MOSTRAR CONTENIDO")
            print("   Inicial: \(inicial), Actual: \(newY), Diferencia: \(diferencia)")
        }
    }
    
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
}

struct IndicesHorizontal: View {
    
    @EnvironmentObject var menuEstado: MenuEstado
    
    var sections: [String]
    
    @Binding var selectedSection: String?
    @Binding var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sections, id: \.self) { section in
                        Button(action: {
                            selectedSection = section
                            withAnimation(.interpolatingSpring(stiffness: 70, damping: 12)) {
                                if section == sections.first {
                                    scrollProxy?.scrollTo("top", anchor: .top)
                                } else {
                                    scrollProxy?.scrollTo(section, anchor: .top)
                                }
                            }
                        }) {
                            Text(menuEstado.sectionTitle(section))
                                .font(.system(size: 14))
                                .foregroundColor(selectedSection == section ? .blue : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedSection == section ? Color.blue.opacity(0.2) : Color.clear)
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
    }
    
}

struct IndicesVertical: View {
    
    @EnvironmentObject var menuEstado: MenuEstado
    
    @Binding var isPressed: Bool
    @Binding var selectedSection: String?
    @Binding var isUserInteracting: Bool
    @Binding var scrollProxy: ScrollViewProxy?
    
    var sections: [String]
    
    
    var body: some View {
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
                                    if section == sections.first {
                                        print("Primera seccion scroll hasyta arriba")
                                        scrollProxy?.scrollTo("top", anchor: .top)
                                    } else {
                                        print("Aqui")
                                        scrollProxy?.scrollTo(section, anchor: .top)
                                    }
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
    }
    
}



struct DividerPersonalizado: View {
    
    @EnvironmentObject var ap: AppEstado
    var paddingHorizontal: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(height: 1.1)
            .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2)
            .padding(.horizontal, ap.resolucionLogica == .small ? 0 : paddingHorizontal * 2) // 40
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
                    .frame(width: (menuEstado.anchoTexto * appEstado.constantes.scaleFactor) - 10, alignment: .leading)
                
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
        .frame(maxWidth: (menuEstado.anchoIndicePuntos * appEstado.constantes.scaleFactor) - 1.5)
        
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
