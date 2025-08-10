//
//  FocusNumberView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/17/25.
//

import SwiftUI

struct FocusNumberView: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @Environment(\.dismiss) var dismiss
    @State private var showingPicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Selected Number Display
                VStack {
                    Text("Selected Focus Number")
                        .font(.headline)

                    Text("\(focusNumberManager.selectedFocusNumber)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 100)
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                        .shadow(radius: 5)
                }
                .padding()

                // Choose Number Button
                Button(action: {
                    showingPicker = true
                }) {
                    Label("Choose Number", systemImage: "number.circle")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingPicker) {
                    FocusNumberPicker()
                }

                Spacer()
            }
            .navigationTitle("Focus Number")
        }
    }
}

struct FocusNumberView_Previews: PreviewProvider {
    static var previews: some View {
        FocusNumberView()
            .environmentObject(FocusNumberManager.shared)
    }
}
