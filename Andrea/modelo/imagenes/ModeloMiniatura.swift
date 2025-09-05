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
    
    func construirMiniatura(color: Color, archivo: Archivo, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            //--- Imagen por defecto ---
            let imagenBase = self.imagenBase(tipoArchivo: archivo.fileType, color: color)
            
            //--- Tipo de archivo desconocido ---
            guard archivo.fileType != .unknown else {
                DispatchQueue.main.async { completion(imagenBase) }
                return
            }
            
            //--- Según el tipo de miniatura ---
            switch archivo.tipoMiniatura {
                
            case .imagenBase:
                DispatchQueue.main.async { completion(imagenBase) }
                return
                
            case .primeraPagina:
                DispatchQueue.main.async { completion(self.obtenerMiniaturaPrimera(archivo: archivo, color: color) ?? imagenBase) }
                return
                
            case .aleatoria:
                DispatchQueue.main.async { completion(self.obtenerMiniaturaAleatoria(archivo: archivo, color: color) ?? imagenBase) }
                return
                
            case .personalizada:
                guard let imagenPersonalizada = archivo.imagenPersonalizada else {
                    DispatchQueue.main.async { completion(imagenBase) }
                    return
                }
                DispatchQueue.main.async { completion(self.obtenerMiniaturaPersonalizada(archivo: archivo, color: color, urlMiniatura: imagenPersonalizada)) }
                return
            }
        }
    }
    
    func imagenBase(tipoArchivo: EnumTipoArchivos, color: Color) -> UIImage? {
        // 1) Placeholder (no optional)
        let placeholder = EnumMiniaturasArchivos.uiImage(for: tipoArchivo)
        
        // 2) Genera la miniatura por defecto, que sí es opcional
        return  {
            guard let thumb = ImagenMod()
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
    
    //DOWNSAMPLER BASICO
    func downsampler(data: Data, archivo: Archivo) -> UIImage? {
        // Downsamplear
        let targetSize = CGSize(width: 1000, height: 1000)
        let miniatura = self.downsample(imageData: data, to: targetSize)
        
        // Guardar en cache y devolver
        if let thumb = miniatura {
            self.guardarMiniatura(miniatura: thumb, archivo: archivo)
            return thumb
        }
        return nil
    }
    
    //OBTIENE LA PRIMERA MINIATURA
    func obtenerMiniatura(archivo: Archivo) -> UIImage? {
        let key = obtenerLLave(archivoURL: archivo.url)
        if let miniatura = cacheMiniaturas.object(forKey: key) {
            return miniatura
        }
        return nil
    }
    
    // OBTIENE LA PRIMERA MINIATURA
    func obtenerMiniaturaPrimera(archivo: Archivo, color: Color) -> UIImage? {
        let imagenBase = self.imagenBase(tipoArchivo: archivo.fileType, color: color)
        // Intentar sacar la primera página del archivo
        guard let primeraPagina = archivo.obtenerPrimeraPagina(),
              let data = archivo.extraerImagen(nombreImagen: primeraPagina)
        else {
            return imagenBase
        }
        return downsampler(data: data, archivo: archivo) ?? imagenBase
    }
    
    
    //OBTIENE UNA IMAGEN ALEATORIA PERO NUNCA ES LA PRIMERA
    func obtenerMiniaturaAleatoria(archivo: Archivo, color: Color) -> UIImage? {
        // Miniatura base por si falla
        let imagenBase = self.imagenBase(tipoArchivo: archivo.fileType, color: color)
        
        // Pedimos una página aleatoria
        guard let randomPage = archivo.obtenerPaginaAleatoria(),
              let data = archivo.extraerImagen(nombreImagen: randomPage)
        else {
            return imagenBase
        }
        return downsampler(data: data, archivo: archivo) ?? imagenBase
    }
    
    func obtenerMiniaturaPaginaActual(archivo: Archivo, color: Color) -> UIImage? {
        // Miniatura base por si falla
        let imagenBase = self.imagenBase(tipoArchivo: archivo.fileType, color: color)
        
        // Pedimos una página aleatoria
        guard let randomPage = archivo.obtenerPaginaActual(),
              let data = archivo.extraerImagen(nombreImagen: randomPage)
        else {
            return imagenBase
        }
        return downsampler(data: data, archivo: archivo) ?? imagenBase
    }
    
    
    public func obtenerMiniaturaPersonalizada(archivo: Archivo, color: Color, urlMiniatura: URL? = nil) -> UIImage? {
        let imagenBase = self.imagenBase(tipoArchivo: archivo.fileType, color: color)
        guard let url = urlMiniatura else { return imagenBase }
        do {
            // ⚡ No hace falta security scope porque está en tu sandbox
            let data = try Data(contentsOf: url)
            return downsampler(data: data, archivo: archivo) ?? imagenBase
            
        } catch {
//            print("❌ Error cargando imagen personalizada:", error)
            return imagenBase
        }
    }

    
    
    func eliminarMiniatura(archivo: Archivo) {
        let key = obtenerLLave(archivoURL: archivo.url)
        self.cacheMiniaturas.removeObject(forKey: key)
    }
    
    func limpiarCache() {
        
    }
    
}

