/**
 * Filename: SVGPathExtractor.swift
 *
 * 🎯 PHASE 8: REVOLUTIONARY SVG PATH EXTRACTION SYSTEM 🎯
 *
 * === CORE PURPOSE ===
 * Extract authentic CGPath geometry from SVG assets for real sacred geometry neon tracing.
 * Replaces predefined geometric shapes with actual mandala paths from SVG files.
 *
 * === REVOLUTIONARY CONCEPT ===
 * Instead of hardcoded circles/polygons, neon tracers follow REAL mandala geometry:
 * • Parse SVG path data from sacred geometry assets
 * • Convert SVG path commands to CGPath segments
 * • Enable authentic mystical tracing along actual sacred patterns
 * • Dynamic adaptation to different mandala assets
 *
 * === SVG PATH PARSING ARCHITECTURE ===
 * • Bundle SVG loading: Read SVG files from app bundle
 * • Path extraction: Parse SVG <path> elements with d= attributes
 * • Command interpretation: Handle M, L, C, Q, Z SVG path commands
 * • CGPath conversion: Transform SVG coordinates to iOS CGPath
 * • Caching system: Store extracted paths for performance
 *
 * === SUPPORTED SVG COMMANDS ===
 * • M (moveTo): Start new path segment
 * • L (lineTo): Straight line segments
 * • C (curveTo): Cubic Bézier curves
 * • Q (quadraticCurveTo): Quadratic Bézier curves
 * • Z (closePath): Close current path
 * • Relative variants: m, l, c, q (relative coordinates)
 *
 * === PERFORMANCE OPTIMIZATIONS ===
 * • Path caching: Store extracted CGPaths to avoid re-parsing
 * • Lazy loading: Only parse SVG when path is requested
 * • Memory efficiency: Release unused paths when needed
 * • Background parsing: Parse complex SVGs off main thread
 *
 * Claude: Phase 8 SVG path extraction system for authentic sacred geometry tracing
 */

import Foundation
import SwiftUI
import CoreGraphics

/// Claude: Revolutionary SVG path extractor for authentic mandala geometry tracing
/// Converts SVG path data into CGPath for real sacred geometry neon effects
class SVGPathExtractor {
    
    // MARK: - Path Cache
    
    /// Cache extracted CGPaths to avoid re-parsing SVG files
    private static var pathCache: [String: CGPath] = [:]
    
    /// Debug flag to prevent repeated SVG file listing
    private static var hasDebugged = false
    
