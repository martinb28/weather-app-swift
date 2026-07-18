// WeatherService.swift
import Foundation

class WeatherService {
    
    private let apiKey = Constants.apiKey
    private let baseURL = Constants.baseURL
    
    // MARK: - Clima actual por coordenadas (GPS)
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        let urlString = "\(baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=es"
        return try await fetch(urlString: urlString)
    }
    
    // MARK: - Clima actual por nombre de ciudad
    func fetchWeather(city: String) async throws -> WeatherData {
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "\(baseURL)/weather?q=\(cityEncoded)&appid=\(apiKey)&units=metric&lang=es"
        return try await fetch(urlString: urlString)
    }
    
    // MARK: - Pronóstico 5 días por coordenadas
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastData {
        let urlString = "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=es"
        return try await fetch(urlString: urlString)
    }
    
    // MARK: - Pronóstico 5 días por nombre de ciudad
    func fetchForecast(city: String) async throws -> ForecastData {
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "\(baseURL)/forecast?q=\(cityEncoded)&appid=\(apiKey)&units=metric&lang=es"
        return try await fetch(urlString: urlString)
    }
    
    // MARK: - Función genérica de fetch
    private func fetch<T: Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
