//
//  Phase2BAdapters.swift
//  VybeMVP
//
//  Phase 2B compatibility adapters for existing managers
//  Provides shims without modifying sacred manager APIs
//

import Foundation

// MARK: - Manager Adapters for Phase 2B

extension FocusNumberManager {
    var currentFocus: Int {
        selectedFocusNumber
    }
    var currentRealm: Int {
        realmNumber
    }
}

extension MeditationHistoryManager {
    var lastSession: MeditationSession? {
        sessions.last
    }
}

extension JournalManager {
    var recentEntries: [JournalEntry] {
        Array(entries.prefix(10))
    }
}
