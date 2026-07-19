//  WeatherViewModel.swift
import Foundation
import CoreLocation
import Combine

@MainActor
class WeatherViewModel: NSObject, ObservableObject {
    
    // MARK: -Propiedades publicadas (la UI se actualiza automaticamente)
    @Published var weather: WeatherData?
    @Published var forecast: ForecastData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var locationStatus: CLAuthorizationStatus = .notDetermined
    @Published var suggestions: [GeocodingResult] = []
    
    // MARK: -Propiedades privadas
    private let service = WeatherService()
    private let locationManager = CLLocationManager()
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Init
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    // MARK: - Pedir permiso de ubicacion
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Buscar clima por ciudad
    func searchCity() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let weatherResult = service.fetchWeather(city: searchText)
            async let forecastResult = service.fetchForecast(city: searchText)
            
            let (weatherData, forecastData) = try await (weatherResult, forecastResult)
            weather = weatherData
            forecast = forecastData
        } catch {
            errorMessage = "no se encontro la ciudad. Verifica el nombre e intenta de nuevo."
        }
        
        isLoading = false
    }
    
    // MARK: - Buscar clima por coordenadas
    func fetchWeather(lat: Double, lon: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let weatherResult = service.fetchWeather(lat: lat, lon: lon)
            async let forecastResult = service.fetchForecast(lat: lat, lon: lon)
            
            let (weatherData, forecastData) = try await (weatherResult, forecastResult)
            weather = weatherData
            forecast = forecastData
        } catch {
            errorMessage = "no se pudo obtener el clima. Verifica tu conexion."
        }
        
        isLoading = false
    }
    
    // MARK: - Helpers de formato
    var temperatureString: String {
        guard let temp = weather?.main.temp else { return "--" }
              return "\(Int(temp))°"
    }
    
    var cityName: String {
        guard let name = weather?.name,
              let country = weather?.sys.country else { return "---" }
        return "\(name), \(country)"
    }
    
    var conditionDescription: String {
        weather?.weather.first?.description.capitalized ?? "--"
    }
    
    var iconCode: String {
        weather?.weather.first?.icon ?? "01d"
    }
    
    var iconURL: URL? {
        URL(string:"https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            errorMessage = "Permiso de ubicacion denegad. Podes buscar una ciudad manualmente."
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task {
            await fetchWeather(lat: location.coordinate.latitude,
                               lon: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "nose pudo obtener la ubicacion."
    }
    
    // MARK: - Sugerencias en tiempo real (con debounce)
    func updateSuggestions() {
        searchTask?.cancel()
        guard searchText.count >= 2 else {
            suggestions = []
            return
        }
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000) // Espera 0.4s
            guard !Task.isCancelled else { return }
            do {
                suggestions = try await service.searchCities(query: searchText)
            } catch {
                suggestions = []
            }
        }
    }

    // MARK: - Seleccionar una sugerencia (busca por coordenadas, más preciso)
    func selectSuggestion(_ result: GeocodingResult) async {
        isLoading = true
        errorMessage = nil
        suggestions = []
        do {
            async let weatherResult = service.fetchWeather(lat: result.lat, lon: result.lon)
            async let forecastResult = service.fetchForecast(lat: result.lat, lon: result.lon)
            let (weatherData, forecastData) = try await (weatherResult, forecastResult)
            weather = weatherData
            forecast = forecastData
        } catch {
            errorMessage = "No se pudo obtener el clima. Verificá tu conexión."
        }
        isLoading = false
    }
}
