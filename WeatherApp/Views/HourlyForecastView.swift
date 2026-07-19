// HourlyForecastView.swift
import SwiftUI

struct HourlyForecastView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    // Tomamos solo las próximas 24 horas (8 intervalos de 3h)
    var hourlyItems: [ForecastItem] {
        Array(viewModel.forecast?.list.prefix(8) ?? [])
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Título de la sección
            Label("Próximas horas", systemImage: "clock")
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.7))
                .textCase(.uppercase)
                .tracking(1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(hourlyItems) { item in
                        HourlyItemView(item: item)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(16)
        .background(.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Ítem individual por hora
struct HourlyItemView: View {
    let item: ForecastItem
    
    var date: Date {
        Date.from(timeInterval: item.dt)
    }
    
    var iconURL: URL? {
        guard let icon = item.weather.first?.icon else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
    
    var isNow: Bool {
        // Marcamos el primer ítem como "Ahora"
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .hour)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Hora
            Text(isNow ? "Ahora" : date.hourString)
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(isNow ? 1 : 0.7))
            
            // Ícono del clima
            AsyncImage(url: iconURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "cloud.fill")
                    .resizable().scaledToFit()
                    .foregroundStyle(.white.opacity(0.5))
            }
            .frame(width: 36, height: 36)
            
            // Temperatura
            Text("\(Int(item.main.temp))°")
                .font(.subheadline.bold())
                .foregroundStyle(.white)
            
            // Probabilidad de lluvia si > 20%
            if let pop = item.pop, pop > 0.2 {
                Text("\(Int(pop * 100))%")
                    .font(.caption2)
                    .foregroundStyle(.cyan.opacity(0.9))
            }
        }
        .frame(width: 60)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(isNow ? .white.opacity(0.25) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
