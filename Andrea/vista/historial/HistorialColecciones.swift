
import SwiftUI

struct HistorialColecciones: View {
    
    // --- ENTORNO ---
    @Namespace private var breadcrumb
    @EnvironmentObject var pc: PilaColecciones
    @EnvironmentObject var appEstado: AppEstado

    // --- ESTADO ---
    @State private var esVerColeccionPresionado: Bool = false
    @State private var colorTemporal: Color = .clear
    @State private var primeraCarga: Bool = true
    @State var isActive: Bool = false
    @State private var show: Bool = false

    // --- VARIABLES CALCULADAS ---
    private var escala: CGFloat { appEstado.constantes.scaleFactor }
    private var grande: CGFloat { 21 * escala }
    private var peke: CGFloat { 14 * escala }
    private var paddingScalado: CGFloat { 11 * escala }
    private var spacioG: CGFloat { 5 * escala }
    private var spacioP: CGFloat { 4 * escala }

    var body: some View {
        HStack(spacing: 0) {
            
            if pc.getColeccionActual().coleccion.nombre == "HOME" {
                ColeccionRectanguloAvanzado(
                    textoSize: grande,
                    colorPrimario: appEstado.temaActual.textColor,
                    color: Color.gray,
                    isActive: true,
                    pH: paddingScalado,
                    animationDelay: delay(0)
                ) {
                    HStack(spacing: 10) {
                        Image(systemName: "house").opacity(0.75)
                        
                        Text("Home")
                            .font(.system(size: 20 * appEstado.constantes.scaleFactor))
                            .bold()
                    }
                }
                
            } else {
                Button(action: {
                    pc.conservarSoloHome()
                }) {
                    ColeccionRectanguloAvanzado(
                        textoSize: peke,
                        colorPrimario: appEstado.temaActual.textColor,
                        color: Color.gray,
                        isActive: false,
                        pH: paddingScalado,
                        animationDelay: delay(0)
                    ) {
                        Image(systemName: "house").opacity(0.75)
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
                                        colorPrimario: appEstado.temaActual.textColor,
                                        color: vm.color,
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
                                        Image(systemName: "chevron.forward")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray.opacity(0.8))
                                            .transition(.opacity.combined(with: .scale)) // animación al aparecer/desaparecer
                                            .animation(.easeInOut(duration: 1.5), value: pc.getColeccionActual().coleccion)
                                        
                                        ColeccionRectanguloAvanzado(
                                            textoSize: peke,
                                            colorPrimario: appEstado.temaActual.secondaryText,
                                            color: vm.color,
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
                    }
                }
            }
            .padding(.leading, 3.5)
        }

            Spacer()

            if pc.getColeccionActual().coleccion.nombre != "HOME" {
                Button(action: {
                    
                    self.colorTemporal = pc.getColeccionActual().color
                    
                    if appEstado.animaciones {
                        withAnimation {
                            esVerColeccionPresionado.toggle()
                        }
                    } else {
                        esVerColeccionPresionado.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image("custom-folder-lupa")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(appEstado.temaActual.secondaryText)
                            .font(.system(size: 16))
                            .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)
                            .offset(y: 1.5)
                        
                        Text("Ver")
                            .font(.system(size: 16))
                            .foregroundColor(appEstado.temaActual.secondaryText)
                            .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)
                    }
                    .fondoBoton(pH: ConstantesPorDefecto().horizontalPadding, pV: 7, isActive: false, color: .gray, borde: false)
                    .aparicionStiffness(show: $show)
                }
                .sheet(isPresented: $esVerColeccionPresionado, onDismiss: {
                    pc.getColeccionActual().color = colorTemporal //Al cerrar asignamos el color seleccionado
                }) {
                    MasInformacionColeccion(coleccionVM: pc.getColeccionActual(), colorTemporal: $colorTemporal)
                }
                .padding(.trailing, 2.5)
            }
        }
        .onAppear {
            // Desactivamos primeraCarga luego de un breve delay para evitar lag inicial
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.linear(duration: 0.15)) {
                    primeraCarga = false
                }
            }
        }
    }

    private func delay(_ index: Double) -> Double {
        if primeraCarga { return 0 }
        let hayMasDeUna = pc.colecciones.count > 1
        return appEstado.animaciones && hayMasDeUna ? index * 0.1 : 0
    }
}
