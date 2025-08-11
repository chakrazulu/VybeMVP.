//
//  NumberRichContentView.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  SwiftUI view for displaying rich number content from RuntimeBundle
//  with smooth loading states, error handling, and graceful fallbacks.
//  Integrates with KASPERContentRouter for manifest-driven content.
//

import SwiftUI

struct NumberRichContentView: View {
    let number: Int
    @StateObject private var vm = NumberMeaningViewModel()

    // Sacred color system from CLAUDE.md
    private var sacredColor: Color {
        switch number {
        case 0: return .white
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        case 6: return .indigo
        case 7: return .purple
        case 8: return Color(red: 1.0, green: 0.84, blue: 0) // Gold
        case 9: return .white
        case 11, 22, 33, 44: return .purple // Master numbers
        default: return .purple
        }
    }

    var body: some View {
        ZStack {
            CosmicBackgroundView()
                .ignoresSafeArea()

            Group {
                switch vm.state {
                case .idle, .loading:
                    loadingView

                case .empty:
                    emptyView

                case .error(let msg):
                    errorView(msg)

                case .loaded(let content):
                    loadedView(content)
                }
            }
        }
        .task {
            vm.load(number: number)
        }
        .navigationTitle("Number \(number)")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Loading State

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(sacredColor)

            Text("Summoning rich content...")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))

            Text("Number \(number)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Empty State

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(sacredColor.opacity(0.6))

            Text("No rich content available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("Number \(number)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            Text("Showing live insight templates instead")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Error State

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Trouble loading Number \(number)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(message)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                vm.load(number: number)
            }) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(sacredColor.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(sacredColor, lineWidth: 1)
                    )
            }
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Loaded Content

    private func loadedView(_ content: NumberRichContent) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with meta info
                headerView(content)

                // Overview section
                if let overview = content.overview {
                    sectionView(overview)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }

                // Symbolism section
                if let symbolism = content.symbolism {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Symbolism")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(sacredColor)

                        sectionView(symbolism)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                    )
                }

                // Correspondences
                if let correspondences = content.correspondences {
                    correspondencesView(correspondences)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }

                // Practices
                if let practices = content.practices {
                    practicesView(practices)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sacredColor.opacity(0.5), lineWidth: 1)
                        )
                }
            }
            .padding()
        }
    }

    // MARK: - Content Components

    @ViewBuilder
    private func headerView(_ content: NumberRichContent) -> some View {
        VStack(alignment: .center, spacing: 16) {
            // Large number display
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [sacredColor.opacity(0.3), sacredColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)

                Circle()
                    .stroke(sacredColor, lineWidth: 2)
                    .frame(width: 120, height: 120)

                Text("\(number)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(sacredColor)
            }

            // Meta information
            if let meta = content.meta {
                VStack(spacing: 8) {
                    if meta.type == "master" {
                        HStack(spacing: 12) {
                            Text("MASTER NUMBER")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(sacredColor.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(sacredColor, lineWidth: 1)
                                )

                            if let base = meta.base_number {
                                Text("Base: \(base)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }

    @ViewBuilder
    private func sectionView(_ section: NumberRichContent.Section) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = section.title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            if let body = section.body {
                Text(body)
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let bullets = section.bullets, !bullets.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 12) {
                            Text("•")
                                .foregroundColor(sacredColor)
                            Text(bullet)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func correspondencesView(_ correspondences: [String: String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Correspondences")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(correspondences.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text("\(key.capitalized):")
                            .fontWeight(.semibold)
                            .foregroundColor(sacredColor)

                        Text(value)
                            .foregroundColor(.white.opacity(0.9))

                        Spacer()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func practicesView(_ practices: [NumberRichContent.Section]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Practices")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(sacredColor)

            ForEach(Array(practices.enumerated()), id: \.offset) { _, practice in
                sectionView(practice)
                    .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    NavigationView {
        NumberRichContentView(number: 4)
    }
}
