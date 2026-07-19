// ForecastData.swift
import Foundation

// MARK: - Pronóstico 5 días / cada 3 horas
struct ForecastData: Codable {
    let list: [ForecastItem]
    let city: ForecastCity
}

struct ForecastItem: Codable, Identifiable {
    let dt: TimeInterval
    let main: MainWeather
    let weather: [WeatherInfo]
    let wind: Wind
    let pop: Double?
    let dtTxt: String

    // Identifiable usando dt (es único por item)
    var id: TimeInterval { dt }

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind, pop
        case dtTxt = "dt_txt"
    }
}

struct ForecastCity: Codable {
    let name: String
    let country: String
}
