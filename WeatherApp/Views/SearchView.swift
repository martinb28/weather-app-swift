// SearchView.swift
import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "1B4F8A"), Color(hex: "2E86C1")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Barra de búsqueda
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white.opacity(0.7))
                        
                        TextField("Buscar ciudad...", text: $viewModel.searchText)
                            .foregroundStyle(.white)
                            .tint(.white)
                            .focused($isSearchFocused)
                            .onChange(of: viewModel.searchText) { _, _ in
                                viewModel.updateSuggestions()
                            }
                            .onSubmit { performSearch() }
                        
                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = ""
                                viewModel.suggestions = []
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding(14)
                    .background(.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            // Sugerencias en tiempo real
                            if !viewModel.suggestions.isEmpty {
                                SearchSectionHeader(title: "Resultados")
                                
                                ForEach(viewModel.suggestions) { result in
                                    Button {
                                        Task {
                                            await viewModel.selectSuggestion(result)
                                            dismiss()
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundStyle(.cyan)
                                            Text(result.displayName)
                                                .foregroundStyle(.white)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.white.opacity(0.4))
                                                .font(.caption)
                                        }
                                        .padding(14)
                                        .background(.white.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            // Ciudades populares (solo cuando no hay texto)
                            if viewModel.searchText.isEmpty {
                                SearchSectionHeader(title: "Ciudades populares")
                                
                                ForEach(suggestedCities, id: \.self) { city in
                                    Button {
                                        viewModel.searchText = city
                                        performSearch()
                                    } label: {
                                        HStack {
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundStyle(.white.opacity(0.7))
                                            Text(city)
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.white.opacity(0.4))
                                                .font(.caption)
                                        }
                                        .padding(14)
                                        .background(.white.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Buscar ciudad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        viewModel.searchText = ""
                        viewModel.suggestions = []
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .onAppear { isSearchFocused = true }
    }
    
    private func performSearch() {
        guard !viewModel.searchText.isEmpty else { return }
        Task {
            await viewModel.searchCity()
            if viewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
    
    private let suggestedCities = [
        "Buenos Aires", "Córdoba", "Rosario", "Mendoza", "Santa Rosa",
        "Madrid", "Barcelona", "Ciudad de México",
        "Nueva York", "Londres", "Tokio", "París"
    ]
}

// MARK: - Header de sección
struct SearchSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.subheadline.bold())
            .foregroundStyle(.white.opacity(0.7))
            .textCase(.uppercase)
            .tracking(1)
            .padding(.horizontal, 20)
            .padding(.top, 8)
    }
}
