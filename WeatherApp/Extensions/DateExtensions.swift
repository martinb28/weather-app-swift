// Date+Extensions.swift
import Foundation

extension Date {
    // "Lunes", "Martes", etc.
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "es_AR")
        return formatter.string(from: self).capitalized
    }
    
    // "14:00", "17:00", etc.
    var hourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // Convierte timestamp de la API a Date
    static func from(timeInterval: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timeInterval)
    }
}