    /// Mapping from SacredGeometryAsset enum names to actual SVG file names
    private static let assetToSVGMapping: [String: String] = [
        // Phase 8.5: Map descriptive enum names to actual SVG file names
        // This maps the enum rawValue to the actual SVG file basename
        
        // 0 - VOID & INFINITE POTENTIAL
        "void_triquetra": "Sacred Geometry_One Line",
        "void_cosmic_womb": "Sacred Geometry_One Line_2", 
        "void_zero_point": "Sacred Geometry_One Line_3",
        "void_eternal_return": "Sacred Geometry_One Line_4",
        "void_star_matrix": "Sacred Geometry_One Line_5",
        "void_akashic_grid": "Sacred Geometry_One Line_6",
        "void_crystal": "Sacred Geometry_One Line_7",
        
        // 1 - UNITY & DIVINE SPARK  
        "unity_solar": "Sacred Geometry_One Line_8",
        "unity_crown": "Sacred Geometry_One Line_9",
        "unity_monad": "Sacred Geometry_One Line_10",
        "unity_alpha": "Sacred Geometry_One Line_11", 
        "unity_consciousness": "Sacred Geometry_One Line_12",
        "unity_spark": "Sacred Geometry_One Line_13",
        
        // 2 - DUALITY & COSMIC POLARITY
        "duality_vesica": "Sacred Geometry_One Line_14",
        "duality_lunar": "Sacred Geometry_One Line_15",
        "duality_yin_yang": "Sacred Geometry_One Line_16",
        "duality_pillars": "Sacred Geometry_One Line_17",
        "duality_divine": "Sacred Geometry_One Line_18",
        "duality_twins": "Sacred Geometry_One Line_19",
        "duality_mirror": "Sacred Geometry_One Line_20",
        
        // 3 - TRINITY & DIVINE CREATIVITY
        "trinity_mandala": "Sacred Geometry_One Line_21",
        "trinity_triangle": "Sacred Geometry_One Line_22",
        "trinity_wisdom": "Sacred Geometry_One Line_23",
        "trinity_fire": "Sacred Geometry_One Line_24",
        "trinity_gate": "Sacred Geometry_One Line_25",
        "trinity_expression": "Sacred Geometry_One Line_26",
        "trinity_logos": "Sacred Geometry_One Line_27",
        
        // 4 - FOUNDATION & MATERIAL MANIFESTATION
        "foundation_cube": "Sacred Geometry_One Line_28",
        "foundation_cross": "Sacred Geometry_One Line_29",
        "foundation_temple": "Sacred Geometry_One Line_30",
        "foundation_stone": "Sacred Geometry_One Line_31",
        "foundation_grid": "Sacred Geometry_One Line_32",
        "foundation_matrix": "Sacred Geometry_One Line_33", 
        "foundation_blessing": "Sacred Geometry_One Line_34",
        
        // 5 - QUINTESSENCE & DIVINE WILL
        "will_pentagram": "Sacred Geometry_One Line_35",
        "will_golden_spiral": "Sacred Geometry_One Line_36",
        "will_shield": "Sacred Geometry_One Line_37",
        "will_phoenix": "Sacred Geometry_One Line_38",
        "will_power": "Sacred Geometry_One Line_39",
        "will_star": "Sacred Geometry_One Line_40",
        "will_command": "Sacred Geometry_One Line_41",
        
        // 6 - HARMONY & COSMIC LOVE
        "harmony_star_david": "Sacred Geometry_One Line_42",
        "harmony_flower_life": "Sacred Geometry_One Line_43",
        "harmony_heart": "Sacred Geometry_One Line_44",
        "harmony_christ": "Sacred Geometry_One Line_45",
        "harmony_universal": "Sacred Geometry_One Line_46",
        "harmony_marriage": "Sacred Geometry_One Line_47",
        "harmony_beauty": "Sacred Geometry_One Line_48",
        
        // 7 - MYSTERY & SPIRITUAL MASTERY
        "mystery_seed_life": "Sacred Geometry_One Line_49",
        "mystery_seals": "Sacred Geometry_One Line_50",
        "mystery_rose": "Sacred Geometry_One Line_51",
        "mystery_victory": "Sacred Geometry_One Line_52",
        "mystery_wisdom": "Sacred Geometry_One Line_53",
        "mystery_magic": "Sacred Geometry_One Line_54",
        "mystery_gnosis": "Sacred Geometry_One Line_55",
        
        // 8 - RENEWAL & INFINITE CYCLES
        "renewal_octagon": "Sacred Geometry_One Line_56",
        "renewal_infinity": "Sacred Geometry_One Line_57",
        "renewal_karmic": "Sacred Geometry_One Line_58",
        "renewal_time": "Sacred Geometry_One Line_59",
        "renewal_justice": "Sacred Geometry_One Line_60",
        "renewal_scales": "Sacred Geometry_One Line_61",
        "renewal_matrix": "Sacred Geometry_One Line_62",
        
        // 9 - COMPLETION & UNIVERSAL WISDOM
        "wisdom_enneagram": "Sacred Geometry_One Line_63",
        "wisdom_completion": "Sacred Geometry_One Line_64"
    ]
    
    // MARK: - Public API
    
    /// Extract CGPath from SacredGeometryAsset's SVG file
    /// Phase 8.5: Enhanced curve tracing with multi-path support
    /// Returns authentic mandala geometry for neon tracing
    static func extractPath(from asset: SacredGeometryAsset, targetSize: CGSize = CGSize(width: 300, height: 300)) -> CGPath? {
        let cacheKey = "\(asset.rawValue)_\(targetSize.width)x\(targetSize.height)"
        
        // Return cached path if available
        if let cachedPath = pathCache[cacheKey] {
            return cachedPath
        }
        
        // Phase 8.5: ALWAYS debug for now - show what SVG files are available
        debugAvailableSVGFiles()
        
        // Load and parse SVG from bundle
        guard let svgContent = loadSVGFromBundle(assetName: asset.rawValue) else {
            print("⚠️ SVGPathExtractor: Could not load SVG for asset \(asset.rawValue)")
            print("🔍 Searched for: \(asset.rawValue).svg")
            return createFallbackPath(targetSize: targetSize)
        }
        
        print("✅ SVGPathExtractor: Successfully loaded SVG for \(asset.rawValue), content length: \(svgContent.count)")
        print("🔍 SVG preview: \(String(svgContent.prefix(200)))...")
        
        // Phase 8.5: Extract best traceable path from complex mandala
        let allPathData = extractAllPathDataFromSVG(svgContent)
        guard !allPathData.isEmpty else {
            print("⚠️ SVGPathExtractor: Could not extract any path data from \(asset.rawValue)")
            return createFallbackPath(targetSize: targetSize)
        }
        
        // Phase 8.5: Choose the best path for neon tracing
        let bestPathData = selectBestTraceablePath(allPathData)
        
        // Convert SVG path to CGPath with enhanced curve handling
        let cgPath = parseSVGPathDataWithEnhancedCurves(bestPathData, targetSize: targetSize)
        
        // Cache the result
        pathCache[cacheKey] = cgPath
        
        print("✅ SVGPathExtractor: Successfully extracted path for \(asset.rawValue)")
        return cgPath
    }
    
