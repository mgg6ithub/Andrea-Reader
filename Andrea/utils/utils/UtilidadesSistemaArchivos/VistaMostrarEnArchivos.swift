import SwiftUI
import UIKit

struct FilesAppManager {
    
    // Guardamos una instancia viva del delegate (importantísimo)
    static var documentInteractionControllerDelegate = PreviewDelegate()
    static var currentDocumentController: UIDocumentInteractionController?

    //MARK: --- ABRE EL PREVIEW DE ARCHIVOS CON EL ELEMENTO SELECCIONADO ---
    static func vistaPreviaDeArchivos(url: URL) {
        let documentController = UIDocumentInteractionController(url: url)
        documentController.delegate = documentInteractionControllerDelegate
        
        currentDocumentController = documentController // importante: mantener viva la instancia
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let _ = window.rootViewController {
            
            documentController.presentPreview(animated: true)
        }
    }
    
    //MARK: --- ABRE ARCHIVOS EN EL DIRECTORIO DEL ELEMENTO SELECCIONADO ---
    static func abrirDirectorioDelArchivo(url: URL) {
        let carpeta = url.deletingLastPathComponent()
        let path = carpeta.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
        if let filesUrl = URL(string: path) {
            UIApplication.shared.open(filesUrl, options: [:], completionHandler: nil)
        } else {
            print("No se pudo generar URL shareddocuments para abrir carpeta")
        }
    }

    //MARK: --- ABRE ARCHIVOS EN MODO EXPORTAR CON EL ELEMENTO SELECCIONADO PARA COPIARLO ---
    static func copiarYAbrirEnFiles(url: URL) {
        let documentPicker = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            
            rootViewController.present(documentPicker, animated: true)
        }
    }
    
    static func abrirConOpciones(url: URL, desde view: UIView) {
        let documentController = UIDocumentInteractionController(url: url)
        documentController.delegate = documentInteractionControllerDelegate
        
        currentDocumentController = documentController
        
        // Presentar menú "Abrir con…" anclado a un rectángulo en la vista (puede ser un botón, etc)
        // Aquí usamos el frame completo de la vista para que salga centrado, puedes cambiarlo por el frame de un botón u otro elemento
        documentController.presentOptionsMenu(from: view.bounds, in: view, animated: true)
    }
    
}

// ✅ DELEGADO REQUERIDO
class PreviewDelegate: NSObject, UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        // Devolvemos el rootViewController actual
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            return rootVC
        }
        fatalError("No se pudo obtener rootViewController para vista previa")
    }
}



