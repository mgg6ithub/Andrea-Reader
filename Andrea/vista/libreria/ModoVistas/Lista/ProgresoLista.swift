
import SwiftUI

struct ProgresoLista: View {
    
    @EnvironmentObject var ap: AppEstado
    
//    @ObservedObject var archivo: Archivo
    @ObservedObject var estadisticas: EstadisticasYProgresoLectura
    @ObservedObject var coleccionVM: ModeloColeccion
    @Binding var progresoMostrado: Int
    
    var body: some View {
        HStack(spacing: 10) {
            
            if estadisticas.progreso > 0 && ap.porcentajeNumero {
                HStack(spacing: 0) {
//                    Text("%")
//                        .font(.system(size: ap.porcentajeNumeroSize * 0.75))
//                        .bold()
//                        .foregroundColor(coleccionVM.color)
//                        .offset(y: 1.5)
                    Color.clear
                        .animatedProgressText1(progresoMostrado)
                        .font(.system(size: ap.porcentajeNumeroSize * 1.1))
                        .bold()
                        .foregroundColor(coleccionVM.color)
                }
                //NECESARIOS PARA ANIMACION DEL PROGRESO
                .onAppear { progresoMostrado = estadisticas.progreso }
                .onChange(of: ap.archivoEnLectura) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        progresoMostrado = estadisticas.progreso
                    }
                }
                //NECESARIOS PARA ANIMACION DEL PROGRESO
            }
            
            if ap.porcentajeBarra && ap.porcentajeEstilo == .dentroCarta {
                GeometryReader { geo in
                    let totalWidth = geo.size.width
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(progresoMostrado > 0 ? Color.gray.opacity(0.7) : Color.gray.opacity(0.3))
                            .frame(height: 3)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(coleccionVM.color)
                            .frame(width: totalWidth * CGFloat(progresoMostrado) / 100.0, height: 3)
                            .animacionDesvanecer(coleccionVM.color) // <- necesaria para cambiar de color con animacion
                    } //FIN ZSTACK PROGRESSVIEW
                }
                .frame(height: 3)
                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
            }
            
        }
    }
}


struct ProgressStroke<S: InsettableShape>: View {
    @Binding var progreso: Int // 0…100
    var shape: S
    var color: Color
    var lineWidth: CGFloat = 3
    var showGuide: Bool = false

    private var t: CGFloat { CGFloat(max(0, min(100, progreso))) / 100 }

    var body: some View {
        ZStack {
            if showGuide {
                shape.inset(by: lineWidth / 2)
                    .stroke(Color.gray.opacity(0.25), lineWidth: lineWidth)
            }

            shape.inset(by: lineWidth / 2)
                .trim(from: 0, to: t) // arranca donde empieza el path (arriba-izquierda)
                .stroke(color,
                        style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round,
                                           lineJoin: .round))
                .animation(.easeOut(duration: 0.6), value: progreso)
        }
        .compositingGroup()
        .allowsHitTesting(false)
    }
}


struct RoundedCorners1: InsettableShape {
    var tl: CGFloat = 0, tr: CGFloat = 0, bl: CGFloat = 0, br: CGFloat = 0
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let tl = min(self.tl, min(r.width, r.height) / 2)
        let tr = min(self.tr, min(r.width, r.height) / 2)
        let bl = min(self.bl, min(r.width, r.height) / 2)
        let br = min(self.br, min(r.width, r.height) / 2)

        var p = Path()
        // Empieza en el borde superior, cerca de top-left (para que el trim arranque ahí)
        p.move(to: CGPoint(x: r.minX + tl, y: r.minY))

        // Top edge → top-right
        p.addLine(to: CGPoint(x: r.maxX - tr, y: r.minY))
        if tr > 0 {
            p.addArc(center: CGPoint(x: r.maxX - tr, y: r.minY + tr),
                     radius: tr, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        }

        // Right edge → bottom-right
        p.addLine(to: CGPoint(x: r.maxX, y: r.maxY - br))
        if br > 0 {
            p.addArc(center: CGPoint(x: r.maxX - br, y: r.maxY - br),
                     radius: br, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        }

        // Bottom edge → bottom-left
        p.addLine(to: CGPoint(x: r.minX + bl, y: r.maxY))
        if bl > 0 {
            p.addArc(center: CGPoint(x: r.minX + bl, y: r.maxY - bl),
                     radius: bl, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        }

        // Left edge → top-left
        p.addLine(to: CGPoint(x: r.minX, y: r.minY + tl))
        if tl > 0 {
            p.addArc(center: CGPoint(x: r.minX + tl, y: r.minY + tl),
                     radius: tl, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        }

        p.closeSubpath()
        return p
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var s = self
        s.insetAmount += amount
        return s
    }
}
