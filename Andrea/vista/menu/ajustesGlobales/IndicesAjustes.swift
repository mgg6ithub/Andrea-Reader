

import SwiftUI

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
