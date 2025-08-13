import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func onScrollOffsetChange(_ action: @escaping (CGFloat) -> Void) -> some View {
        self.background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .named("scroll")).minY)
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: action)
    }
}


struct AnimatedHeaderScrollView<Header: View, Content: View>: View {
    
    var minimumH: CGFloat
    var maximumH: CGFloat
    var ignoreSafeAreaTop: Bool = true
    var isSticky: Bool = false
    
    @ViewBuilder var header: (CGFloat, EdgeInsets) -> Header
    @ViewBuilder var content: Content
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let safeArea = ignoreSafeAreaTop ? $0.safeAreaInsets : .init()
            
            ScrollView(.vertical) {
                // 📌 Elemento invisible para medir el scroll
                Color.clear
                    .frame(height: 0)
                    .onScrollOffsetChange { newValue in
                        offsetY = -newValue
                    }
                
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        content
                    } header: {
                        GeometryReader { _ in
                            let progress: CGFloat = min(max(offsetY / (maximumH - minimumH), 0), 1)
                            let resizedH = (maximumH + safeArea.top) - (maximumH - minimumH) * progress
                            
                            header(progress, safeArea)
                                .frame(height: resizedH, alignment: .bottom)
                                .offset(y: isSticky ? (offsetY < 0 ? offsetY : 0) : 0)
                        }
                        .frame(height: maximumH + safeArea.top)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .ignoresSafeArea(.container, edges: ignoreSafeAreaTop ? [.top] : [])
        }
    }
}

struct ExampleView: View {
    
    @State private var isSticky: Bool = false
    
    var body: some View {
        AnimatedHeaderScrollView(minimumH: 100, maximumH: 250, ignoreSafeAreaTop: false, isSticky: true) { progress, safeArea in
            
            RoundedRectangle(cornerRadius: 30)
                .fill(.indigo.gradient)
                .overlay(content: {
                    Text( "\(progress)")
                        .foregroundStyle(.white)
                })
                .padding(15)
                .padding(.top, 10)
            
        } content: {
            VStack(spacing: 12) {
                
                Toggle("Sticky header", isOn: $isSticky)
                    .padding(15)
                    .background(.gray, in: .rect(cornerRadius: 15))
                
                DummyContent()
            }
            .padding(15)
        }
    }
    
    @ViewBuilder
    func DummyContent() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
            ForEach(1...50, id: \.self) { index in
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 160)
            }
        }
    }
    
}

//#Preview {
//    ExampleView()
//}
