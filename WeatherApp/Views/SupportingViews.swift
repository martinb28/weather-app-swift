// SupportingViews.swift
import SwiftUI

// MARK: - Header
struct HeaderView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @Binding var showSearch: Bool
    @State private var isRefreshing = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(Date().formatted(.dateTime.weekday(.wide).day().month()))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(viewModel.cityName == "---" ? "WeatherApp" : viewModel.cityName)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
            Spacer()
            
            HStack(spacing: 10) {
                // Botón refresh con animación
                Button {
                    guard !isRefreshing else { return }
                    Task {
                        isRefreshing = true
                        await viewModel.refreshWeather()
                        isRefreshing = false
                    }
                } label: {
                    Group {
                        if isRefreshing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.2))
                    .clipShape(Circle())
                }
                
                // Botón búsqueda
                Button { showSearch = true } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.top, 10)
    }
}

// MARK: - Loading
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 60, height: 60)
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            }
            Text("Obteniendo clima...")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .onAppear { isAnimating = true }
    }
}

// MARK: - Error
struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.white.opacity(0.8))
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Welcome
struct WelcomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .symbolEffect(.bounce, options: .repeating)
            
            VStack(spacing: 8) {
                Text("Bienvenido a WeatherApp")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("Permitir el acceso a la ubicación para ver el clima de donde estás, o buscá una ciudad.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button { viewModel.requestLocation() } label: {
                HStack {
                    Image(systemName: "location.fill")
                    Text("Usar mi ubicación")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.white.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(20)
    }
}
