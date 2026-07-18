//
//  ContentView.swift
//  WeatherApp
//
//  Created by Martin Bugao on 18/07/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var showSearch = false
    
    var backgroundColors: [Color] {
        Color.weatherGradient(for: viewModel.weather?.weather.first?.description ?? "")
    }
    
    var body: some View {
        ZStack {
            // Fondo degradado dinámico según el clima
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
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
                        HourlyForecastView()
                        DailyForecastView()
                    } else {
                        WelcomeView()
                            .padding(.top, 80)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.requestLocation()
        }
    }
}
