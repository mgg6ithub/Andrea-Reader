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
            // --- HOME ---
            if pc.getColeccionActual().coleccion.nombre == "HOME" {
                ColeccionRectanguloAvanzado(
                    textoSize: grande,
                    colorPrimario: tema.textColor,
                    nombre: "Home",
                    color: .gray, // o el color que quieras para Home
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
                        nombre: "Home",
                        color: .gray,
                        isActive: false,
                        pH: paddingScalado,
                        animationDelay: delay(0)
                    ) {
                        Image(systemName: "house").opacity(0.75)
                    }
                }
            }
            
            // --- RESTO DE COLECCIONES ---
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    let coleccionesFiltradas = pc.historialItems.filter { $0.nombre != "HOME" }
                    ForEach(Array(coleccionesFiltradas.enumerated()), id: \.element.id) { index, item in
                        Group {
                            if pc.getColeccionActual().coleccion.id == item.id {
                                HStack(spacing: spacioG) {
                                    ChevronAnimado(
                                        isActive: true,
                                        delay: delay(Double(index))
                                    )
                                    
                                    ColeccionRectanguloAvanzado(
                                        textoSize: grande,
                                        colorPrimario: tema.textColor,
                                        nombre: item.nombre,
                                        color: item.color,
                                        isActive: true,
                                        pH: paddingScalado,
                                        animationDelay: delay(Double(index))
                                    ) {
                                        Text(item.nombre)
                                    }
                                }
                            } else {
                                Button(action: {
                                    // buscar el ModeloColeccion real a partir del id
                                    if let vm = pc.colecciones.first(where: { $0.coleccion.id == item.id }) {
                                        pc.sacarHastaEncontrarColeccion(coleccion: vm.coleccion)
                                    }
                                }) {
                                    HStack(spacing: spacioP) {
                                        ChevronAnimado(
                                            isActive: false,
                                            delay: delay(Double(index))
                                        )
                                        
                                        ColeccionRectanguloAvanzado(
                                            textoSize: peke,
                                            colorPrimario: tema.secondaryText,
                                            nombre: item.nombre,
                                            color: item.color,
                                            isActive: false,
                                            pH: paddingScalado,
                                            animationDelay: delay(Double(index))
                                        ) {
                                            Text(item.nombre)
                                        }
                                    }
                                    .padding(.trailing, spacioP)
                                }
                                .buttonStyle(ColeccionButtonStyle())
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 1.05)),
                            removal: .opacity.combined(with: .scale(scale: 1.05))
                        ))
                    }
                }
                .animation(.easeOut(duration: 0.15), value: pc.historialItems.map(\.id))
            }
            .padding(.leading, 3.5)
            
            Spacer()

            // --- BOTÓN INFO DE COLECCIÓN ACTUAL ---
            if pc.getColeccionActual().coleccion.nombre != "HOME" {
                Button(action: {
                    ap.coleccionseleccionada = pc.getColeccionActual()
                    withAnimation(.easeInOut(duration: 0.3)) { ap.masInformacionColeccion = true }
                }) {
                    HStack(spacing: 6) {
                        let colActual = pc.getColeccionActual()
                        if let urlIcono = colActual.coleccion.icono {
                            if let imgIcono = ModeloMiniatura.modeloMiniatura.obtenerMiniaturaPersonalizada(
                                archivo: Archivo(),
                                color: colActual.color,
                                urlMiniatura: urlIcono
                            ) {
                                Image(uiImage: imgIcono)
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                        } else {
                            Image("custom-folder-lupa")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(tema.colorContrario)
                                .font(.system(size: 18))
                                .scaleEffect(esVerColeccionPresionado ? 1.1 : 0.8)
                                .offset(y: 1.5)
                        }
                        
                        Image(systemName: "info.circle")
                            .font(.system(size: 16))
                            .foregroundColor(tema.secondaryText)
                            .scaleEffect(esVerColeccionPresionado ? 1.1 : 1.0)
                    }
                    .fondoBoton(pH: 7.5, pV: 1.5, isActive: false, color: .gray, borde: false)
                    .aparicionStiffness(show: $show)
                }
                .padding(.trailing, 2.5)
            }
        }
        .onAppear {
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

