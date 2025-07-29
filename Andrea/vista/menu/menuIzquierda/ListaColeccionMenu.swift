import SwiftUI

struct ListaColeccionMenu: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var pc: PilaColecciones
    private let sa: SistemaArchivos = SistemaArchivos.sa
    
    var onSeleccionColeccion: (() -> Void)? = nil
    
    var coleccionesFiltradas: [(key: URL, value: ColeccionValor)] {
        sa.cacheColecciones
            .filter { $0.value.coleccion.nombre != "HOME" }
            .sorted { $0.value.coleccion.nombre.lowercased() < $1.value.coleccion.nombre.lowercased() }
    }
    
    var coleccionPrincipal: Coleccion {
        if let coleccion = sa.obtenerColeccionPrincipal() {
            return coleccion
        } else {
            return FabricaColeccion().crearColeccion(coleccionNombre: "HOME", coleccionURL: sa.homeURL)
        }
    }
    
    var body: some View {
        List {
            ZStack {
                Button(action: {
                    coleccionPrincipal.meterColeccion()
                    onSeleccionColeccion?()
                }) {
                    VStack(spacing: 0) {
                        HStack {
                            ColeccionRectanguloAvanzado(
                                textoSize: 14,
                                colorPrimario: ap.temaActual.textColor,
                                color: Color.gray,
                                isActive: false,
                                horizontalPadding: 7,
                                animationDelay: 0
                            ) {
                                Image(systemName: "house").opacity(0.75)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(coleccionPrincipal.nombre)
                                    .font(.system(size: 17))
                                    .bold()
                                
                                HStack(spacing: 5) {
                                    if coleccionPrincipal.totalArchivos > 0 {
                                        Text("\(coleccionPrincipal.totalArchivos) archivos")
                                            .font(.system(size: 12))
                                            .foregroundColor(ap.temaActual.secondaryText)
                                    }
                                    
                                    if coleccionPrincipal.totalColecciones > 0 {
                                        Text("\(coleccionPrincipal.totalColecciones) colecciones")
                                            .font(.system(size: 12))
                                            .foregroundColor(ap.temaActual.secondaryText)
                                    }
                                    
                                    if coleccionPrincipal.totalArchivos == 0 && coleccionPrincipal.totalColecciones == 0 {
                                        Text("vacia")
                                            .font(.system(size: 12))
                                            .foregroundColor(ap.temaActual.secondaryText)
                                    }
                                }

                            }
                            
                            Spacer()
                            
                            if pc.getColeccionActual().coleccion == coleccionPrincipal {
                                Text("*")
                            }
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        if !coleccionesFiltradas.isEmpty {
                            Rectangle()
                                .fill(Color.gray) // O ap.temaActual.separatorColor
                                .frame(height: 0.5)
                                .padding(.leading, 50)
                                .onAppear {
                                    print(coleccionesFiltradas)
                                }
                        }
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets()) // <- Elimina los insets del sistema
            .background(ap.temaActual.backgroundColor)
            
            ForEach(Array(coleccionesFiltradas.enumerated()), id: \.element.key) { index, colValor in
                let isLast = index == coleccionesFiltradas.count - 1
                let col = colValor.value.coleccion
                VStack(spacing: 0) {
                    Button(action: {
                        col.meterColeccion()
                        onSeleccionColeccion?()
                    }) {
                        HStack {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(col.color.gradient.opacity(0.3))
                                    .frame(width: 30, height: 30)
                                    .shadow(color: col.color.opacity(0.25), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "folder.fill")
                                    .foregroundColor(col.color)
                                    .frame(width: 25, height: 25)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(col.nombre)
                                    .font(.system(size: 17))
                                    .bold()
                                
                                HStack(spacing: 5) {
                                    if col.totalArchivos > 0 {
                                        Text("\(col.totalArchivos) archivos")
                                            .font(.system(size: 12))
                                            .foregroundColor(ap.temaActual.secondaryText)
                                    }
                                    
                                    if col.totalColecciones > 0 {
                                        Text("\(col.totalColecciones) colecciones")
                                            .font(.system(size: 12))
                                            .foregroundColor(ap.temaActual.secondaryText)
                                    }
                                    
                                    if col.totalArchivos == 0 && col.totalColecciones == 0 {
                                        Text("vacia")
                                            .font(.system(size: 12))
                                            .foregroundColor(ap.temaActual.secondaryText)
                                    }
                                }
                            }
                            .padding(.leading, 0.5)
                            
                            Spacer()
                            
                            if pc.getColeccionActual().coleccion == col {
                                Text("*")
                            }
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .background(ap.temaActual.backgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    // Línea de separación personalizada
                    if !isLast {
                        Rectangle()
                            .fill(Color.gray) // O ap.temaActual.separatorColor
                            .frame(height: 0.5)
                            .padding(.leading, 50)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets()) // <- Elimina los insets del sistema
            }
        }
        .scrollContentBackground(.hidden)
        .background(ap.temaActual.backgroundColor)
        .listStyle(.plain)
        .listRowSeparator(.hidden) // <- Bien, pero reforzado por lo anterior
    }
}




