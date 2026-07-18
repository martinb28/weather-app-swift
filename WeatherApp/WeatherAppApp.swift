//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Martin Bugao on 18/07/2026.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
