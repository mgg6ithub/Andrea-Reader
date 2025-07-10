//
//  ModeloMiniatura.swift
//  Andrea
//
//  Created by mgg on 6/7/25.
//

import SwiftUI
import UIKit
import ImageIO

class ModeloMiniatura {
    
    //Instancia del singleton
    private static var modeloMiniatura: ModeloMiniatura? = nil
    
    //Cola para poder acceder desde cualquier parte del programa al singleton
    private static let modeloMiniaturaQueue = DispatchQueue(label: "com.miApp.singletonModeloMiniatura")
    
    public static var getModeloMiniaturaSingleton: ModeloMiniatura {
        return modeloMiniaturaQueue.sync {
            if modeloMiniatura == nil {
                modeloMiniatura = ModeloMiniatura()
            }
            return modeloMiniatura!
        }
    }
    
    //Cache para las miniaturas.
    //Utilizamos un NSCache por si hay muchas miniaturas y afecta a la memoria que se vacie solo.
    private var cacheMiniaturas: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    //MARK: --- CONSTRUCTOR PRIVADO ---
    private init() {}
    
    func construirMiniatura(
        coleccion: Coleccion,
        archivo: Archivo,
        completion: @escaping(UIImage?) -> Void
    ) {
        DispatchQueue.global().async {
            // 1) Placeholder (no optional)
            let placeholder = EnumMiniaturasArchivos.uiImage(for: archivo.fileType)
            
            // 2) Genera la miniatura por defecto, que sí es opcional
            let defaultThumbnail: UIImage? = {
                guard let thumb = ImagenArchivoModelo()
                        .crearMiniaturaPorDefecto(
                            miniatura: placeholder,
                            color: UIColor(coleccion.directoryColor)
                        )?
                        .uiImage
                else {
                    return nil
                }
                return thumb
            }()
            
            // 3) Si no hay páginas, devolvemos default
            guard let primeraPagina = archivo.pages.first else {
                DispatchQueue.main.async {
                    completion(defaultThumbnail)
                }
                return
            }
            
            // --- SIN DOWNSAMPLE --- CADA IMAGEN CONSUMIRA MUCHA MEMORIA RAM
            // 4) Intentamos cargar la imagen real
//            guard let miniatura = archivo.cargarImagen(nombreImagen: primeraPagina) else {
//                DispatchQueue.main.async {
//                    completion(defaultThumbnail)
//                }
//                return
//            }
            
            guard let data = archivo.cargarDatosImagen(nombreImagen: primeraPagina) else {
                print("MAL")
                return
            }
            let targetSize = CGSize(width: 1000, height: 1000)
            
            //4.1 aplicamos downsample para controlar por completo la calida.
            guard let miniatura = self.downsample(imageData: data, to: targetSize, scale: 1.0)  else {
                DispatchQueue.main.async {
                    completion(defaultThumbnail)
                }
                return
            }
            
            
            // 5) Cache y entrega
            self.guardarMiniatura(miniatura: miniatura, archivo: archivo)
            DispatchQueue.main.async {
                completion(miniatura)
            }
        }
    }

    func downsample(
        imageData: Data,
        to pointSize: CGSize,
        scale: CGFloat = UIScreen.main.scale
    ) -> UIImage? {
        let cfData = imageData as CFData
        guard let src = CGImageSourceCreateWithData(cfData, nil) else { return nil }

        let maxPixelSize = max(pointSize.width, pointSize.height) * scale
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: false
        ]

        guard let cgThumb = CGImageSourceCreateThumbnailAtIndex(src, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: cgThumb)
    }

    
    
    func obtenerLLave(archivoURL: URL) -> NSString {
        return ManipulacionCadenas().relativizeURLNOextension(elementURL: archivoURL) as NSString
    }
    
    
    func guardarMiniatura(miniatura: UIImage, archivo: Archivo) {
        let key = obtenerLLave(archivoURL: archivo.url)
        self.cacheMiniaturas.setObject(miniatura, forKey: key)
        
        //Mera comprobacion
        if self.cacheMiniaturas.object(forKey: key) != nil {
            print("✅ Imagen confirmada en caché para archivo:", archivo.name)
        } else {
            print("❌ No se pudo confirmar imagen en caché para archivo:", archivo.name)
        }
    }
    
    
    func obtenerMiniatura(archivo: Archivo) -> UIImage? {
        let key = obtenerLLave(archivoURL: archivo.url)
        if let miniatura = cacheMiniaturas.object(forKey: key) {
            return miniatura
        }
        return nil
    }
    
    func eliminarMiniatura(archivo: Archivo) {
        let key = obtenerLLave(archivoURL: archivo.url)
        self.cacheMiniaturas.removeObject(forKey: key)
    }
    
    func limpiarCache() {
        
    }
    
}
