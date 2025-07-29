/**
 * CosmicSnapshotViewModel.swift
 * 
 * 🏗️ PROPER ARCHITECTURE - VIEWMODEL LAYER
 * 
 * SINGLE RESPONSIBILITY: 
 * Handle UI state management and coordinate between repository and view.
 * Transform data models into UI-friendly formats.
 * 
 * CLEAN SEPARATION:
 * - Repository handles data/calculations
 * - ViewModel handles UI state/logic  
 * - View handles pure presentation
 */

import Foundation
import Combine

@MainActor
class CosmicSnapshotViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isExpanded: Bool = false
    @Published var selectedPlanet: String? = nil
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    
    // UI-Specific Data
    @Published var moonDisplayData: PlanetDisplayData?
    @Published var sunDisplayData: PlanetDisplayData?
    @Published var planetDisplayData: [PlanetDisplayData] = []
    @Published var currentSeason: String = "Loading..."
    
    // MARK: - Computed Properties
    
    var shouldShowLoadingState: Bool {
        return isLoading || (moonDisplayData == nil && sunDisplayData == nil)
    }
    
    var primaryPlanets: [PlanetDisplayData] {
        return planetDisplayData.filter { ["Mercury", "Venus", "Mars"].contains($0.planet) }
    }
    
    var outerPlanets: [PlanetDisplayData] {
        return planetDisplayData.filter { ["Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"].contains($0.planet) }
    }
    
    func formatLastUpdate() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return "Updated: \(formatter.string(from: Date()))"
    }
    
    // MARK: - Dependencies
    
    private var repository: CosmicDataRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(repository: CosmicDataRepositoryProtocol) {
        self.repository = repository
        setupDataObserver()
        loadInitialData()
    }
    
    // MARK: - Public Methods
    
    func toggleExpanded() {
        isExpanded.toggle()
    }
    
    func selectPlanet(_ planet: String) {
        selectedPlanet = planet
    }
    
    func refreshData() {
        Task {
            await repository.refreshData()
        }
    }
    
    func setRepository(_ newRepository: CosmicDataRepositoryProtocol) async {
        // Cancel existing subscriptions
        cancellables.removeAll()
        
        // Update repository
        repository = newRepository
        
        // Setup new data observer
        setupDataObserver()
        
        // Load initial data from new repository
        loadInitialData()
    }
    
    func getDetailedPlanetInfo(for planet: String) async -> PlanetDisplayData? {
        guard let planetaryData = await repository.getDetailedPlanetaryInfo(for: planet) else {
            return nil
        }
        
        return PlanetDisplayData(from: planetaryData)
    }
    
    // MARK: - Private Methods
    
    private func setupDataObserver() {
        repository.snapshotPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.handleSnapshotUpdate(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func loadInitialData() {
        Task {
            await repository.refreshData()
        }
    }
    
    private func handleSnapshotUpdate(_ snapshot: CosmicSnapshot) {
        // Update loading and error states
        isLoading = snapshot.isLoading
        errorMessage = snapshot.error
        
        // Transform data models to display models
        moonDisplayData = PlanetDisplayData(from: snapshot.moonData)
        sunDisplayData = PlanetDisplayData(from: snapshot.sunData)
        planetDisplayData = snapshot.planetaryData.map { PlanetDisplayData(from: $0) }
        currentSeason = snapshot.currentSeason
        
        print("🎨 ViewModel updated with new cosmic data")
    }
}

// MARK: - Display Data Models

struct PlanetDisplayData: Identifiable {
    let id = UUID()
    let planet: String
    let emoji: String
    let currentSign: String
    let isRetrograde: Bool
    let nextTransit: String
    let status: String
    let color: String
    let lastUpdated: Date
    
    init(from planetaryData: PlanetaryData) {
        self.planet = planetaryData.planet
        self.emoji = planetaryData.emoji
        self.currentSign = planetaryData.currentSign
        self.isRetrograde = planetaryData.isRetrograde
        self.nextTransit = planetaryData.nextTransit ?? "Unknown"
        self.lastUpdated = planetaryData.lastUpdated
        
        // Generate UI-specific properties
        self.status = planetaryData.isRetrograde ? "Retrograde ℞" : "Direct"
        self.color = Self.getColorForPlanet(planetaryData.planet)
    }
    
    private static func getColorForPlanet(_ planet: String) -> String {
        switch planet {
        case "Sun": return "yellow"
        case "Moon": return "silver"
        case "Mercury": return "orange"
        case "Venus": return "green"
        case "Mars": return "red"
        case "Jupiter": return "blue"
        case "Saturn": return "purple"
        case "Uranus": return "cyan"
        case "Neptune": return "indigo"
        case "Pluto": return "brown"
        default: return "white"
        }
    }
    
    var displayText: String {
        if currentSign == "Loading..." {
            return "Loading..."
        }
        return "\(currentSign)\(isRetrograde ? " ℞" : "")"
    }
    
    var isLoading: Bool {
        currentSign == "Loading..."
    }
}

// MARK: - UI Helper Extensions

