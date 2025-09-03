import SwiftUI

struct VistaProgresoLectura: View {
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @ObservedObject var vm: ModeloColeccion
    
    @State private var dragValue: CGFloat = 0
    @GestureState private var isActive: Bool = false
    
    init(estadisticas: EstadisticasYProgresoLectura,
         vm: ModeloColeccion) {
        self.estadisticas = estadisticas
        self.vm = vm
        _dragValue = State(initialValue: CGFloat(estadisticas.paginaActual))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("progreso")
                .font(.system(size: 11))
                .foregroundStyle(.white)
                .padding(.leading, 7.5)
                .animation(
                            .snappy.delay(isActive ? 0 : 1.0), // 👈 espera 1s al cerrarse
                            value: isActive
                        )
            
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
                        .opacity(isActive ? 1 : 0)
                        .animation(
                            .easeInOut(duration: 0.3)
                            .delay(isActive ? 0 : 1.0), // 👈 espera 1s al cerrar
                            value: isActive
                        )
                    }
                    .contentShape(.rect)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .updating($isActive) { _, out, _ in out = true }
                            .onChanged { gesture in
                                let progress = gesture.location.x / geo.size.width
                                dragValue = min(max(progress * CGFloat(total - 1), 0), CGFloat(total - 1))
                                
                                let newPage = Int(dragValue.rounded())
                                withAnimation(.easeInOut(duration: 0.25)) { estadisticas.paginaActual = newPage }
                            }
                            .onEnded { _ in
                                let newPage = Int(dragValue.rounded())
                                withAnimation(.easeInOut(duration: 0.25)) { estadisticas.paginaActual = newPage }
                                dragValue = CGFloat(newPage)
                            }
                    )
                    .onChange(of: estadisticas.paginaActual) { old, newValue in
                        dragValue = CGFloat(newValue)
                    }
                }
            }
            .frame(height: 20 + (isActive ? 25 : 0))
            .mask {
                RoundedRectangle(cornerRadius: 7.5)
                    .frame(height: 20 + (isActive ? 25 : 0))
            }
            .animation(
                .snappy.delay(isActive ? 0 : 1.0), // 👈 espera 1s antes de cerrarse
                value: isActive
            )
        }
    }
    
    private func overlayBuilder(currentPage: Int, total: Int, percent: Int) -> some View {
        HStack {
            Image(systemName: "book.pages")
            Text("Página \(currentPage + 1) de \(total)")
            Spacer()
            Text("\(percent)%")
        }
        .contentTransition(.numericText()) // 👈 animación numérica nativa
        .animation(.easeInOut(duration: 0.25), value: estadisticas.paginaActual)
        .padding(.horizontal, 15)
    }
}






