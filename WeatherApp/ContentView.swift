// ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var showSearch = false
    
    var backgroundColors: [Color] {
        // Usamos 'main' (siempre en inglés) para el gradiente
        let main = viewModel.weather?.weather.first?.main ?? ""
        let isNight = viewModel.iconCode.hasSuffix("n")
        return Color.weatherGradient(for: main, isNight: isNight)
    }
    
    var condition: String {
        // Usamos 'main' (siempre en inglés) para detectar la condición de forma confiable
        // Ejemplos: "Snow", "Rain", "Clear", "Clouds", "Thunderstorm"
        viewModel.weather?.weather.first?.main ?? ""
    }
    
    var body: some View {
        ZStack {
            // Fondo degradado dinámico
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.5), value: viewModel.weather?.name)
            
            // Efecto climático animado (lluvia, nieve, tormenta)
            WeatherEffectView(condition: condition)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HeaderView(showSearch: $showSearch)
                    
                    if viewModel.isLoading {
                        LoadingView()
                            .padding(.top, 100)
                    } else if let error = viewModel.errorMessage {
                        ErrorView(message: error)
                            .padding(.top, 80)
                    } else if viewModel.weather != nil {
                        CurrentWeatherView()
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        HourlyForecastView()
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        DailyForecastView()
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    } else {
                        WelcomeView()
                            .padding(.top, 80)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .refreshable {
                await viewModel.refreshWeather()
            }
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.requestLocation()
        }
        // Haptic feedback al cambiar de ciudad
        .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.weather?.name)
    }
}
