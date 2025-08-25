// KASPERMLX/MLXCore/RuntimeBundleEssentials.swift
import Foundation

public struct RuntimeUserProfile: Sendable {
    public let lifePathNumber: Int
    public let soulUrgeNumber: Int
    public let focusNumber: Int

    public init(lifePathNumber: Int, soulUrgeNumber: Int, focusNumber: Int) {
        self.lifePathNumber = lifePathNumber
        self.soulUrgeNumber = soulUrgeNumber
        self.focusNumber = focusNumber
    }
}

public enum EssentialPicker {
    public static func files(for manifest: RuntimeBundleManifest, user: RuntimeUserProfile) -> [String] {
        var files = manifest.essential
        files.append("Behavioral/lifePathNumber_\(user.lifePathNumber)_converted.json")
        files.append("Behavioral/soulUrge_\(user.soulUrgeNumber)_v3.0_converted.json")
        files.append("EnhancedNumbers/NumberMessages_Complete_\(user.focusNumber).json")
        // Dedup to be safe
        return Array(Set(files))
    }
}
