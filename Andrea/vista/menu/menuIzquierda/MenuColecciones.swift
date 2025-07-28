
import SwiftUI

struct PopOutCollectionsView<Header: View, Content: View>: View {
    
    var totalElements: Int
    
    @ViewBuilder var header: (Bool) -> Header
    @ViewBuilder var content: (Bool) -> Content

    @State private var sourceRect: CGRect = .zero
    @State private var showFullScreenCover: Bool = false
    @State private var animatedView: Bool = false
    
    @State private var haptics: Bool = false
    var body: some View {
        
        header(animatedView)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onGeometryChange1 { newValue in
                sourceRect = newValue
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
                    totalElements: totalElements,
                    sourceRect: $sourceRect,
                    animateView: $animatedView,
                    header: header,
                    content: content
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animatedView = false
                    }

                    // Espera a que se oculte la animación antes de cerrar el fullScreenCover
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        toggleFullScreenCover()
                    }
                }

            }
            .padding(.horizontal, 10)
            .sensoryFeedback(.impact, trigger: haptics)
    }
    
    private func toggleFullScreenCover() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        
        withTransaction(transaction) {
            showFullScreenCover.toggle()
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
    
    var totalElements: Int
    
    @Binding var sourceRect: CGRect
    @Binding var animateView: Bool
    @ViewBuilder var header: (Bool) -> Header
    @ViewBuilder var content: (Bool) -> Content
    var dismissView: () -> ()
    
    @State private var edgeInsets: EdgeInsets = .init()
    @State private var scale: CGFloat = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 15) {
                
                header(animateView)
                
                if animateView {
                    Text("Colecciones")
                        .font(.system(size: 20))
                        .bold()
                        .frame(alignment: .bottom)
                }
                
            }
            .padding(.bottom, 5)
            .padding([.leading, .trailing, .top], animateView ? 10 : 0)
            
            if animateView {
                content(animateView)
                    .transition(.blurReplace)
            }
            
        }
        .frame(width: animateView ? 300 : nil, height: animateView ? CGFloat(totalElements * 80) : 0)
        .background(
                    ap.temaActual.backgroundColor
                        .mask(
                            RoundedRectangle(cornerRadius: animateView ? 20 : 10)
                        )
                )
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: animateView ? 20 : 10))
        .frame(width: animateView ? nil : sourceRect.width, height: animateView ? nil : sourceRect.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .scaleEffect(scale, anchor: .topLeading)
            .animation(.easeInOut(duration: 0.3), value: scale)

        .offset(x: animateView ? 0 : sourceRect.minX,
                y: animateView ? 0 : sourceRect.minY)
            .animation(.easeInOut(duration: 0.3), value: animateView)

        .padding(.top, animateView ? 25 : 0)
        .padding(.leading, animateView ? 35 : 0)
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
                                    
                                    let velocityHeight = value.velocity.height / 5
                                    let height = value.translation.height
                                    let scale = height / geo.size.height
                                    let applyingRatio: CGFloat = 0.1
                                    
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
