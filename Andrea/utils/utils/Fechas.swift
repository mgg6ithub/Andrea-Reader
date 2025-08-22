

import SwiftUI

/*-----------------------------------------*/
/** FECHAS **/
/*-----------------------------------------*/

struct Fechas {
    
    func stringOnlyYearToDate(year: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = 1
        components.day = 1
        
        return Calendar.current.date(from: components)
    }
    
    
    func extractYearFromDate(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }

    
    /**
     Metodo para formatear la fecha y en texto. Ejemplo: "25 ene 2025 at 10:30"
     */
    
    func formatDate1(_ date: Date) -> String {
        let formatter = DateFormatter()
        //MARK: - --- CAMBIAR SEGUN EL PAIS ---
        formatter.locale = Locale(identifier: "es_ES")
        //MARK: - --- CAMBIAR SEGUN EL PAIS ---
        formatter.dateStyle = .medium  // Ejemplo: "25 ene 2025"
        formatter.timeStyle = .short   // Ejemplo: "10:30 AM"
        return formatter.string(from: date)
    }
    
    func parseDate1(_ string: String) -> Date? {
        let formatter = DateFormatter()
        //MARK: - --- CAMBIAR SEGUN EL PAIS ---
        formatter.locale = Locale(identifier: "es_ES") //CAMBIAR SEGUN EL PAIS
        //MARK: - --- CAMBIAR SEGUN EL PAIS ---
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.date(from: string)
    }

    
    /**
     Metodo para formatear la fecha y hora. Ejemplo: "25/01/2025 at 10:30"
     */
    
    func formatDate2(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter.string(from: date)
    }
    
    /**
     Metodo para formatear la fecha y hora. Ejemplo: "25-01-2025 at 10:30"
     */
    func formatDate3(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    /**
     Metodo para formatear la fecha. Ejemplo: Martes, 04 de Febrero de 2025
     */
    func formatDate4(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd 'de' MMMM 'de' yyyy"
        return formatter.string(from: date)
    }
    
        
    /// Extrae el año (4 dígitos dentro de paréntesis) del nombre del archivo
    func extraerAno(from text: String) -> String? {
        let pattern = #"\((\d{4})\)"#  // Busca (YYYY)
        return ManipulacionCadenas().extractFirstMatch(from: text, pattern: pattern)
    }
    
}