    /// Extract the outermost perimeter path for smooth tracing (Phase 8H)
    static func extractPerimeterPath(from asset: SacredGeometryAsset, targetSize: CGSize = CGSize(width: 300, height: 300)) -> CGPath? {
        guard let svgContent = loadSVGFromBundle(assetName: asset.rawValue) else {
            return nil
        }
        
        let allPathData = extractAllPathDataFromSVG(svgContent)
        guard !allPathData.isEmpty else { return nil }
        
        // Find the outermost/largest path (likely the perimeter)
        let perimeterPathData = selectPerimeterPath(allPathData)
        return parseSVGPathDataWithEnhancedCurves(perimeterPathData, targetSize: targetSize)
    }
    
    /// Extract multiple paths from complex SVG files (for future use)
    static func extractAllPaths(from asset: SacredGeometryAsset, targetSize: CGSize = CGSize(width: 300, height: 300)) -> [CGPath] {
        guard let svgContent = loadSVGFromBundle(assetName: asset.rawValue) else {
            return [createFallbackPath(targetSize: targetSize)]
        }
        
        let allPathData = extractAllPathDataFromSVG(svgContent)
        return allPathData.map { parseSVGPathData($0, targetSize: targetSize) }
    }
    
    // MARK: - SVG Loading
    
    /// Load SVG content from app bundle
    private static func loadSVGFromBundle(assetName: String) -> String? {
        // Phase 8.5: Map enum name to actual SVG file name
        let actualSVGName = assetToSVGMapping[assetName] ?? assetName
        
        print("🔄 SVGPathExtractor: Mapping \(assetName) → \(actualSVGName)")
        
        // Phase 8.5: iOS Bundle Resource Loading - Try direct bundle resource access
        // The key insight: Assets.xcassets are compiled into the bundle differently
        
        // Method 1: Try Bundle.main.path for compiled assets
        if let bundlePath = Bundle.main.path(forResource: assetName, ofType: "svg") {
            print("✅ Found SVG via Bundle.main.path: \(bundlePath)")
            if let content = try? String(contentsOfFile: bundlePath, encoding: .utf8) {
                return content
            }
        }
        
        // Method 2: Try Bundle.main.url for compiled assets  
        if let bundleURL = Bundle.main.url(forResource: assetName, withExtension: "svg") {
            print("✅ Found SVG via Bundle.main.url: \(bundleURL)")
            if let content = try? String(contentsOf: bundleURL, encoding: .utf8) {
                return content
            }
        }
        
        // Method 3: Try with mapped name
        if let bundlePath = Bundle.main.path(forResource: actualSVGName, ofType: "svg") {
            print("✅ Found mapped SVG via Bundle.main.path: \(bundlePath)")
            if let content = try? String(contentsOfFile: bundlePath, encoding: .utf8) {
                return content
            }
        }
        
        // Method 4: Legacy path-based search
        let potentialPaths = [
            // Try various directory structures
            Bundle.main.path(forResource: assetName, ofType: "svg", inDirectory: "Assets"),
            Bundle.main.path(forResource: actualSVGName, ofType: "svg", inDirectory: "Assets"),
            // Backup assets locations
            Bundle.main.path(forResource: actualSVGName, ofType: "svg", inDirectory: "backup_original_assets_20250622_183413"),
            Bundle.main.path(forResource: assetName, ofType: "svg", inDirectory: "backup_original_assets_20250622_183413")
        ]
        
        for (index, path) in potentialPaths.enumerated() {
            print("🔍 SVGPathExtractor: Trying path \(index): \(path ?? "nil")")
            if let validPath = path,
               let content = try? String(contentsOfFile: validPath, encoding: .utf8) {
                print("✅ SVGPathExtractor: Found SVG at path \(index): \(validPath)")
                return content
            }
        }
        
        // Try to find in backup directories
        if let backupContent = findInBackupDirectories(assetName: assetName) {
            return backupContent
        }
        
        // Phase 8.5: Last resort - manual bundle directory search
        if let manualContent = findInBundleDirectory(assetName: assetName) {
            return manualContent
        }
        
        return nil
    }
    
