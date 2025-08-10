import Foundation

/// Input sanitization utilities for security hardening
enum Sanitizer {
    
    /// Trims whitespace and limits string length
    static func trimmed(_ s: String, max: Int = 2000) -> String {
        let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        return String(t.prefix(max))
    }
    
    /// Filters to printable ASCII characters only and limits length
    static func printableOnly(_ s: String, max: Int = 2000) -> String {
        let filtered = s.unicodeScalars.filter { scalar in
            scalar.isASCII && scalar.value >= 32 && scalar.value != 127
        }
        let clean = String(String.UnicodeScalarView(filtered))
        return String(clean.prefix(max))
    }
    
    /// Validates and returns safe URLs (http/https only)
    static func safeURL(from s: String) -> URL? {
        guard let components = URLComponents(string: s),
              let scheme = components.scheme,
              ["http", "https"].contains(scheme.lowercased()) else {
            return nil
        }
        return components.url
    }
    
    /// Sanitizes journal/user content for safe storage
    static func journalContent(_ s: String) -> String {
        // Allow unicode for international text, but limit length and trim
        let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove potentially dangerous control characters but keep newlines/tabs
        let filtered = trimmed.unicodeScalars.filter { scalar in
            // Allow printable characters (32-126), newlines (10), carriage returns (13), tabs (9)
            (scalar.value >= 32 && scalar.value <= 126) || 
            scalar.value == 10 || scalar.value == 13 || scalar.value == 9 ||
            (scalar.value >= 160) // Allow Unicode characters above ASCII range
        }
        
        let clean = String(String.UnicodeScalarView(filtered))
        return String(clean.prefix(5000)) // Generous limit for journal entries
    }
}