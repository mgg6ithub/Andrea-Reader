

import SwiftUI


struct CambiarMiniaturaMenu: View {
    
    @EnvironmentObject var ap: AppEstado
    
    let elemento: any ElementoSistemaArchivosProtocolo
    let cambiarMiniaturaArchivo: ((EnumTipoMiniatura) -> Void)?
    let cambiarMiniaturaColeccion: ((EnumTipoMiniaturaColeccion) -> Void)?
    let cambiarDireccionAbanico: ((EnumDireccionAbanico) -> Void)?
    
    var body: some View {
        
        Menu {
            if let _ = elemento as? Archivo {
                Button {
                    cambiarMiniaturaArchivo?(.imagenBase)
                } label: {
                    Label("Imagen base", systemImage: "document")
                }
                Button {
                    cambiarMiniaturaArchivo?(.primeraPagina)
                } label: {
                    Label("Primera página", systemImage: "photo")
                }
                
                Button {
                    
                } label: {
                    Label("Página aleatoria", systemImage: "photo.on.rectangle.angled.fill")
                }
                
                Button {
                    
                } label: {
                    Label("Personalizada", systemImage: "photo.artframe")
                }
                
            } else if let _ = elemento as? Coleccion {
                Button {
                    cambiarMiniaturaColeccion?(.carpeta)
                } label: {
                    Label("Carpeta", systemImage: "folder")
                }
                Button {
                    cambiarMiniaturaColeccion?(.abanico)
                } label: {
                    Label("Bandeja", systemImage: "tray")
                }
                
                Menu {
                    
                    Button {
                        
                    } label: {
                        Label("Aleatorias", systemImage: "photo.artframe")
                    }
                    
                    Button {
                        cambiarDireccionAbanico?(.izquierda)
                    } label: {
                        Label("Hacia la izquierda", systemImage: "arrow.left")
                    }

                    Button {
                        cambiarDireccionAbanico?(.derecha)
                    } label: {
                        Label("Hacia la derecha", systemImage: "arrow.right")
                    }

                    
                } label: {
                    Label("Miniaturas", systemImage: "photo.on.rectangle.angled.fill")
                }
                
            }
        } label: {
            Label {
                Text("Cambiar portada")
            } icon: {
                Image("custom-paintbrush") // <- tu símbolo personalizado
                    .renderingMode(.template) // permite aplicar `foregroundStyle`
            }
            .symbolRenderingMode(.palette)
            .foregroundStyle(ap.temaActual.colorContrario, .gray)

        }
        
    }
    
}
