
import SwiftUI

struct PopOutCollectionsView<Header: View, Content: View>: View {
    
//    var totalElements: Int
    
    @ViewBuilder var header: (Bool) -> Header
    @ViewBuilder var content: (Bool, @escaping () -> Void) -> Content

    @State private var sourceRect: CGRect = .zero
    @State private var showFullScreenCover: Bool = false
    @State private var animatedView: Bool = false
    @State private var haptics: Bool = false
    
    @State private var isRightSide: Bool = false
    
    var body: some View {
        
        header(animatedView)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onGeometryChange1 { newValue in
                sourceRect = newValue
                let screenWidth = UIScreen.main.bounds.width
                isRightSide = newValue.midX > screenWidth / 2
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
            .opacity(showFullScreenCover ? 0 : 1)
            .onTapGesture {
                haptics.toggle()
                toggleFullScreenCover()
            }
            .fullScreenCover(isPresented: $showFullScreenCover) {
                // Contenido para la pantalla completa
                PopOutListOverlay(
                   sourceRect: $sourceRect,
                   animateView: $animatedView,
                   header: header,
                   content: { isExpandable, cerrarMenu in
                       content(isExpandable, cerrarMenu)
                   },
                   isRightSide: isRightSide
               ) {
                   cerrarMenu()
               }

            }
            .padding(.horizontal, animatedView ? 5 : 0)
            .sensoryFeedback(.impact, trigger: haptics)
    }
    
    private func toggleFullScreenCover() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        
        withTransaction(transaction) {
            showFullScreenCover.toggle()
        }
    }
    
    private func cerrarMenu() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animatedView = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showFullScreenCover = false
        }
    }

}

extension View {
    func solidBackground1(color: Color, opacity: CGFloat) -> some View {
        Rectangle()
            .fill(.background)
            .overlay {
                Rectangle()
                    .fill(color.opacity(opacity))
            }
        
    }
}


fileprivate struct PopOutListOverlay<Header: View, Content: View>: View {
    
    @EnvironmentObject var ap: AppEstado
    
    var totalElements: Int {
        SistemaArchivos.sa.cacheColecciones.count - 1
    }
    private let alturaBase: Int = 109
    
    @Binding var sourceRect: CGRect
    @Binding var animateView: Bool
    @ViewBuilder var header: (Bool) -> Header
    @ViewBuilder var content: (Bool, @escaping () -> Void) -> Content
    var isRightSide: Bool

    var dismissView: () -> ()
    
    @State private var edgeInsets: EdgeInsets = .init()
    @State private var scale: CGFloat = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 15) {
                if isRightSide {
                    Spacer()
                    if animateView {
                        Text("Historial de acciones")
                            .font(.system(size: 20))
                            .bold()
                            .frame(alignment: .bottom)
                    }
                    
                    header(animateView)
                } else {
                    
                    header(animateView)
                    
                    if animateView {
                        Text("Colecciones")
                            .font(.system(size: 20))
                            .bold()
                            .frame(alignment: .bottom)
                    }
                }
            }
            .padding(.bottom, 5)
            .padding([.leading, .trailing, .top], animateView ? 10 : 0)
            
            Rectangle()
                .fill(ap.temaActual.colorContrario) // O ap.temaActual.separatorColor
                .frame(height: 1.5)
                .padding(.horizontal, 10)
            
            if animateView {
                content(animateView, dismissView)
                    .transition(.blurReplace)
            }
            
        }
//        .frame(width: animateView ? 300 : nil, height: animateView ? CGFloat((totalElements * 60) + alturaBase) : 0)
        .frame(width: animateView ? 300 : nil)
        .background(
            ap.temaActual.backgroundColor
                .mask(
                    RoundedRectangle(cornerRadius: animateView ? 20 : 10)
                )
        )
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: animateView ? 20 : 10))
        .frame(width: animateView ? nil : sourceRect.width, height: animateView ? nil : sourceRect.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isRightSide ? .topTrailing : .topLeading)
        .scaleEffect(scale, anchor: .topLeading)
        .animation(.easeInOut(duration: 0.3), value: scale)
        // --- controla el desplazamiento ---
        .offset(x: animateView ? 0 : (isRightSide ? sourceRect.maxX - 300 : sourceRect.minX),
                y: animateView ? 0 : sourceRect.minY)
        .padding(.top, animateView ? 25 : 0)
        .padding(isRightSide ? .trailing : .leading, animateView ? 20 : 0)
        // ---
        .animation(.easeInOut(duration: 0.3), value: animateView)
        .ignoresSafeArea()
        .presentationBackground {
            GeometryReader { geo in
                
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .opacity(animateView ? 0.65 : 0)
                        .animation(.easeInOut(duration: 0.3), value: animateView)
                        .onTapGesture {
                            dismissView()
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let height = value.translation.height
                                    let scale = height / geo.size.height
                                    let applyingRatio: CGFloat = 0.1
                                    self.scale = 1 + (scale * applyingRatio)
                                }
                                .onEnded { value in
                                    
                                    _ = value.velocity.height / 5
                                    let height = value.translation.height
                                    let scale = height / geo.size.height
                                    let _: CGFloat = 0.1
                                    
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        self.scale = 1
                                    }
                                    
                                    if -scale > 0.5 {
                                        dismissView()
                                    }
                                    
                                }
                        )
                }
            }
        }
        .captureSafeAreaInsets1 { newValue in
            guard !animateView else { return }
            edgeInsets = newValue
            Task { @MainActor in
                withAnimation(.easeInOut(duration: 0.4)) {
                    animateView = true
                }
            }
        }
    }
    
}

extension View {
    func captureSafeAreaInsets1(action: @escaping (EdgeInsets) -> Void) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        let safeAreaInsets = geometry.safeAreaInsets
                        action(safeAreaInsets)
                    }
            }
        )
    }
}


extension View {
    func onGeometryChange1(
        action: @escaping (CGRect) -> Void
    ) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: FramePreferenceKey1.self,
                        value: geometry.frame(in: .global)
                    )
            }
        )
        .onPreferenceChange(FramePreferenceKey1.self, perform: action)
    }
}

private struct FramePreferenceKey1: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
