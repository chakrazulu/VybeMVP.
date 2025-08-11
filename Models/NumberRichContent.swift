//
//  NumberRichContent.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Flexible, forward-compatible decoding model for rich number content
//  from the KASPERMLXRuntimeBundle. Tolerant of schema evolution.
//

import Foundation

struct NumberRichContent: Decodable, Equatable {
    struct Section: Decodable, Equatable {
        let title: String?
        let bullets: [String]?
        let body: String?
    }

    struct Meta: Decodable, Equatable {
        let number: String?
        let type: String?          // "master" or nil
        let base_number: String?   // e.g., "1" for 11
    }

    let meta: Meta?
    let overview: Section?
    let symbolism: Section?
    let correspondences: [String: String]?  // e.g., chakra, planet, color
    let practices: [Section]?               // rituals, micro-steps, etc.
}
