//
//  AboutView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // App Description
                    GroupBox(
                        label: Label("About Vybe", systemImage: "info.circle")
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Vybe helps you align with your daily focus number through real-time calculations based on your location and time.")
                                .padding(.vertical, 5)
                            
                            Text("Your focus number is dynamically calculated using:")
                                .padding(.top, 5)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Current Location", systemImage: "location.circle")
                                Label("Time of Day", systemImage: "clock")
                                Label("Date", systemImage: "calendar")
                            }
                            .padding(.leading)
                        }
                    }
                    .padding(.horizontal)
                    
                    // How It Works
                    GroupBox(
                        label: Label("How It Works", systemImage: "gear")
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("1. Choose your focus number")
                            Text("2. Enable auto-updates")
                            Text("3. Get notified when your current focus number matches your chosen number")
                            Text("4. Track your matches in the log")
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                    
                    // Version Info
                    GroupBox(
                        label: Label("Version", systemImage: "doc.text")
                    ) {
                        Text("Vybe MVP 1.0")
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("About")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
