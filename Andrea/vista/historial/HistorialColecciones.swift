import SwiftUI

struct HistorialColecciones: View {
    // --- ENTORNO ---
    @Namespace private var breadcrumb
    @EnvironmentObject var pc: PilaColecciones
    @EnvironmentObject var ap: AppEstado

    // --- ESTADO ---
    @State private var esVerColeccionPresionado: Bool = false
    @State private var colorTemporal: Color = .clear
    @State private var primeraCarga: Bool = true
    @State var isActive: Bool = false
    @State private var show: Bool = false

    // --- VARIABLES CALCULADAS ---
    private var variable: CGFloat { ap.historialSize }
    private var escala: CGFloat { ap.constantes.scaleFactor }
    private var grande: CGFloat { variable * escala }
    private var peke: CGFloat { (variable - 7) * escala }
    private var paddingScalado: CGFloat { (variable - 10) * escala }
    private var spacioG: CGFloat { 5 * escala }
    private var spacioP: CGFloat { 4 * escala }
    
    private var tema: EnumTemas { ap.temaResuelto }

    var body: some View {
        HStack(spacing: 0) {
            if pc.getColeccionActual().coleccion.nombre == "HOME" {
                ColeccionRectanguloAvanzado(
                    textoSize: grande,
                    colorPrimario: tema.textColor,
                    vm: ModeloColeccion(),
                    isActive: true,
                    pH: paddingScalado,
                    animationDelay: delay(0)
                ) {
                    HStack(spacing: 10) {
                        Image(systemName: "house")
                        
                        Text("Home")
                            .font(.system(size: (variable - 1) * ap.constantes.scaleFactor))
                            .bold()
                    }
                }
            } else {
                Button(action: {
                   pc.conservarSoloHome()
                }) {
                    ColeccionRectanguloAvanzado(
                        textoSize: peke,
                        colorPrimario: tema.textColor,
                        vm: ModeloColeccion(),
                        isActive: false,
                        pH: paddingScalado,
                        animationDelay: delay(0)
                    ) {
                        Image(systemName: "house").opacity(0.75)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    let coleccionesFiltradas = pc.colecciones.filter { $0.coleccion.nombre != "HOME" }
                    ForEach(Array(coleccionesFiltradas.enumerated()), id: \.element.coleccion.url) { index, vm in
                        Group {
                            if pc.esColeccionActual(coleccion: vm.coleccion) {
                                HStack(spacing: spacioG) {
                                    ChevronAnimado(
                                        isActive: true,
                                        delay: delay(Double(index))
                                    )
                                    
                                    ColeccionRectanguloAvanzado(
                                        textoSize: grande,
                                        colorPrimario: tema.textColor,
                                        vm: vm,
                                        isActive: true,
                                        pH: paddingScalado,
                                        animationDelay: delay(Double(index))
                                    ) {
                                        Text(vm.coleccion.nombre)
                                    }
                                }
                            } else {
                                Button(action: {
                                    pc.sacarHastaEncontrarColeccion(coleccion: vm.coleccion)
                                }) {
                                    HStack(spacing: spacioP) {
                                        ChevronAnimado(
                                            isActive: false,
                                            delay: delay(Double(index))
                                        )
                                        
                                        ColeccionRectanguloAvanzado(
                                            textoSize: peke,
                                            colorPrimario: tema.secondaryText,
                                            vm: vm,
                                            isActive: false,
                                            pH: paddingScalado,
                                            animationDelay: delay(Double(index))
                                        ) {
                                            Text(vm.coleccion.nombre)
                                        }
                                    }
                                    .padding(.trailing, spacioP)
                                }
                                .buttonStyle(ColeccionButtonStyle())
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95)),
                            removal: .opacity.combined(with: .scale(scale: 1.05))
                        ))
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: pc.colecciones.map(\.coleccion.id))
            }
            .padding(.leading, 3.5)
            
            Spacer()

            if pc.getColeccionActual().coleccion.nombre != "HOME" {
                Button(action: {
                    
                    ap.coleccionseleccionada = pc.getColeccionActual()
                    withAnimation(.easeInOut(duration: 0.3)) { ap.masInformacionColeccion = true }
                    
                }) {
                    HStack(spacing: 6) {
                        Image("custom-folder-lupa")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(tema.secondaryText)
                            .font(.system(size: 16))
                            .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)
                            .offset(y: 1.5)
                        
                        Text("Ver")
                            .font(.system(size: 16))
                            .foregroundColor(tema.secondaryText)
                            .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)
                    }
                    .fondoBoton(pH: ConstantesPorDefecto().horizontalPadding, pV: 7, isActive: false, color: .gray, borde: false)
                    .aparicionStiffness(show: $show)
                }
                .padding(.trailing, 2.5)
            }
        }
        .onAppear {
            // Desactivamos primeraCarga luego de un breve delay para evitar lag inicial
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 0.1)) {
                    primeraCarga = false
                }
            }
        }
    }

    private func delay(_ index: Double) -> Double {
        if primeraCarga { return 0 }
        let hayMasDeUna = pc.colecciones.count > 1
        return ap.animaciones && hayMasDeUna ? index * 0.25 : 0
    }
}
