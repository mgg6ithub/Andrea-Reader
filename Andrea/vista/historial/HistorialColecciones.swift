import SwiftUI

struct HistorialColecciones: View {
    
    @Namespace private var breadcrumb
    
    @EnvironmentObject var pc: PilaColecciones
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 6) {
                    
                    ForEach(Array(pc.colecciones.enumerated()), id: \.1.url) { index, coleccion in
                        
                        let directoryName = coleccion.name // O `coleccion.url.lastPathComponent` si prefieres

                        if pc.esColeccionActual(coleccion: coleccion) {
                            
                            ColeccionRectangulo(nombreColeccion: coleccion.name, textoSize: 21, colorPrimario: .primary, color: coleccion.directoryColor)
                            
                        } else {
                            Button(action: {
                                withAnimation {
                                    pc.sacarHastaEncontrarColeccion(coleccion: coleccion)
                                }
                            }) {
                                
                                ColeccionRectangulo(nombreColeccion: coleccion.name, textoSize: 14, colorPrimario: .secondary, color: coleccion.directoryColor)
                                
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ColeccionRectangulo: View {
    
    let nombreColeccion: String
    let textoSize: CGFloat
    let colorPrimario: Color
    let color: Color
    
    var body: some View {
        
        Text(nombreColeccion)
            .font(.system(size: textoSize))
            .foregroundColor(colorPrimario)
            .padding(.horizontal, 7)
            .background(color.opacity(0.2))
            .cornerRadius(5)
        
    }
    
}

