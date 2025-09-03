import SwiftUI

enum FocusedField {
    case trigger
    case real
}

struct VistaProgresoLectura: View {
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @ObservedObject var vm: ModeloColeccion
    
    @State private var dragValue: CGFloat = 0
    @GestureState private var isActive: Bool = false   // sigue como antes
    
    @State private var keepOpen: Bool = false          // 👈 nuevo
    @State private var inputPage: String = ""
    @State private var showSearch = false
    @FocusState private var focusedField: FocusedField?
    
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
                            Button(action: {
                                focusedField = .trigger
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.white)
                                    Text("Ir a la página...")
                                       .font(.system(size: 12))
                                       .foregroundColor(.white.opacity(0.7))
                                    
                                }
                                .frame(height: 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Rectangle()
                                .fill(.white)
                                .frame(height: 0.7)
                            
                        // TextField oculto que usamos solo para mostrar el teclado
                          TextField("", text: .constant(""))  // campo vacío
                              .keyboardType(.numberPad)       // tipo de teclado numérico
                              .focused($focusedField, equals: .trigger)
                              .frame(width: 0, height: 0)     // invisible: tamaño cero
                              .opacity(0)
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.black)
                                        TextField("Ir a la página...", text: $inputPage) // 👈 sin prompt
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .focused($focusedField, equals: .real)// <- cuando se hace focus a este como estaba el de trigger hace que swift no sepa cual esta y cierra todo.
                                        .frame(width: 160)
                                        .onAppear { DispatchQueue.main.async { focusedField = .real } }
                                    }
                                    if focusedField == .real {
                                        Rectangle()
                                            .fill(.black)
                                            .frame(height: 0.7)
                                    }
                                }
                                Spacer()
                                
                                if focusedField == .real {
                                    Button("Aceptar") {
                                        if let total = estadisticas.totalPaginas {
                                            goToPage(total: total)
                                        }
                                        focusedField = nil
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                           to: nil, from: nil, for: nil)
                                    }
                                    .padding(.horizontal, 10) // un poco de espacio
                                    .padding(.vertical, 6)
                                    .background(Color.green)
                                    .foregroundColor(.black) // texto en blanco para contraste
                                    .cornerRadius(5)
                                }
                                
                            }
                        }
                        .offset(x: -10)
                        .frame(width: 160)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: showSearch)
                    }
                }
                .contentShape(Rectangle())          // 👈 hace que todo el VStack sea clicable
                .onTapGesture {}
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
                .onChange(of: focusedField) { old, focused in
                    if focused != nil {
                        keepOpen = true
                    } else {
                        keepOpen = false
                    }
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
                    .gesture(
                        DragGesture(minimumDistance: 0) // 👈 detecta también taps/long press
                            .updating($isActive) { _, out, _ in
                                out = true
                            }
                            .onChanged { gesture in
                                if gesture.translation == .zero {
                                    // 👈 está manteniendo sin mover
                                    // Solo expandir, no mover el slider todavía
                                } else {
                                    // 👈 está arrastrando → mover barra
                                    let progress = gesture.location.x / geo.size.width
                                    dragValue = min(max(progress * CGFloat(total - 1), 0), CGFloat(total - 1))
                                    
                                    //AQUI SE PUEDE HACER UN PASO DE PAGINAS RAPIDAS
                                    //-----
                                    //-----
                                }
                            }
                            .onEnded { gesture in
                                if gesture.translation != .zero {
                                    // 👈 solo si arrastró actualizamos la página
                                    let newPage = Int(dragValue.rounded())
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        estadisticas.setCurrentPage(currentPage: newPage)
                                    }
                                    dragValue = CGFloat(newPage)
                                }
                            }
                    )
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







