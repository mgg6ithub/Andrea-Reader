import SwiftUI

#Preview {
    AjustesLibreria(isSection: true)
        .environmentObject(AppEstado.preview)
        .environmentObject(MenuEstado.preview)
}

struct AjustesLibreria: View {
    
    @EnvironmentObject var ap: AppEstado
    @EnvironmentObject var menuEstado: MenuEstado
    
    var isSection: Bool
    
    var const: Constantes { ap.constantes }
    var paddingVertical: CGFloat { const.padding20 }
    var paddingHorizontal: CGFloat { const.padding40 }
    
    private var tema: EnumTemas { ap.temaResuelto }
    private var esOscuro: Bool { tema == .dark }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Libreria") //TITULO
                .capaTituloPrincipal(s: const.tituloAjustes, c: tema.tituloColor, pH: paddingVertical, pW: paddingHorizontal)
            
            Text("Define cómo se ven y se mueven tus libros. Personaliza las cartas, activa el porcentaje de lectura y afina el scroll para una experiencia fluida.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            TituloInformacion(titulo: "Porcentaje", isSection: isSection)
            
            Text("Cada archivo importado puede mostrar su progreso de lectura. Puedes desactivarlo o personalizar la forma en la que se ve.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Progreso de lectura", titleSize: const.descripcionAjustes, color: ap.colorActual)
            
            VStack(alignment: .trailing, spacing: 0) {
                TogglePersonalizado(titulo: "Porcentaje", descripcion: "Activa o desactiva el porcentaje.", opcionBinding: $ap.porcentaje, opcionTrue: "Ocultar progreso", opcionFalse: "Mostrar progreso", isInsideToggle: true, isDivider: ap.porcentaje ? true : false)
                
                if ap.porcentaje {
                    VStack(spacing: 0) {
                        TogglePersonalizado(titulo: "Numero", descripcion: "Muestra el porcentaje como número sobre la portada.", opcionBinding: $ap.porcentajeNumero, opcionTrue: "Ocultar porcentaje numero", opcionFalse: "Mostrar porcentaje numero", isInsideToggle: true, isDivider: false)
                        
                        if ap.porcentajeNumero {
                            VStack(alignment: .center, spacing: 0) {
                                HStack {
                                    Text("Tamaño del número")
                                        .font(.headline)
                                        .foregroundColor(tema.colorContrario)
                                    Spacer()
                                    Text("\(Int(ap.porcentajeNumeroSize)) pt")
                                        .font(.subheadline)
                                        .foregroundColor(tema.secondaryText)
                                }
                                
                                IconSizeSlider(
                                    value: $ap.porcentajeNumeroSize,
                                    min: (ConstantesPorDefecto().subTitleSize - 5),
                                    max: (ConstantesPorDefecto().subTitleSize + 5),
                                    recommended: ConstantesPorDefecto().subTitleSize,
                                    trackColor: tema.colorContrario,
                                    fillColor: ap.colorActual,
                                    markerColor: tema.colorContrario,
                                    textColor: tema.secondaryText
                                )
                                
                                Text("Utiliza la barra de desplazamiento para aumentar o disminuir el tamaño del numero del progreso.")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                            .padding(.top, 10)
                            .animacionVStackSaliente(isExpanded: ap.porcentajeNumero, animaciones: ap.animaciones)
                        }
                        
                        Rectangle()
                            .fill(tema.lineaColor)
                            .frame(height: 0.5)
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                        
                        TogglePersonalizado(titulo: "Barra de progreso", descripcion: "Muestra una barra de progreso en la carta.", opcionBinding: $ap.porcentajeBarra, opcionTrue: "Ocultar porcentaje barra", opcionFalse: "Mostrar porcentaje barra", isInsideToggle: true, isDivider: false)
                            .padding(.bottom, 10)
                        
                        if ap.porcentajeBarra {
                            CirculoActivoVista(isSection: isSection, nombre: "Estilo de la barra", titleSize: const.descripcionAjustes, color: ap.colorActual)
                            
                            Group {
                                VStack(spacing: 0) {
                                    TogglePersonalizado(
                                        titulo: "Dentro de la carta",
                                        descripcion: "La barra se muestra en la parte inferior de la carta.",
                                        opcionBinding: Binding(
                                            get: { ap.porcentajeEstilo == .dentroCarta },
                                            set: { isOn in
                                                if isOn { ap.porcentajeEstilo = .dentroCarta }
                                            }
                                        ),
                                        opcionTrue: "Ocultar barra",
                                        opcionFalse: "Mostrar barra",
                                        isInsideToggle: true,
                                        isDivider: false
                                    )
                                }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                                
                                VStack(spacing: 0) {
                                    TogglePersonalizado(
                                        titulo: "Contorno de la carta",
                                        descripcion: "La barra progresa a lo largo del contorno de la carta (en cuadrícula y lista).",
                                        opcionBinding: Binding(
                                            get: { ap.porcentajeEstilo == .contorno },
                                            set: { isOn in
                                                if isOn { ap.porcentajeEstilo = .contorno }
                                            }
                                        ),
                                        opcionTrue: "Ocultar barra",
                                        opcionFalse: "Mostrar barra",
                                        isInsideToggle: true,
                                        isDivider: false
                                    )
                                }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
                            }.animacionVStackSaliente(isExpanded: ap.porcentajeBarra, animaciones: ap.animaciones)
                            
                        }
                        
                    }
                    .padding(.leading, 30)
                    .animacionVStackSaliente(isExpanded: ap.porcentaje, animaciones: ap.animaciones)
                }
                
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            DividerDentroSeccion(pH: 25, pV: 25)
            
            CirculoActivoVista(isSection: isSection, nombre: "Fondo de la carta", titleSize: const.descripcionAjustes, color: ap.colorActual)
            
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Fondo", descripcion: "Muestra u oculta el fondo de la carta para los archivos de la libreria.", opcionBinding: $ap.fondoCarta, opcionTrue: "Ocultar fondo", opcionFalse: "Mostrar fondo", isInsideToggle: true, isDivider: false)
            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows)
            
            DividerDentroSeccion(pH: 25, pV: 25)
            
            TituloInformacion(titulo: "Desplazamiento", isSection: isSection)
            
            Text("Controla la experiencia de desplazamiento en tu librería: guarda la posición entre colecciones, ajusta la velocidad e inercia y disfruta de una navegación más fluida y adaptada modificando animaciones.")
                .capaDescripcion(s: const.descripcionAjustes, c: tema.secondaryText, pH: paddingVertical, pW: 0)
            
            CirculoActivoVista(isSection: isSection, nombre: "Guardar el desplazamiento", titleSize: const.descripcionAjustes, color: ap.colorActual)
            
            VStack(spacing: 0) {
                TogglePersonalizado(titulo: "Autoguardado", opcionBinding: $ap.fondoCarta, opcionTrue: "Deshabilitar guardado", opcionFalse: "Habilitar guardado", isInsideToggle: true, isDivider: true)
                
                Text("Al activar esta opción, cada colección recordará el punto exacto hasta donde te desplazaste. Así, al volver a abrirla o reiniciar la aplicación, continuarás justo desde ese lugar. Si la desactivas, la colección se abrirá siempre desde el inicio.")
                    .capaDescripcion(s: const.descripcionAjustes * 0.8, c: tema.secondaryText, pH: 0, pW: 0)
                
                Recomendacion(mensaje: "Si tienes colecciones con muchos archivos.", c: tema.textColor)

            }.fondoRectangular(esOscuro: esOscuro, shadow: ap.shadows, pV: false)

        }
    }
}
