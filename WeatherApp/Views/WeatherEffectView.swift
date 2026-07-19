// WeatherEffectView.swift
import SwiftUI

// MARK: - Selector de efecto según condición
// Recibe el campo 'main' de la API: "Snow", "Rain", "Drizzle", "Thunderstorm", etc.
struct WeatherEffectView: View {
    let condition: String
    
    var body: some View {
        let c = condition.lowercased()
        if c.contains("thunderstorm") || c.contains("tormenta") {
            ThunderEffectView()
        } else if c.contains("rain") || c.contains("drizzle") || c.contains("lluvia") {
            RainEffectView()
        } else if c.contains("snow") || c.contains("nieve") {
            SnowEffectView()
        }
    }
}

// MARK: - Lluvia
struct RainDrop: Identifiable {
    let id = UUID()
    let x: CGFloat = .random(in: 0...1)
    let y: CGFloat = .random(in: 0...1)
    let speed: Double = .random(in: 0.6...1.4)
    let opacity: Double = .random(in: 0.1...0.35)
    let length: CGFloat = .random(in: 10...20)
}

struct RainEffectView: View {
    let drops: [RainDrop] = (0..<70).map { _ in RainDrop() }
    
    var body: some View {
        TimelineView(.animation) { context in
            Canvas { canvas, size in
                let time = context.date.timeIntervalSinceReferenceDate
                for drop in drops {
                    let x = (drop.x * size.width + CGFloat(time) * 30)
                        .truncatingRemainder(dividingBy: size.width + 40)
                    let y = (drop.y * size.height + CGFloat(time) * drop.speed * 220)
                        .truncatingRemainder(dividingBy: size.height + 20)
                    
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + 4, y: y + drop.length))
                    
                    canvas.stroke(
                        path,
                        with: .color(.white.opacity(drop.opacity)),
                        lineWidth: 1.2
                    )
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

// MARK: - Nieve
struct Snowflake: Identifiable {
    let id = UUID()
    let x: CGFloat = .random(in: 0...1)
    let y: CGFloat = .random(in: 0...1)
    let size: CGFloat = .random(in: 3...8)
    let fallSpeed: Double = .random(in: 0.05...0.2)
    let swaySpeed: Double = .random(in: 0.3...0.8)
    let phase: Double = .random(in: 0...Double.pi * 2)
    let opacity: Double = .random(in: 0.3...0.7)
}

struct SnowEffectView: View {
    let flakes: [Snowflake] = (0..<45).map { _ in Snowflake() }
    
    var body: some View {
        TimelineView(.animation) { context in
            Canvas { canvas, size in
                let time = context.date.timeIntervalSinceReferenceDate
                for flake in flakes {
                    let x = (flake.x * size.width
                             + sin(time * flake.swaySpeed + flake.phase) * 25)
                        .truncatingRemainder(dividingBy: size.width)
                    let y = (flake.y * size.height + CGFloat(time) * flake.fallSpeed * 60)
                        .truncatingRemainder(dividingBy: size.height + 10)
                    
                    let rect = CGRect(x: x, y: y, width: flake.size, height: flake.size)
                    canvas.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(flake.opacity))
                    )
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

// MARK: - Tormenta (lluvia + relámpago)
struct ThunderEffectView: View {
    @State private var flashOpacity: Double = 0
    
    var body: some View {
        ZStack {
            RainEffectView()
            
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .onAppear { scheduleFlash() }
    }
    
    private func scheduleFlash() {
        let delay = Double.random(in: 3...9)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeIn(duration: 0.04)) { flashOpacity = 0.4 }
            withAnimation(.easeOut(duration: 0.4).delay(0.04)) { flashOpacity = 0 }
            scheduleFlash()
        }
    }
}