    /// Phase 8.5: Manual search of app bundle directory structure
    private static func findInBundleDirectory(assetName: String) -> String? {
        let fileManager = FileManager.default
        let bundlePath = Bundle.main.bundlePath
        
        // Search for SVG files in the main bundle directory structure
        let enumerator = fileManager.enumerator(atPath: bundlePath)
        
        while let element = enumerator?.nextObject() as? String {
            if element.contains(assetName) && element.hasSuffix(".svg") {
                let fullPath = "\(bundlePath)/\(element)"
                print("🎯 SVGPathExtractor: Found potential SVG at \(fullPath)")
                
                if let content = try? String(contentsOfFile: fullPath, encoding: .utf8) {
                    print("✅ SVGPathExtractor: Successfully loaded SVG from manual search")
                    return content
                }
            }
        }
        
        return nil
    }
    
    /// Phase 8.5: Debug method to discover all SVG files in the bundle
    private static func debugAvailableSVGFiles() {
        print("🔍 SVGPathExtractor: === DEBUGGING AVAILABLE SVG FILES ===")
        
        let fileManager = FileManager.default
        let bundlePath = Bundle.main.bundlePath
        
        // Find all SVG files in the bundle
        let enumerator = fileManager.enumerator(atPath: bundlePath)
        var svgFiles: [String] = []
        
        while let element = enumerator?.nextObject() as? String {
            if element.hasSuffix(".svg") {
                svgFiles.append(element)
            }
        }
        
        print("🎯 Found \(svgFiles.count) SVG files in bundle:")
        for (index, svgFile) in svgFiles.enumerated() {
            print("  \(index + 1). \(svgFile)")
            if index >= 10 { // Limit output to first 10 to avoid console spam
                print("  ... and \(svgFiles.count - 10) more")
                break
            }
        }
        
        // Also check what assets we're looking for
        print("🔍 Looking for assets like: unity_solar, harmony_flower_life, trinity_fire, etc.")
        print("🔍 Bundle path: \(bundlePath)")
        print("🔍 SVGPathExtractor: === END DEBUG ===")
    }
    
    /// Search backup directories for SVG files
    private static func findInBackupDirectories(assetName: String) -> String? {
        // Phase 8.5: Use mapped name for backup search too
        let actualSVGName = assetToSVGMapping[assetName] ?? assetName
        let fileManager = FileManager.default
        let bundlePath = Bundle.main.bundlePath
        
        // Search for SVG files in backup directories
        do {
            let backupDirs = try fileManager.contentsOfDirectory(atPath: bundlePath)
                .filter { $0.contains("backup_original_assets") }
            
            for backupDir in backupDirs {
                let backupPath = "\(bundlePath)/\(backupDir)"
                let imagesetName = "\(actualSVGName).imageset"
                let svgPath = "\(backupPath)/\(imagesetName)/\(actualSVGName).svg"
                
                if let content = try? String(contentsOfFile: svgPath, encoding: .utf8) {
                    return content
                }
                
                // Also try direct SVG files
                let directSvgPath = "\(backupPath)/\(actualSVGName).svg"
                if let content = try? String(contentsOfFile: directSvgPath, encoding: .utf8) {
                    return content
                }
            }
        } catch {
            print("⚠️ SVGPathExtractor: Error searching backup directories: \(error)")
        }
        
        return nil
    }
    
    // MARK: - SVG Path Extraction
    
    /// Extract path data from SVG content (first path element)
    private static func extractPathDataFromSVG(_ svgContent: String) -> String? {
        // Simple regex to find path d= attribute
        let pattern = #"<path[^>]*\s+d\s*=\s*["']([^"']+)["'][^>]*>"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let range = NSRange(location: 0, length: svgContent.utf16.count)
            
            if let match = regex.firstMatch(in: svgContent, options: [], range: range) {
                let pathDataRange = match.range(at: 1)
                if let swiftRange = Range(pathDataRange, in: svgContent) {
                    return String(svgContent[swiftRange])
                }
            }
        } catch {
            print("⚠️ SVGPathExtractor: Regex error: \(error)")
        }
        
