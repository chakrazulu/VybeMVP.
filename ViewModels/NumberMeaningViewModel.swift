//
//  NumberMeaningViewModel.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  ViewModel for NumberMeaningsView that handles async loading of rich content
//  from KASPERContentRouter. Implements proper Swift 6 concurrency patterns
//  with weak self in Task blocks per CLAUDE.md requirements.
//

import Foundation
import os.log

@MainActor
final class NumberMeaningViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded(NumberRichContent)
        case empty
        case error(String)
    }

    @Published private(set) var state: State = .idle

    // Use shared router instance to avoid multiple initializations
    private let router = KASPERContentRouter.shared
    private let log = Logger(subsystem: "com.vybe.kasper", category: "NumberMeanings")

    // Simple in-memory cache per app launch
    private var cache: [Int: NumberRichContent] = [:]

    func load(number: Int) {
        // Avoid double-load flicker
        if case .loading = state { return }

        // Check cache first
        if let hit = cache[number] {
            state = .loaded(hit)
            return
        }

        state = .loading

        // Use weak self in Task blocks per CLAUDE.md memory rules
        Task { [weak self] in
            guard let self else { return }

            // Wait for router initialization if needed
            while !self.router.isInitialized {
                try? await Task.sleep(nanoseconds: 30_000_000)
            }

            guard let raw = await self.router.getRichContent(for: number) else {
                self.log.info("No rich content for \(number) → falling back to live templates")
                self.state = .empty
                return
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: raw)
                let decoded = try JSONDecoder().decode(NumberRichContent.self, from: data)
                self.cache[number] = decoded
                self.state = .loaded(decoded)
                self.log.info("✅ Loaded rich content for number \(number)")
            } catch {
                self.log.error("Rich decode failed: \(error.localizedDescription)")
                self.state = .error("Couldn't decode rich content")
            }
        }
    }

    // Clear cache if needed for memory management
    func clearCache() {
        cache.removeAll()
        log.info("Cache cleared")
    }
}
