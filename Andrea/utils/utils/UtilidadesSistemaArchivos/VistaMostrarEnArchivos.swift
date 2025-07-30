
import SwiftUI
import UIKit

// OPCIÓN 1: Usando UIDocumentInteractionController (iOS)
class DocumentInteractionManager: NSObject, ObservableObject {
    private var documentInteractionController: UIDocumentInteractionController?
    
    func mostrarEnArchivos(url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("El archivo no existe: \(url.path)")
            return
        }
        
        documentInteractionController = UIDocumentInteractionController(url: url)
        documentInteractionController?.delegate = self
        
        // Obtener el view controller actual
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            
            // Mostrar el menú de opciones
            documentInteractionController?.presentOptionsMenu(from: CGRect(x: 0, y: 0, width: 100, height: 100),
                                                            in: rootViewController.view,
                                                            animated: true)
        }
    }
}

extension DocumentInteractionManager: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.rootViewController ?? UIViewController()
    }
}

// OPCIÓN 2: Usando QuickLook para previsualización
import QuickLook

class QuickLookManager: NSObject, ObservableObject, QLPreviewControllerDataSource {
    @Published var isPresented = false
    private var fileURL: URL?
    
    func mostrarArchivo(url: URL) {
        self.fileURL = url
        self.isPresented = true
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return fileURL != nil ? 1 : 0
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURL as? QLPreviewItem ?? URL(fileURLWithPath: "") as QLPreviewItem
    }
}

// OPCIÓN 3: Usando Files app URL scheme (iOS)
struct FilesAppManager {
    static func abrirEnFilesApp(url: URL) {
        // Para iOS 13+, puedes usar el esquema de URL de Files
        let filesURL = URL(string: "shareddocuments://\(url.path)")
        
        if let filesURL = filesURL, UIApplication.shared.canOpenURL(filesURL) {
            UIApplication.shared.open(filesURL)
        } else {
            // Fallback: usar UIDocumentInteractionController
            print("No se pudo abrir en Files app, usando método alternativo")
        }
    }
}

struct QuickLookView: UIViewControllerRepresentable {
    let manager: QuickLookManager
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = manager
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
        // No necesita actualizaciones
    }
}



