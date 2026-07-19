// CurrentWeatherView.swift
import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Ícono animado
            Image(systemName: viewModel.iconCode.weatherSFSymbol)
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .white.opacity(0.7))
                .frame(width: 120, height: 120)
                .shadow(color: .white.opacity(0.3), radius: 10)
            .scaleEffect(appeared ? 1 : 0.5)
            .opacity(appeared ? 1 : 0)
            
            // Temperatura
            Text(viewModel.temperatureString)
                .font(.system(size: 96, weight: .thin))
                .foregroundStyle(.white)
                .padding(.top, -10)
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
            
            // Descripción
            Text(viewModel.conditionDescription)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.bottom, 8)
            
            // Min / Max
            if let main = viewModel.weather?.main {
                HStack(spacing: 16) {
                    Label("\(Int(main.tempMax))°", systemImage: "arrow.up")
                    Label("\(Int(main.tempMin))°", systemImage: "arrow.down")
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            }
            
            // Tarjeta de detalles principal
            if let weather = viewModel.weather {
                VStack(spacing: 0) {
                    // Fila 1: Humedad, Viento, Sensación
                    HStack(spacing: 0) {
                        WeatherDetailItem(
                            icon: "drop.fill",
                            value: "\(weather.main.humidity)%",
                            label: "Humedad"
                        )
                        DetailDivider()
                        WeatherDetailItem(
                            icon: "wind",
                            value: "\(Int(weather.wind.speed * 3.6)) km/h",
                            label: "Viento"
                        )
                        DetailDivider()
                        WeatherDetailItem(
                            icon: "thermometer.medium",
                            value: "\(Int(weather.main.feelsLike))°",
                            label: "Sensación"
                        )
                    }
                    
                    .padding(.vertical, 8)
                    Divider()
                        .background(.white.opacity(0.2))
                        .padding(.vertical, 6)
                    
                    // Fila 2: Amanecer, Atardecer, Visibilidad, Presión
                    HStack(spacing: 0) {
                        WeatherDetailItem(
                            icon: "sunrise.fill",
                            value: viewModel.sunriseString,
                            label: "Amanecer"
                        )
                        DetailDivider()
                        WeatherDetailItem(
                            icon: "sunset.fill",
                            value: viewModel.sunsetString,
                            label: "Atardecer"
                        )
                        DetailDivider()
                        WeatherDetailItem(
                            icon: "eye.fill",
                            value: viewModel.visibilityString,
                            label: "Visibilidad"
                        )
                        DetailDivider()
                        WeatherDetailItem(
                            icon: "gauge.medium",
                            value: viewModel.pressureString,
                            label: "Presión"
                        )
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.ultraThinMaterial.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.top, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 30)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.7)) {
                appeared = true
            }
        }
        .onChange(of: viewModel.weather?.name) { _, _ in
            appeared = false
            withAnimation(.spring(duration: 0.7)) {
                appeared = true
            }
        }
    }
}

// MARK: - Divisor vertical
struct DetailDivider: View {
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.2))
            .frame(width: 1, height: 40)
    }
}

// MARK: - Ítem de detalle
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
                .font(.footnote.bold())
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}