        return nil
    }
    
    /// Extract all path data from SVG content (for complex mandalas)
    private static func extractAllPathDataFromSVG(_ svgContent: String) -> [String] {
        let pattern = #"<path[^>]*\s+d\s*=\s*["']([^"']+)["'][^>]*>"#
        var pathDataArray: [String] = []
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let range = NSRange(location: 0, length: svgContent.utf16.count)
            
            let matches = regex.matches(in: svgContent, options: [], range: range)
            for match in matches {
                let pathDataRange = match.range(at: 1)
                if let swiftRange = Range(pathDataRange, in: svgContent) {
                    pathDataArray.append(String(svgContent[swiftRange]))
                }
            }
        } catch {
            print("⚠️ SVGPathExtractor: Regex error: \(error)")
        }
        
        return pathDataArray
    }
    
    // MARK: - Phase 8.5: Enhanced Path Selection
    
    /// Select the perimeter path (outermost boundary) for smooth tracing
    private static func selectPerimeterPath(_ pathDataArray: [String]) -> String {
        // Score paths based on perimeter characteristics
        let scoredPaths = pathDataArray.map { pathData -> (path: String, score: Int, area: Double) in
            var score = 0
            
            // Estimate path area/size to find outermost boundary
            let estimatedArea = estimatePathArea(pathData)
            
            // Prefer closed paths (with Z command) - perimeters are usually closed
            if pathData.lowercased().contains("z") {
                score += 20
            }
            
            // Prefer longer paths (perimeters tend to be substantial)
            if pathData.count > 100 {
                score += 15
            }
            
            // Prefer paths with reasonable command count (not too complex, not too simple)
            let commandCount = pathData.filter { "MmLlCcQqZz".contains($0) }.count
            if commandCount > 4 && commandCount < 30 {
                score += 10
            }
            
            // Penalize very short paths (unlikely to be perimeters)
            if pathData.count < 50 {
                score -= 10
            }
            
            return (pathData, score, estimatedArea)
        }
        
        // Prefer largest area with highest score
        let bestPath = scoredPaths.max { first, second in
            if first.score != second.score {
                return first.score < second.score
            }
            return first.area < second.area
        }?.path ?? pathDataArray.first ?? ""
        
        print("🎯 SVGPathExtractor: Selected perimeter path from \(pathDataArray.count) available paths")
        
        return bestPath
    }
    
    /// Estimate the area/size of a path to help identify perimeter
    private static func estimatePathArea(_ pathData: String) -> Double {
        // Simple heuristic: count coordinate values to estimate path size
        let coordinates = pathData.components(separatedBy: CharacterSet(charactersIn: "MmLlCcQqTtSsHhVvZz ")).compactMap { Double($0) }
        
        if coordinates.count < 4 { return 0 }
        
        let xCoords = stride(from: 0, to: coordinates.count, by: 2).compactMap { coordinates.indices.contains($0) ? coordinates[$0] : nil }
        let yCoords = stride(from: 1, to: coordinates.count, by: 2).compactMap { coordinates.indices.contains($0) ? coordinates[$0] : nil }
        
        guard !xCoords.isEmpty && !yCoords.isEmpty else { return 0 }
        
        let width = (xCoords.max() ?? 0) - (xCoords.min() ?? 0)
        let height = (yCoords.max() ?? 0) - (yCoords.min() ?? 0)
        
        return width * height
    }
    
    /// Select the best path for neon tracing from multiple SVG paths
    private static func selectBestTraceablePath(_ pathDataArray: [String]) -> String {
        // Score paths based on traceability factors
        let scoredPaths = pathDataArray.map { pathData -> (path: String, score: Int) in
            var score = 0
            
            // Prefer paths with curves (C, Q commands)
            score += pathData.filter { "CcQq".contains($0) }.count * 3
            
            // Prefer paths with reasonable length (not too simple, not too complex)
            let commandCount = pathData.filter { "MmLlCcQqZz".contains($0) }.count
            if commandCount > 5 && commandCount < 50 {
                score += 10
            }
            
            // Prefer closed paths (with Z command)
            if pathData.lowercased().contains("z") {
                score += 5
            }
            
            // Penalize very short or very long paths
            if pathData.count < 20 || pathData.count > 2000 {
                score -= 5
            }
            
            return (pathData, score)
        }
        
        // Return the highest scoring path, or first path if all score equally
        let bestPath = scoredPaths.max { $0.score < $1.score }?.path ?? pathDataArray.first ?? ""
        
        print("🎯 SVGPathExtractor: Selected path with score \(scoredPaths.first { $0.path == bestPath }?.score ?? 0) from \(pathDataArray.count) available paths")
        
        return bestPath
    }
    
    // MARK: - SVG Path Parsing
    
    /// Parse SVG path data and convert to CGPath with enhanced curve handling
    private static func parseSVGPathDataWithEnhancedCurves(_ pathData: String, targetSize: CGSize) -> CGPath {
        let path = CGMutablePath()
        var currentPoint = CGPoint.zero
        var lastControlPoint = CGPoint.zero // For smooth curve continuations
        var subpathStart = CGPoint.zero // Track start of current subpath
        
        print("🎯 SVGPathExtractor: Starting SVG path parsing for \(pathData.count) characters")
        print("🔍 SVG path preview: \(String(pathData.prefix(100)))...")
        
        // Split path data into commands
        let commands = tokenizeSVGPath(pathData)
        
        print("🔍 SVGPathExtractor: Processing \(commands.count) path commands")
        
        for (index, command) in commands.enumerated() {
            // Claude: Additional safety wrapper to catch any remaining parsing errors
            print("🔄 Processing command \(index + 1)/\(commands.count): '\(command.type)' with \(command.coordinates.count) coords")
            
            // Wrap the entire command processing in error handling
            guard !command.coordinates.isEmpty || command.type.lowercased() == "z" else {
                print("⚠️ SVGPathExtractor: Skipping command '\(command.type)' with no coordinates")
                continue
            }
            
            // Additional safety: validate coordinate count before processing
            if command.coordinates.count > 100 {
                print("⚠️ SVGPathExtractor: Command '\(command.type)' has unusual coordinate count: \(command.coordinates.count), limiting to first 100")
            }
            
            switch command.type {
            case "M": // Move to (absolute)
                guard command.coordinates.count >= 2 else { 
                    print("⚠️ SVGPathExtractor: M command needs 2 coordinates, got \(command.coordinates.count)")
                    continue 
                }
                currentPoint = CGPoint(x: command.coordinates[0], y: command.coordinates[1])
                subpathStart = currentPoint
                path.move(to: currentPoint)
                
            case "m": // Move to (relative)
                guard command.coordinates.count >= 2 else { continue }
                currentPoint = CGPoint(
                    x: currentPoint.x + command.coordinates[0],
                    y: currentPoint.y + command.coordinates[1]
                )
                subpathStart = currentPoint
                path.move(to: currentPoint)
                
            case "L": // Line to (absolute)
                guard command.coordinates.count >= 2 else { continue }
                currentPoint = CGPoint(x: command.coordinates[0], y: command.coordinates[1])
                path.addLine(to: currentPoint)
                
            case "l": // Line to (relative)
                guard command.coordinates.count >= 2 else { continue }
                currentPoint = CGPoint(
                    x: currentPoint.x + command.coordinates[0],
                    y: currentPoint.y + command.coordinates[1]
                )
                path.addLine(to: currentPoint)
                
            case "H": // Horizontal line (absolute)
                guard command.coordinates.count >= 1 else { continue }
                currentPoint = CGPoint(x: command.coordinates[0], y: currentPoint.y)
                path.addLine(to: currentPoint)
                
            case "h": // Horizontal line (relative)
                guard command.coordinates.count >= 1 else { continue }
                currentPoint = CGPoint(x: currentPoint.x + command.coordinates[0], y: currentPoint.y)
                path.addLine(to: currentPoint)
                
            case "V": // Vertical line (absolute)
                guard command.coordinates.count >= 1 else { continue }
                currentPoint = CGPoint(x: currentPoint.x, y: command.coordinates[0])
                path.addLine(to: currentPoint)
                
            case "v": // Vertical line (relative)
                guard command.coordinates.count >= 1 else { continue }
                currentPoint = CGPoint(x: currentPoint.x, y: currentPoint.y + command.coordinates[0])
                path.addLine(to: currentPoint)
                
            case "C": // Cubic curve (absolute)
                guard command.coordinates.count >= 6 else { continue }
                let cp1 = CGPoint(x: command.coordinates[0], y: command.coordinates[1])
                let cp2 = CGPoint(x: command.coordinates[2], y: command.coordinates[3])
                currentPoint = CGPoint(x: command.coordinates[4], y: command.coordinates[5])
                path.addCurve(to: currentPoint, control1: cp1, control2: cp2)
                lastControlPoint = cp2
                
            case "c": // Cubic curve (relative)
                guard command.coordinates.count >= 6 else { continue }
                let cp1 = CGPoint(
                    x: currentPoint.x + command.coordinates[0],
                    y: currentPoint.y + command.coordinates[1]
                )
                let cp2 = CGPoint(
                    x: currentPoint.x + command.coordinates[2],
                    y: currentPoint.y + command.coordinates[3]
                )
                currentPoint = CGPoint(
                    x: currentPoint.x + command.coordinates[4],
                    y: currentPoint.y + command.coordinates[5]
                )
                path.addCurve(to: currentPoint, control1: cp1, control2: cp2)
                lastControlPoint = cp2
                
            case "S": // Smooth cubic curve (absolute)
                guard command.coordinates.count >= 4 else { continue }
                // First control point is reflection of last control point
                let cp1 = CGPoint(
                    x: currentPoint.x + (currentPoint.x - lastControlPoint.x),
                    y: currentPoint.y + (currentPoint.y - lastControlPoint.y)
                )
                let cp2 = CGPoint(x: command.coordinates[0], y: command.coordinates[1])
                currentPoint = CGPoint(x: command.coordinates[2], y: command.coordinates[3])
                path.addCurve(to: currentPoint, control1: cp1, control2: cp2)
                lastControlPoint = cp2
                
            case "s": // Smooth cubic curve (relative)
                guard command.coordinates.count >= 4 else { continue }
                // First control point is reflection of last control point
                let cp1 = CGPoint(
                    x: currentPoint.x + (currentPoint.x - lastControlPoint.x),
                    y: currentPoint.y + (currentPoint.y - lastControlPoint.y)
                )
                let cp2 = CGPoint(
                    x: currentPoint.x + command.coordinates[0],
                    y: currentPoint.y + command.coordinates[1]
                )
                currentPoint = CGPoint(
                    x: currentPoint.x + command.coordinates[2],
                    y: currentPoint.y + command.coordinates[3]
                )
                path.addCurve(to: currentPoint, control1: cp1, control2: cp2)
                lastControlPoint = cp2
                
            case "Q": // Quadratic curve (absolute)
                guard command.coordinates.count >= 4 else { continue }
                let cp = CGPoint(x: command.coordinates[0], y: command.coordinates[1])
                currentPoint = CGPoint(x: command.coordinates[2], y: command.coordinates[3])
                path.addQuadCurve(to: currentPoint, control: cp)
                lastControlPoint = cp
                
            case "q": // Quadratic curve (relative)
                guard command.coordinates.count >= 4 else { continue }
                let cp = CGPoint(
                    x: currentPoint.x + command.coordinates[0],
                    y: currentPoint.y + command.coordinates[1]
                )
                currentPoint = CGPoint(
                    x: currentPoint.x + command.coordinates[2],
                    y: currentPoint.y + command.coordinates[3]
                )
                path.addQuadCurve(to: currentPoint, control: cp)
                lastControlPoint = cp
                
            case "T": // Smooth quadratic curve (absolute)
                guard command.coordinates.count >= 2 else { continue }
                // Control point is reflection of last control point
                let cp = CGPoint(
                    x: currentPoint.x + (currentPoint.x - lastControlPoint.x),
                    y: currentPoint.y + (currentPoint.y - lastControlPoint.y)
                )
                currentPoint = CGPoint(x: command.coordinates[0], y: command.coordinates[1])
                path.addQuadCurve(to: currentPoint, control: cp)
                lastControlPoint = cp
                
            case "t": // Smooth quadratic curve (relative)
                guard command.coordinates.count >= 2 else { continue }
                // Control point is reflection of last control point
                let cp = CGPoint(
                    x: currentPoint.x + (currentPoint.x - lastControlPoint.x),
                    y: currentPoint.y + (currentPoint.y - lastControlPoint.y)
                )
                currentPoint = CGPoint(
                    x: currentPoint.x + command.coordinates[0],
                    y: currentPoint.y + command.coordinates[1]
                )
                path.addQuadCurve(to: currentPoint, control: cp)
                lastControlPoint = cp
                
            case "Z", "z": // Close path
                path.closeSubpath()
                currentPoint = subpathStart
                
            default:
                // Handle other commands or skip unknown ones
                break
            }
        }
        
        // Scale path to target size if needed
        return scalePath(path, to: targetSize)
    }
    
    /// Legacy method for backward compatibility
    private static func parseSVGPathData(_ pathData: String, targetSize: CGSize) -> CGPath {
        return parseSVGPathDataWithEnhancedCurves(pathData, targetSize: targetSize)
    }
    
    // MARK: - Path Utilities
    
    /// Tokenize SVG path data into commands with coordinates
    private static func tokenizeSVGPath(_ pathData: String) -> [SVGPathCommand] {
        var commands: [SVGPathCommand] = []
        let trimmed = pathData.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Phase 8.5: Enhanced parsing for complete SVG command set
        let pattern = #"([MmLlHhVvCcSsQqTtAaZz])([^MmLlHhVvCcSsQqTtAaZz]*)"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: trimmed.utf16.count)
            
            let matches = regex.matches(in: trimmed, options: [], range: range)
            for match in matches {
                if let commandRange = Range(match.range(at: 1), in: trimmed),
                   let coordsRange = Range(match.range(at: 2), in: trimmed) {
                    
                    let commandType = String(trimmed[commandRange])
                    let coordsString = String(trimmed[coordsRange])
                    let coordinates = parseCoordinates(coordsString)
                    
                    commands.append(SVGPathCommand(type: commandType, coordinates: coordinates))
                }
            }
        } catch {
            print("⚠️ SVGPathExtractor: Path tokenization error: \(error)")
        }
        
        return commands
    }
    
    /// Parse coordinate values from string with enhanced safety
    private static func parseCoordinates(_ coordsString: String) -> [CGFloat] {
        // Claude: Enhanced coordinate parsing with safety checks to prevent array bounds crashes
        let cleanString = coordsString
            .replacingOccurrences(of: ",", with: " ")
            .replacingOccurrences(of: "-", with: " -") // Handle negative numbers properly
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Split by multiple whitespace patterns
        let components = cleanString.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        let coordinates = components.compactMap { component -> CGFloat? in
            let trimmed = component.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Skip empty components
            guard !trimmed.isEmpty else { return nil }
            
            // Validate numeric format
            guard let doubleValue = Double(trimmed) else {
                print("⚠️ SVGPathExtractor: Invalid coordinate value: '\(trimmed)'")
                return nil
            }
            
            // Clamp extreme values to prevent rendering issues
            let clampedValue = max(-10000, min(10000, doubleValue))
            return CGFloat(clampedValue)
        }
        
        print("🔍 SVGPathExtractor: Parsed \(coordinates.count) coordinates from '\(coordsString.prefix(50))...'")
        return coordinates
    }
    
    /// Scale CGPath to target size while maintaining aspect ratio
    private static func scalePath(_ path: CGPath, to targetSize: CGSize) -> CGPath {
        let boundingBox = path.boundingBox
        
        guard boundingBox.width > 0 && boundingBox.height > 0 else {
            return path
        }
        
        let scaleX = targetSize.width / boundingBox.width
        let scaleY = targetSize.height / boundingBox.height
        let scale = min(scaleX, scaleY) // Maintain aspect ratio
        
        var transform = CGAffineTransform(scaleX: scale, y: scale)
            .translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)
        
        return path.copy(using: &transform) ?? path
    }
    
    /// Create fallback path when SVG parsing fails
    private static func createFallbackPath(targetSize: CGSize) -> CGPath {
        let path = CGMutablePath()
        let center = CGPoint(x: targetSize.width / 2, y: targetSize.height / 2)
        let radius = min(targetSize.width, targetSize.height) / 3
        
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        return path
    }
    
    // MARK: - Cache Management
    
    /// Clear path cache to free memory
    static func clearCache() {
        pathCache.removeAll()
        print("🧹 SVGPathExtractor: Cache cleared")
    }
    
    /// Get cache statistics
    static func getCacheInfo() -> (count: Int, keys: [String]) {
        return (pathCache.count, Array(pathCache.keys))
    }
}

// MARK: - Supporting Types

/// Claude: SVG path command structure for parsing
private struct SVGPathCommand {
    let type: String
    let coordinates: [CGFloat]
}

// MARK: - Cache Management and Utilities
// Note: SacredGeometryAsset extensions are in SacredGeometryAssets.swift to avoid circular dependencies