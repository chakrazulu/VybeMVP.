//
//  SettingsView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("Testing")) {
                NavigationLink(destination: TestingView()) {
                    Label("Match Testing", systemImage: "checkmark.circle")
                }
            }
            
            Section(header: Text("App Info")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(FocusNumberManager.shared)
            .environmentObject(RealmNumberManager())
    }
}
