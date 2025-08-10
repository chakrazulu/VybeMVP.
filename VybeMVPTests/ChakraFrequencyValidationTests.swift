//
//  ChakraFrequencyValidationTests.swift
//  VybeMVPTests
//
//  Created by Claude on 8/7/25.
//  Sacred frequency validation to ensure spiritual authenticity
//

import XCTest
@testable import VybeMVP

/// Claude: Critical tests to ensure chakra frequencies remain spiritually authentic
/// These tests validate the sacred Solfeggio scale frequencies for each chakra
/// Never allow these to regress to 440Hz standard tuning
final class ChakraFrequencyValidationTests: XCTestCase {

    // MARK: - Sacred Solfeggio Frequencies Reference

    /// The authentic Solfeggio scale frequencies for spiritual healing
    /// These frequencies have been used for centuries in sacred music and healing
    private let sacredSolfeggioFrequencies: [ChakraType: Double] = [
        .root:       396.0,  // UT - Liberation from fear and guilt
        .sacral:     417.0,  // RE - Undoing situations and facilitating change
        .solarPlexus: 528.0,  // MI - Transformation and miracles (DNA repair)
        .heart:      639.0,  // FA - Connecting and relationships
        .throat:     741.0,  // SOL - Awakening intuition and expression
        .thirdEye:   852.0,  // LA - Returning to spiritual order
        .crown:      963.0   // SI - Divine consciousness and enlightenment
    ]

    // MARK: - Individual Chakra Frequency Tests

    func testRootChakraFrequency() {
        XCTAssertEqual(
            ChakraType.root.frequency,
            396.0,
            accuracy: 0.01,
            "Root chakra must use 396Hz Solfeggio frequency for grounding and liberation from fear"
        )
    }

    func testSacralChakraFrequency() {
        XCTAssertEqual(
            ChakraType.sacral.frequency,
            417.0,
            accuracy: 0.01,
            "Sacral chakra must use 417Hz Solfeggio frequency for facilitating change"
        )
    }

    func testSolarPlexusChakraFrequency() {
        XCTAssertEqual(
            ChakraType.solarPlexus.frequency,
            528.0,
            accuracy: 0.01,
            "Solar Plexus chakra must use 528Hz Solfeggio frequency for transformation and miracles"
        )
    }

    func testHeartChakraFrequency() {
        XCTAssertEqual(
            ChakraType.heart.frequency,
            639.0,
            accuracy: 0.01,
            "Heart chakra must use 639Hz Solfeggio frequency for connection and relationships"
        )
    }

    func testThroatChakraFrequency() {
        XCTAssertEqual(
            ChakraType.throat.frequency,
            741.0,
            accuracy: 0.01,
            "Throat chakra must use 741Hz Solfeggio frequency for awakening intuition"
        )
    }

    func testThirdEyeChakraFrequency() {
        XCTAssertEqual(
            ChakraType.thirdEye.frequency,
            852.0,
            accuracy: 0.01,
            "Third Eye chakra must use 852Hz Solfeggio frequency for spiritual order"
        )
    }

    func testCrownChakraFrequency() {
        XCTAssertEqual(
            ChakraType.crown.frequency,
            963.0,
            accuracy: 0.01,
            "Crown chakra must use 963Hz Solfeggio frequency for divine consciousness"
        )
    }

    // MARK: - Comprehensive Validation Tests

    func testAllChakraFrequenciesUseSolfeggioScale() {
        for chakraType in ChakraType.allCases {
            let expectedFrequency = sacredSolfeggioFrequencies[chakraType]!
            XCTAssertEqual(
                chakraType.frequency,
                expectedFrequency,
                accuracy: 0.01,
                "\(chakraType.name) chakra frequency must match sacred Solfeggio scale"
            )
        }
    }

    func testNoChakraUsesStandardTuning() {
        // Claude: Ensure no chakra is using 440Hz standard tuning or its harmonics
        let standardTuningFrequencies = [
            261.63,  // C4 in 440Hz tuning
            293.66,  // D4 in 440Hz tuning
            329.63,  // E4 in 440Hz tuning
            392.00,  // G4 in 440Hz tuning
            440.00,  // A4 standard
            523.25,  // C5 in 440Hz tuning
            659.25   // E5 in 440Hz tuning
        ]

        for chakraType in ChakraType.allCases {
            for standardFreq in standardTuningFrequencies {
                XCTAssertNotEqual(
                    chakraType.frequency,
                    standardFreq,
                    accuracy: 0.01,
                    "\(chakraType.name) must NOT use 440Hz standard tuning frequencies"
                )
            }
        }
    }

    func testChakraFrequenciesAreInAscendingOrder() {
        // Claude: Verify chakras progress from lower to higher frequencies
        let frequencies = ChakraType.allCases.map { $0.frequency }
        for i in 0..<(frequencies.count - 1) {
            XCTAssertLessThan(
                frequencies[i],
                frequencies[i + 1],
                "Chakra frequencies must ascend from root to crown"
            )
        }
    }

    func testSacredFrequencyRelationships() {
        // Claude: Test known relationships in the Solfeggio scale

        // 528Hz (Solar Plexus) is known as the "miracle frequency"
        XCTAssertEqual(ChakraType.solarPlexus.frequency, 528.0, accuracy: 0.01)

        // The difference between adjacent frequencies follows sacred patterns
        let rootToSacral = ChakraType.sacral.frequency - ChakraType.root.frequency
        XCTAssertEqual(rootToSacral, 21.0, accuracy: 0.01, "Root to Sacral should be 21Hz apart")

        let sacralToSolar = ChakraType.solarPlexus.frequency - ChakraType.sacral.frequency
        XCTAssertEqual(sacralToSolar, 111.0, accuracy: 0.01, "Sacral to Solar Plexus should be 111Hz apart")
    }

    // MARK: - Spiritual Integrity Certification

    func testSpiritualCalibrationAuthenticated() {
        // Claude: This test passes when all chakra frequencies are spiritually authentic
        // Used for the "Spiritual Calibration: Authenticated" badge

        var allAuthentic = true
        var failureMessages: [String] = []

        for chakraType in ChakraType.allCases {
            let expectedFrequency = sacredSolfeggioFrequencies[chakraType]!
            if abs(chakraType.frequency - expectedFrequency) > 0.01 {
                allAuthentic = false
                failureMessages.append("\(chakraType.name): Expected \(expectedFrequency)Hz, got \(chakraType.frequency)Hz")
            }
        }

        XCTAssertTrue(
            allAuthentic,
            "✨ Spiritual Calibration FAILED. Frequencies not authentic:\n\(failureMessages.joined(separator: "\n"))"
        )

        if allAuthentic {
            print("✨ Spiritual Calibration: Authenticated - All chakras resonate at sacred Solfeggio frequencies")
        }
    }
}
