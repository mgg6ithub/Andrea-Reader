
import SwiftUI
import UniformTypeIdentifiers


struct DocumentPicker: UIViewControllerRepresentable {
    
    // Closure para manejar la URL seleccionada
    var onPick: ([URL]) -> Void
    var onCancel: () -> Void // Nuevo closure para manejar la cancelación
    var allowMultipleSelection: Bool = false
    var contentTypes: [UTType] = [.item] // Por defecto, permite seleccionar cualquier tipo de archivo
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes)
        picker.allowsMultipleSelection = allowMultipleSelection
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // No es necesario actualizar nada aquí
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPick: onPick, onCancel: onCancel)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: ([URL]) -> Void
        let onCancel: () -> Void // Closure de cancelación
        
        init(onPick: @escaping ([URL]) -> Void, onCancel: @escaping () -> Void) {
            self.onPick = onPick
            self.onCancel = onCancel
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPick(urls)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("El usuario canceló la selección.")
            onCancel() // Llamar al closure de cancelación
        }
    }
}


