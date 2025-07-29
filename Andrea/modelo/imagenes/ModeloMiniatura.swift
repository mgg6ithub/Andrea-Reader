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
    static var modeloMiniatura: ModeloMiniatura = ModeloMiniatura()
    
    //Cola para poder acceder desde cualquier parte del programa al singleton
    private static let modeloMiniaturaQueue = DispatchQueue(label: "com.miApp.singletonModeloMiniatura")
    
    //Cache para las miniaturas.
    //Utilizamos un NSCache por si hay muchas miniaturas y afecta a la memoria que se vacie solo.
    private var cacheMiniaturas: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    //MARK: --- CONSTRUCTOR PRIVADO ---
    private init() {}
    
    func construirMiniatura(
        color: Color,
        archivo: Archivo,
        completion: @escaping (UIImage?) -> Void
    ) {
        // 1) Lanza todo el trabajo pesado en un hilo userInitiated
        DispatchQueue.global(qos: .userInitiated).async {
            //--- obtener imagen por defecto ---
            let imagenBase = self.imagenBase(tipoArchivo: archivo.fileType, color: color)
            //--- si el tipo de archivo es desconodio ---
            guard archivo.fileType != .unknown else {
                DispatchQueue.main.async { completion(imagenBase) }
                return
            }
            //--- si el tipo miniatura es la imagen base ---
            guard archivo.tipoMiniatura != .imagenBase else {
                DispatchQueue.main.async { completion(imagenBase) }
                return
            }

            // 3) Si no hay páginas, devolvemos default
            guard let primeraPagina = archivo.obtenerPrimeraPagina() else {
                DispatchQueue.main.async { completion(imagenBase) }
                return
            }

            // 4) Carga datos y downsamplea
            guard let data = archivo.cargarDatosImagen(nombreImagen: primeraPagina) else {
                DispatchQueue.main.async { completion(imagenBase) }
                return
            }

            let targetSize = CGSize(width: 1000, height: 1000)
            let miniatura: UIImage?

            // 4.1) Downsample dentro de este hilo userInitiated
            miniatura = self.downsample(imageData: data, to: targetSize, scale: 1.0)

            // 5) Guardar en cache y regresar al hilo principal
            if let thumb = miniatura {
                self.guardarMiniatura(miniatura: thumb, archivo: archivo)
            }

            DispatchQueue.main.async {
                completion(miniatura ?? imagenBase)
            }
        }
    }

    
    func imagenBase(tipoArchivo: EnumTipoArchivos, color: Color) -> UIImage? {
        // 1) Placeholder (no optional)
        let placeholder = EnumMiniaturasArchivos.uiImage(for: tipoArchivo)
        
        // 2) Genera la miniatura por defecto, que sí es opcional
        return  {
            guard let thumb = ImagenArchivoModelo()
                    .crearMiniaturaPorDefecto(
                        miniatura: placeholder,
                        color: UIColor(color)
                    )?
                    .uiImage
            else {
                return nil
            }
            return thumb
        }()

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
//            print("✅ Imagen confirmada en caché para archivo:", archivo.name)
        } else {
            print("❌ No se pudo confirmar imagen en caché para archivo:", archivo.nombre)
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

