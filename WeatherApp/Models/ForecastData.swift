//  ForecastData.swift
import Foundation

// MARK: -Pronostico 5 dias / cada 3 horas
struct ForecastData: Codable {
    let lists: [ForecastItem]
    let city: ForecastCity
}

struct ForecastItem: Codable, Identifiable {
    var id = UUID()
    let dt: TimeInterval //timestamp de la hora
    let main: MainWeather
    let weather: [WeatherInfo]
    let wind: Wind
    let dtTxt: String //fecha en texto "2026-07-18 00:00:00"
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
        case dtTxt = "dt_txt"
    }
}

struct ForecastCity: Codable {
    let name: String
    let country: String
}
