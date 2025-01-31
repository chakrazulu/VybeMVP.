//
//  TestingView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/28/25.
//

import SwiftUI

struct TestingView: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @EnvironmentObject var realmNumberManager: RealmNumberManager
    
    var body: some View {
        List {
            Section(header: Text("Your Numbers")) {
                HStack {
                    Text("Focus Number:")
                    Spacer()
                    Text("\(focusNumberManager.selectedFocusNumber)")
                        .bold()
                }
                
                HStack {
                    Text("Realm Number:")
                    Spacer()
                    Text("\(realmNumberManager.currentRealmNumber)")
                        .bold()
                }
                
                Button("Change Focus Number") {
                    // Cycle through 1-9
                    let next = (focusNumberManager.selectedFocusNumber % 9) + 1
                    focusNumberManager.userDidPickFocusNumber(next)
                }
            }
            
            Section(header: Text("Testing Controls")) {
                Button("Force Realm Number Match") {
                    // Set realm number to match focus number
                    focusNumberManager.updateRealmNumber(focusNumberManager.selectedFocusNumber)
                }
                
                Button("Set Random Realm Number") {
                    // Set to a random number 1-9
                    let random = Int.random(in: 1...9)
                    focusNumberManager.updateRealmNumber(random)
                }
            }
            
            Section(header: Text("Match History")) {
                if focusNumberManager.matchLogs.isEmpty {
                    Text("No matches yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(focusNumberManager.matchLogs, id: \.timestamp) { match in
                        VStack(alignment: .leading) {
                            Text("Match at \(match.timestamp, formatter: itemFormatter)")
                            Text("Focus: \(match.chosenNumber) = Realm: \(match.matchedNumber)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Match Testing")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    TestingView()
        .environmentObject(FocusNumberManager.shared)
        .environmentObject(RealmNumberManager())
}
