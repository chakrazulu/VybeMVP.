// KASPERMLX/MLXCore/RuntimeBundleLoadOrchestrator.swift
import Foundation
import os.log

public final class RuntimeBundleLoadOrchestrator: @unchecked Sendable {
    private let log = Logger(subsystem: "VybeMVP", category: "RuntimeLoad")
    private let indexer: RuntimeBundleIndexer   // your existing indexer
    private let budgetMs: Int

    internal init(indexer: RuntimeBundleIndexer, budgetMs: Int = 500) {
        self.indexer = indexer
        self.budgetMs = budgetMs
    }

    public func loadTiered(manifest: RuntimeBundleManifest, user: RuntimeUserProfile) async {
        // Tier 1: Essential (+user) with hard stop
        await loadWithBudget(files: EssentialPicker.files(for: manifest, user: user), tierName: "essential")

        // Tier 2: Near-term (soft start; only if we're under budget window)
        // NOTE: We hard-stop above; this near-term call is kicked to background with low priority.
        Task.detached(priority: .utility) { [weak self] in
            guard let self else { return }
            await self.preload(files: manifest.near_term, tierName: "near_term")
        }
    }

    private func loadWithBudget(files: [String], tierName: String) async {
        let start = DispatchTime.now()
        await withTaskGroup(of: Void.self) { group in
            for path in files {
                group.addTask { [weak indexer] in
                    guard let indexer else { return }
                    _ = try? await indexer.loadFile(at: path) // your existing async loader
                }
            }
            // Budget enforcement loop
            while !group.isEmpty {
                let elapsedMs = Int( (Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000.0).rounded() )
                if elapsedMs > budgetMs {
                    log.fault("⛔️ Budget exceeded (\(elapsedMs)ms) — aborting \(tierName)")
                    // Cancel remaining tasks in the group
                    group.cancelAll()
                    break
                }
                try? await Task.sleep(nanoseconds: 10_000_000) // 10ms tick
            }
        }
        let endMs = Int( (Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000.0).rounded() )
        log.info("✅ \(tierName) loaded in \(endMs)ms")
    }

    private func preload(files: [String], tierName: String) async {
        for path in files {
            if Task.isCancelled { return }
            _ = try? await indexer.loadFile(at: path)
        }
        log.info("ℹ️ \(tierName) prefetch complete")
    }
}
