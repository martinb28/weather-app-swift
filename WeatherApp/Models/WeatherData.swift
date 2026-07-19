//WeatherData.swift
import Foundation

//MARK: Clima Actual
struct WeatherData: Codable {
    let name: String //Nombre de la ciudad
    let main: MainWeather
    let weather: [WeatherInfo]
    let wind: Wind
    let sys: Sys
    let visibility: Int
}

struct MainWeather: Codable {
    let temp: Double      //temperatura actual
    let feelsLike: Double //sensacion termica
    let tempMin: Double   //minima del dia
    let tempMax: Double   //maxima del dia
    let humidity: Int     //humedad en %
    let pressure: Int     //presion atmosferica
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
        case pressure
    }
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String         //ej: "Rain", "Clear"
    let description: String  //ej: "lluvia moderada"
    let icon: String         // ej: "10d"
}

struct Wind: Codable {
    let speed: Double //Velocidad en m/s
    let deg: Int      //Direccion en grados
}

struct Sys: Codable {
    let country: String //codigo del pais, ej: "AR"
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

// MARK: - Geocoding (sugerencias de ciudades)
struct GeocodingResult: Codable, Identifiable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    var id: String { "\(lat)-\(lon)" }
    
    var displayName: String {
        [name, state, country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
