import SwiftUI

class NotificacionesEstado: ObservableObject {
    
    static let ne: NotificacionesEstado = NotificacionesEstado()
    
    @Published var historialNotificacionesEstado: [NotificacionLog] = []
    @Published var nuevaNotificacion: Bool = false
    
    private init() {
        historialNotificacionesEstado.append(NotificacionLog(mensaje: "Batman nuevo nombre importado", icono: "Archivo-creado", color: .green))

        historialNotificacionesEstado.append(NotificacionLog(mensaje: "Batman nuevo nombre eliminado", icono: "Archivo-eliminado", color: .red))

        historialNotificacionesEstado.append(NotificacionLog(mensaje: "Coleccion \"Transformers\" creada.", icono: "Coleccion-creado", color: .green))

        historialNotificacionesEstado.append(NotificacionLog(mensaje: "Coleccion \"Transformers\" eliminada.", icono: "Coleccion-eliminado", color: .red))

        historialNotificacionesEstado.append(NotificacionLog(mensaje: "Coleccion \"Transformers mas largo este e sun nnombre\" eliminada.", icono: "Coleccion-eliminado", color: .red))

        historialNotificacionesEstado.append(NotificacionLog(mensaje: "Renombrado de \"Transformers\" -> \"nuevo nombre\".", icono: "cambio-nombre", color: .orange))
    }
    
    public func crearLog(mensaje: String, icono: String, color: Color) {
        historialNotificacionesEstado.append(NotificacionLog(mensaje: mensaje, icono: icono, color: color))
        self.nuevaNotificacion.toggle()
    }
    
}
