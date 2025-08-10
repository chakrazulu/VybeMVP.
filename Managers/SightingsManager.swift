//
//  SightingsManager.swift
//  VybeMVP
//
//  Manages all sighting-related operations including creation, storage, and retrieval
//

import Foundation
import CoreData
import CoreLocation
import UIKit
import Combine

/**
 * SightingsManager handles all operations related to number sightings
 * including creating, storing, retrieving, and analyzing sightings.
 */
class SightingsManager: ObservableObject {

    // MARK: - Singleton
    static let shared = SightingsManager()

    // MARK: - Published Properties
    @Published var sightings: [Sighting] = []
    @Published var isLoading = false
    @Published var todaysSightingsCount = 0
    @Published var totalSightingsCount = 0

    // MARK: - Properties
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    private init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        loadSightings()
        setupObservers()
    }

    // MARK: - Setup
    private func setupObservers() {
        // Observe when app becomes active to refresh counts
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.refreshCounts()
            }
            .store(in: &cancellables)
    }

    // MARK: - CRUD Operations

    /**
     * Creates a new sighting entry
     */
    func createSighting(
        number: Int,
        title: String? = nil,
        note: String? = nil,
        significance: String? = nil,
        image: UIImage? = nil,
        location: CLLocation? = nil,
        locationName: String? = nil
    ) {
        let newSighting = Sighting(context: viewContext)
        newSighting.id = UUID()
        newSighting.timestamp = Date()
        newSighting.numberSpotted = Int16(number)
        newSighting.title = title ?? "Spotted \(number)"
        newSighting.note = note
        newSighting.significance = significance

        // Convert and store image data
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            newSighting.imageData = imageData
        }

        // Store location data
        if let location = location {
            newSighting.locationLatitude = location.coordinate.latitude
            newSighting.locationLongitude = location.coordinate.longitude
        }
        newSighting.locationName = locationName

        saveContext()
        loadSightings()

        print("✨ Created new sighting for number \(number)")
    }

    /**
     * Updates an existing sighting
     */
    func updateSighting(
        _ sighting: Sighting,
        title: String? = nil,
        note: String? = nil,
        significance: String? = nil,
        image: UIImage? = nil
    ) {
        if let title = title {
            sighting.title = title
        }
        if let note = note {
            sighting.note = note
        }
        if let significance = significance {
            sighting.significance = significance
        }
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            sighting.imageData = imageData
        }

        saveContext()
        loadSightings()
    }

    /**
     * Deletes a sighting
     */
    func deleteSighting(_ sighting: Sighting) {
        viewContext.delete(sighting)
        saveContext()
        loadSightings()
    }

    // MARK: - Data Loading

    /**
     * Loads all sightings from Core Data
     */
    func loadSightings() {
        let request: NSFetchRequest<Sighting> = Sighting.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        do {
            sightings = try viewContext.fetch(request)
            refreshCounts()
            print("📖 Loaded \(sightings.count) sightings")
        } catch {
            print("❌ Failed to load sightings: \(error)")
        }
    }

    /**
     * Refreshes sighting counts for statistics
     */
    private func refreshCounts() {
        totalSightingsCount = sightings.count

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        todaysSightingsCount = sightings.filter { sighting in
            guard let timestamp = sighting.timestamp else { return false }
            return timestamp >= startOfDay
        }.count
    }

    // MARK: - Filtering Methods

    /**
     * Returns sightings for a specific number
     */
    func sightingsForNumber(_ number: Int) -> [Sighting] {
        return sightings.filter { $0.numberSpotted == number }
    }

    /**
     * Returns sightings from today
     */
    func todaysSightings() -> [Sighting] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())

        return sightings.filter { sighting in
            guard let timestamp = sighting.timestamp else { return false }
            return timestamp >= startOfDay
        }
    }

    /**
     * Returns sightings from the past week
     */
    func thisWeeksSightings() -> [Sighting] {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return [] }

        return sightings.filter { sighting in
            guard let timestamp = sighting.timestamp else { return false }
            return timestamp >= weekAgo
        }
    }

    // MARK: - Analytics

    /**
     * Returns the most frequently spotted numbers
     */
    func mostFrequentNumbers(limit: Int = 5) -> [(number: Int, count: Int)] {
        let numberCounts = Dictionary(grouping: sightings) { Int($0.numberSpotted) }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(limit)
            .map { (number: $0.key, count: $0.value) }

        return Array(numberCounts)
    }

    /**
     * Returns sightings grouped by date
     */
    func sightingsGroupedByDate() -> [(date: Date, sightings: [Sighting])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: sightings) { sighting -> Date in
            guard let timestamp = sighting.timestamp else { return Date() }
            return calendar.startOfDay(for: timestamp)
        }

        return grouped.sorted { $0.key > $1.key }
            .map { (date: $0.key, sightings: $0.value) }
    }

    // MARK: - Image Handling

    /**
     * Converts sighting image data to UIImage
     */
    func getImage(for sighting: Sighting) -> UIImage? {
        guard let imageData = sighting.imageData else { return nil }
        return UIImage(data: imageData)
    }

    // MARK: - Location

    /**
     * Gets CLLocation from sighting coordinates
     */
    func getLocation(for sighting: Sighting) -> CLLocation? {
        guard sighting.locationLatitude != 0 || sighting.locationLongitude != 0 else { return nil }
        return CLLocation(
            latitude: sighting.locationLatitude,
            longitude: sighting.locationLongitude
        )
    }

    // MARK: - Private Methods

    private func saveContext() {
        guard viewContext.hasChanges else { return }

        // Use background context to avoid blocking main thread
        PersistenceController.shared.save()
        print("✅ Sightings context saved successfully (background context)")
    }
}
