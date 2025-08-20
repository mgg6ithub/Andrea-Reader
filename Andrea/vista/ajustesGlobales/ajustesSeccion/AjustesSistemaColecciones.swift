

import SwiftUI

#Preview {
    AjustesSistemaColecciones(isSection: true)
//        .environmentObject(AppEstado(screenWidth: 375, screenHeight: 667))
//        .environmentObject(AppEstado(screenWidth: 393, screenHeight: 852))
        .environmentObject(AppEstado(screenWidth: 820, screenHeight: 1180))
//        .environmentObject(AppEstado(screenWidth: 834, screenHeight: 1194)
//        .environmentObject(AppEstado(screenWidth: 1024, screenHeight: 1366))
        .environmentObject(MenuEstado())
}

struct AjustesSistemaColecciones: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    private var esTradicional: Bool { ap.sistemaArchivos == .tradicional }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text("Sistema de archivos") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: tema.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Elige cómo quieres navegar entre tus colecciones y archivos.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Escoge el sistema de archivos", titleSize: const.descripcionAjustes, color: ap.colorActual)
                
            HStack(spacing: 0) {
//                RectangleFormView<EnumTipoSistemaArchivos>(
//                    titulo: "Tradicional",
//                    icono: "folder.fill",
//                    coloresIcono: [Color.black],
//                    opcionSeleccionada: .tradicional,
//                    opcionActual: $ap.sistemaArchivos
//                )
//                
//                RectangleFormView<EnumTipoSistemaArchivos>(
//                    titulo: "Acceso rápido",
//                    icono: "list.bullet.rectangle",
//                    coloresIcono: [Color.black],
//                    opcionSeleccionada: .arbol,
//                    opcionActual: $ap.sistemaArchivos
//                )
                //ICONO sustituyendo a folder.fill
                VStack {
                    Text("Tradicional")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.subheadline)
                        .foregroundColor(ap.sistemaArchivos == .tradicional ? tema.textColor : tema.secondaryText.opacity(0.3))
                    
                    Button(action: {
                        ap.sistemaArchivos = .tradicional
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: const.cAnchoRect, height: const.cAlturaRect)
                                .foregroundColor(
                                    ap.sistemaArchivos == .tradicional ? Color.gray : Color.gray.opacity(0.3)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            ap.sistemaArchivos == .tradicional
                                            ? (tema == .dark ? Color.white : Color.black)
                                            : Color.clear,
                                            lineWidth: 1.5
                                        )
                                )
                            
                            Group {
                                // Capa trasera (más clara)
                                Image(systemName: "folder.fill")
                                    .font(.system(size: 52.5))
                                    .foregroundColor(Color(white: 0.1)) // gris claro
                                    .rotation3DEffect(
                                        .degrees(7.5),
                                        axis: (x: 0, y: 1, z: 0),
                                        anchor: .center
                                    )
                                
                                // Capa intermedia (gris medio)
                                Image(systemName: "folder.fill")
                                    .font(.system(size: 52.5))
                                    .foregroundColor(Color(white: 0.2)) // gris más oscuro
                                    .rotation3DEffect(
                                        .degrees(7.5),
                                        axis: (x: 0, y: 1, z: 0),
                                        anchor: .center
                                    )
                                    .offset(x: 7, y: 7)
                                
                                // Capa delantera (negro puro)
                                Image(systemName: "folder.fill")
                                    .font(.system(size: 52.5))
                                    .foregroundColor(Color(white: 0.3)) // casi negro sólido
                                    .rotation3DEffect(
                                        .degrees(7.5),
                                        axis: (x: 0, y: 1, z: 0),
                                        anchor: .center
                                    )
                                    .offset(x: 14, y: 14)
                            }
                            .offset(y: -9)
                        }
                    }
                }
 
                VStack {
                    
                    Text("Acceso rápido")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.subheadline)
                        .foregroundColor(ap.sistemaArchivos == .arbol ? tema.textColor : tema.secondaryText.opacity(0.3))
                    
                    Button(action: {
                        ap.sistemaArchivos = .arbol
                    }) {
                        //ICONO sustituyendo a list.bullet.rectangle
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: const.cAnchoRect, height: const.cAlturaRect)
                                .foregroundColor(
                                    ap.sistemaArchivos == .arbol ? Color.gray : Color.gray.opacity(0.3)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            ap.sistemaArchivos == .arbol
                                            ? (tema == .dark ? Color.white : Color.black)
                                            : Color.clear,
                                            lineWidth: 1.5
                                        )
                                )
                            
                            VStack(alignment: .center, spacing: 5) {
                                HStack(spacing: 2.5){
                                    
                                    Image(systemName: "folder.fill")
                                        .font(.system(size: 16))
                                        .offset(y: -3)
                                    
                                    RoundedRectangle(cornerRadius: 2.5)
                                        .frame(width: 50, height: 6)
                                }
                                .foregroundColor(Color(white: 0.1)) // gris claro
                                .offset(x: -5)
                                
                                HStack(spacing: 2.5){
                                
                                    
                                    Image(systemName: "folder.fill")
                                        .font(.system(size: 16))
                                        .offset(y: -3)
                                    
                                    RoundedRectangle(cornerRadius: 2.5)
                                        .frame(width: 50, height: 6)
                                }
                                .foregroundColor(Color(white: 0.2)) // gris claro
                                .offset(x: -5)
                                
                                HStack(spacing: 2.5){
                                    
                                    Image(systemName: "folder.fill")
                                        .font(.system(size: 16))
                                        .offset(y: -3)
                                    
                                    RoundedRectangle(cornerRadius: 2.5)
                                        .frame(width: 50, height: 6)
                                }
                                .foregroundColor(Color(white: 0.3)) // gris claro
                                .offset(x: -5)
                            }
                        }
                    }
                }


                
            }
            .fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            TituloInformacion(titulo: esTradicional ? "Tradicional" : "Acceso rápido", isSection: isSection)
                .animation(.smooth, value: ap.sistemaArchivos)
            
            Group {
                if esTradicional {
                    Text("El sistema de carpetas de toda la vida: organiza tus colecciones dentro de carpetas y subcarpetas. ")
                    + Text("Recomendado para bibliotecas pequeñas.").bold()
                } else {
                    Text("Todas las colecciones aparecen en un menú lateral, sin jerarquías. Al entrar en una colección solo verás sus archivos. ")
                    + Text("Recomendado para bibliotecas grandes.").bold()
                }
            }
            .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: 0, pW: 0)
            .animation(.smooth, value: ap.sistemaArchivos)
            
        }
    }
    
}
