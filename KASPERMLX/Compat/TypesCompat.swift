//
//  TypesCompat.swift
//  VybeMVP
//
//  Purpose: Compatibility layer for Phase 2B type transitions
//  Provides safe conversion utilities between legacy flexible types and strict Sendable types
//

import Foundation

// MARK: - Type Aliases

/// Standardized metadata type for Sendable compliance
public typealias InsightMetadata = [String: String]

// MARK: - Metadata Conversion Utilities

/// Safe conversion utilities for legacy metadata handling
public enum Meta {
    /// Convert flexible dictionary to strict String metadata
    /// Handles common types (String, Number, Bool, etc.) gracefully
    @inline(__always)
    public static func stringify(_ raw: [String: Any]) -> InsightMetadata {
        var out: [String: String] = [:]
        for (k, v) in raw {
            switch v {
            case let s as String:
                out[k] = s
            case let n as NSNumber:
                out[k] = n.stringValue
            case let d as Double:
                out[k] = String(d)
            case let i as Int:
                out[k] = String(i)
            case let b as Bool:
                out[k] = b ? "true" : "false"
            case let date as Date:
                out[k] = ISO8601DateFormatter().string(from: date)
            case let url as URL:
                out[k] = url.absoluteString
            default:
                out[k] = String(describing: v)
            }
        }
        return out
    }

    /// Convert metadata back to flexible dictionary when needed at edges
    /// Use sparingly - prefer strict types internally
    public static func flexify(_ metadata: InsightMetadata) -> [String: Any] {
        var out: [String: Any] = [:]
        for (k, v) in metadata {
            // Try to parse back to original types
            if v == "true" {
                out[k] = true
            } else if v == "false" {
                out[k] = false
            } else if let intVal = Int(v) {
                out[k] = intVal
            } else if let doubleVal = Double(v) {
                out[k] = doubleVal
            } else {
                out[k] = v
            }
        }
        return out
    }
}

// MARK: - Legacy Namespace

/// Namespace for legacy KASPERMLX types to avoid naming conflicts
/// Gradually migrate these to canonical types
public enum LegacyKASPER {
    // Legacy types can be moved here as we identify conflicts
    // Example:
    // struct InsightContext { /* legacy shape */ }
    // struct PlanetarySnapshot { /* legacy shape */ }
}

// MARK: - Adapter Protocol

/// Protocol for adapting between legacy and canonical types
public protocol TypeAdapter {
    associatedtype LegacyType
    associatedtype CanonicalType

    static func toCanonical(_ legacy: LegacyType) -> CanonicalType
    static func toLegacy(_ canonical: CanonicalType) -> LegacyType
}

// MARK: - Common Conversions

extension InsightMetadata {
    /// Quick builder for common metadata patterns
    public static func build(
        backend: String? = nil,
        quality: Double? = nil,
        latency: TimeInterval? = nil,
        generationCount: Int? = nil,
        fallback: Bool? = nil
    ) -> InsightMetadata {
        var meta: InsightMetadata = [:]
        if let backend = backend { meta["backend"] = backend }
        if let quality = quality { meta["quality"] = String(quality) }
        if let latency = latency { meta["latency"] = String(latency) }
        if let count = generationCount { meta["generation_count"] = String(count) }
        if let fallback = fallback { meta["fallback"] = fallback ? "true" : "false" }
        return meta
    }
}
