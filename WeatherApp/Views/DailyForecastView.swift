// DailyForecastView.swift
import SwiftUI

struct DailyForecastView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    // Agrupamos los items por día y tomamos uno por día (el del mediodía)
    var dailyItems: [ForecastItem] {
        guard let list = viewModel.forecast?.list else { return [] }
        
        var seen = Set<String>()
        return list.filter { item in
            let day = String(item.dtTxt.prefix(10)) // "2024-01-15"
            return seen.insert(day).inserted
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Título de la sección
            Label("Próximos días", systemImage: "calendar")
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.7))
                .textCase(.uppercase)
                .tracking(1)
            
            VStack(spacing: 0) {
                ForEach(Array(dailyItems.enumerated()), id: \.element.id) { index, item in
                    DailyItemView(item: item, isFirst: index == 0)
                    
                    if index < dailyItems.count - 1 {
                        Divider()
                            .background(.white.opacity(0.2))
                    }
                }
            }
        }
        .padding(16)
        .background(.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Fila individual por día
struct DailyItemView: View {
    let item: ForecastItem
    let isFirst: Bool
    
    var date: Date {
        Date.from(timeInterval: item.dt)
    }
    
    var iconURL: URL? {
        guard let icon = item.weather.first?.icon else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
    
    var dayLabel: String {
        isFirst ? "Hoy" : date.dayName
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Día de la semana
            Text(dayLabel)
                .font(.subheadline)
                .foregroundStyle(.white)
                .frame(width: 80, alignment: .leading)
            
            // Ícono del clima
            Image(systemName: (item.weather.first?.icon ?? "01d").weatherSFSymbol)
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .white.opacity(0.6))
                .frame(width: 28, height: 28)
            
            // Descripción
            Text(item.weather.first?.description.capitalized ?? "")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Temperaturas min / max
            HStack(spacing: 8) {
                Text("\(Int(item.main.tempMin))°")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
                
                Text("\(Int(item.main.tempMax))°")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }
        }
        .padding(.vertical, 12)
    }
}
