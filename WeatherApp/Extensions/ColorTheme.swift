// Color+Theme.swift
import SwiftUI

extension Color {
    // MARK: - Gradientes por condición climática
    // MARK: - Gradientes por condición climática
    // Usa el campo 'main' de la API (siempre en inglés): Snow, Rain, Thunderstorm, Clouds, Clear
    static func weatherGradient(for condition: String, isNight: Bool = false) -> [Color] {
        let c = condition.lowercased()
        if c.contains("thunderstorm") || c.contains("tormenta") {
            return [Color(hex: "0D0D1A"), Color(hex: "1A1A2E"), Color(hex: "16213E")]
        } else if c.contains("drizzle") || c.contains("rain") || c.contains("lluvia") {
            return isNight
                ? [Color(hex: "1A2540"), Color(hex: "2C3E6B"), Color(hex: "3D5080")]
                : [Color(hex: "2C3E6B"), Color(hex: "4A6FA5"), Color(hex: "6B8FBF")]
        } else if c.contains("snow") || c.contains("nieve") {
            return isNight
                ? [Color(hex: "2C3E55"), Color(hex: "4A6480"), Color(hex: "7A9CB5")]
                : [Color(hex: "5B7FA6"), Color(hex: "8EB4D4"), Color(hex: "C8DFF0")]
        } else if c.contains("atmosphere") || c.contains("fog") || c.contains("mist")
                    || c.contains("haze") || c.contains("smoke") || c.contains("niebla") {
            return isNight
                ? [Color(hex: "2A3040"), Color(hex: "4A5568"), Color(hex: "6B7A8D")]
                : [Color(hex: "5F6B7A"), Color(hex: "8A9BB0"), Color(hex: "B8C8D8")]
        } else if c.contains("cloud") || c.contains("nube") {
            return isNight
                ? [Color(hex: "1A2030"), Color(hex: "2D3748"), Color(hex: "4A5568")]
                : [Color(hex: "4A5568"), Color(hex: "718096"), Color(hex: "A0AEC0")]
        } else {
            // Clear — día: azul y naranja / noche: azul oscuro y violeta
            return isNight
                ? [Color(hex: "0A0E2A"), Color(hex: "1A2456"), Color(hex: "2D3A8C")]
                : [Color(hex: "1B4F8A"), Color(hex: "2E86C1"), Color(hex: "F39C12")]
        }
    }
    
    // MARK: - Init desde HEX
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Mapeo de código de ícono → SF Symbol
extension String {
    var weatherSFSymbol: String {
        switch self {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "cloud.snow.fill"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
