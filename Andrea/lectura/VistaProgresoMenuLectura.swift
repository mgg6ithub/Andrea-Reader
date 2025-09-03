import SwiftUI

struct VistaProgresoLectura: View {
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @ObservedObject var vm: ModeloColeccion
    
    @State private var dragValue: CGFloat = 0
    @GestureState private var isActive: Bool = false   // sigue como antes
    
    @State private var keepOpen: Bool = false          // 👈 nuevo
    @State private var inputPage: String = ""
    @State private var showSearch = false
    @FocusState private var isTextFieldFocused: Bool
    
    init(estadisticas: EstadisticasYProgresoLectura,
         vm: ModeloColeccion) {
        self.estadisticas = estadisticas
        self.vm = vm
        _dragValue = State(initialValue: CGFloat(estadisticas.paginaActual))
    }
    
    var body: some View {
        // 👇 combinación de GestureState + foco
        let effectiveActive = isActive || keepOpen
        
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("progreso")
                    .font(.system(size: 11))
                    .foregroundStyle(.white)
                    .padding(.leading, 7.5)
                    .frame(height: 20)
                    .animation(.snappy.delay(effectiveActive ? 0 : 1.0), value: effectiveActive)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    if showSearch {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                                TextField(
                                    "",
                                    text: $inputPage,
                                    prompt: Text("Buscar página...")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                )
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .keyboardType(.numberPad)
                                .focused($isTextFieldFocused)
                                .onSubmit {
                                    if let total = estadisticas.totalPaginas {
                                        goToPage(total: total)
                                    }
                                }
                            }
                            .frame(height: 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Rectangle()
                                .fill(.white)
                                .frame(height: 1)
                        }
                        .frame(width: 170)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: showSearch)
                    }
                }
                .contentShape(Rectangle())          // 👈 hace que todo el VStack sea clicable
                .onTapGesture {
                    // Consumir el tap para que NO cierre el menú
                }
                .padding(.bottom, 10)
                .onChange(of: effectiveActive) { _, newValue in
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.25)) { showSearch = true }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if !(isActive || keepOpen) {
                                showSearch = false
                            }
                        }
                    }
                }
                .onChange(of: isTextFieldFocused) { focused in
                    keepOpen = focused   // 👈 mientras tenga foco, se mantiene abierto
                }
                .animation(.snappy.delay(effectiveActive ? 0 : 1.0), value: effectiveActive)
                
                Spacer()
            }
            
            GeometryReader { geo in
                if let total = estadisticas.totalPaginas {
                    let percentage = dragValue / CGFloat(max(total - 1, 1))
                    let width = percentage * geo.size.width
                    let currentPage = Int(dragValue.rounded())
                    let currentPercent = Int(((dragValue + 1) / CGFloat(total)) * 100)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .blur(radius: 2.5)
                        
                        Rectangle()
                            .fill(vm.color.gradient)
                            .frame(width: width)
                            .shadow(radius: 2.5)
                        
                        ZStack(alignment: .leading) {
                            overlayBuilder(currentPage: currentPage,
                                           total: total,
                                           percent: currentPercent)
                            .foregroundStyle(.white)
                            
                            overlayBuilder(currentPage: currentPage,
                                           total: total,
                                           percent: currentPercent)
                            .foregroundStyle(.black)
                            .mask(alignment: .leading) {
                                Rectangle().frame(width: width)
                            }
                        }
                        .compositingGroup()
                        .opacity(effectiveActive ? 1 : 0)
                        .animation(
                            .easeInOut(duration: 0.3)
                            .delay(effectiveActive ? 0 : 1.0),
                            value: effectiveActive
                        )
                    }
                    .contentShape(.rect)
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.2)
                            .updating($isActive) { _, out, _ in
                                out = true   // activa solo mientras dure el long press
                            }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .updating($isActive) { _, out, _ in out = true }
                            .onChanged { gesture in
                                let progress = gesture.location.x / geo.size.width
                                dragValue = min(max(progress * CGFloat(total - 1), 0), CGFloat(total - 1))
                            }
                            .onEnded { _ in
                                let newPage = Int(dragValue.rounded())
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    estadisticas.paginaActual = newPage
                                }
                                dragValue = CGFloat(newPage)
                                // 👈 aquí no tocamos nada: isActive se apagará solo
                            }
                    )
                    .onChange(of: estadisticas.paginaActual) { _, newValue in
                        dragValue = CGFloat(newValue)
                    }
                }
            }
            .frame(height: 20 + (effectiveActive ? 25 : 0))
            .mask {
                RoundedRectangle(cornerRadius: 7.5)
                    .frame(height: 20 + (effectiveActive ? 25 : 0))
            }
            .animation(.snappy.delay(effectiveActive ? 0 : 1.0), value: effectiveActive)
        }
    }
    
    private func overlayBuilder(currentPage: Int, total: Int, percent: Int) -> some View {
        HStack {
            Image(systemName: "book.pages")
                .padding(.leading, 10)
            Text("Página \(currentPage + 1) de \(total)")
            Spacer()
            Text("\(percent)%")
        }
        .padding(.horizontal, 15)
    }
    
    private func goToPage(total: Int) {
        if let target = Int(inputPage),
           target > 0, target <= total {
            estadisticas.paginaActual = target - 1
            dragValue = CGFloat(target - 1)
            inputPage = ""
        }
    }
}







