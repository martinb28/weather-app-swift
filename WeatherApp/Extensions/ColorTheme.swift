// Color+Theme.swift
import SwiftUI

extension Color {
    // MARK: - Gradientes por condición climática
    static func weatherGradient(for condition: String) -> [Color] {
        switch condition.lowercased() {
        case let c where c.contains("lluvia") || c.contains("rain") || c.contains("drizzle"):
            return [Color(hex: "2C3E6B"), Color(hex: "4A6FA5"), Color(hex: "6B8FBF")]
        case let c where c.contains("nube") || c.contains("cloud"):
            return [Color(hex: "4A5568"), Color(hex: "718096"), Color(hex: "A0AEC0")]
        case let c where c.contains("tormenta") || c.contains("thunder"):
            return [Color(hex: "1A1A2E"), Color(hex: "16213E"), Color(hex: "0F3460")]
        case let c where c.contains("nieve") || c.contains("snow"):
            return [Color(hex: "6B8FA8"), Color(hex: "A8C5DA"), Color(hex: "D4E9F7")]
        case let c where c.contains("niebla") || c.contains("fog") || c.contains("mist"):
            return [Color(hex: "5F6B7A"), Color(hex: "8A9BB0"), Color(hex: "B8C8D8")]
        default: // Despejado / soleado
            return [Color(hex: "1B4F8A"), Color(hex: "2E86C1"), Color(hex: "F39C12")]
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
