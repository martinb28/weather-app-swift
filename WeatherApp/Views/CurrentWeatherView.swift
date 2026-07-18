// CurrentWeatherView.swift
import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Ícono del clima desde la API
            AsyncImage(url: viewModel.iconURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "cloud.sun.fill")
                    .resizable().scaledToFit()
                    .foregroundStyle(.white)
            }
            .frame(width: 130, height: 130)
            
            // Temperatura principal
            Text(viewModel.temperatureString)
                .font(.system(size: 96, weight: .thin))
                .foregroundStyle(.white)
                .padding(.top, -10)
            
            // Descripción del clima
            Text(viewModel.conditionDescription)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.bottom, 8)
            
            // Máxima y mínima del día
            if let main = viewModel.weather?.main {
                HStack(spacing: 16) {
                    Label("\(Int(main.tempMax))°", systemImage: "arrow.up")
                    Label("\(Int(main.tempMin))°", systemImage: "arrow.down")
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            }
            
            // Tarjeta de detalles
            if let weather = viewModel.weather {
                HStack(spacing: 0) {
                    WeatherDetailItem(
                        icon: "drop.fill",
                        value: "\(weather.main.humidity)%",
                        label: "Humedad"
                    )
                    Divider()
                        .frame(height: 40)
                        .background(.white.opacity(0.3))
                    WeatherDetailItem(
                        icon: "wind",
                        value: "\(Int(weather.wind.speed * 3.6)) km/h",
                        label: "Viento"
                    )
                    Divider()
                        .frame(height: 40)
                        .background(.white.opacity(0.3))
                    WeatherDetailItem(
                        icon: "thermometer.medium",
                        value: "\(Int(weather.main.feelsLike))°",
                        label: "Sensación"
                    )
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .background(.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 20)
            }
        }
    }
}

// MARK: - Ítem de detalle reutilizable
struct WeatherDetailItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.8))
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}
