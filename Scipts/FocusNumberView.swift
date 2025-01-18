//
//  FocusNumberView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/17/25.
//
import SwiftUI

struct FocusNumberView: View {
    
    @ObservedObject var manager = FocusNumberManager()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Focus Number")
                .font(.headline)
            
            Text("\(manager.currentFocusNumber)")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            // For testing: a button to manually restart the timer
            Button("Restart Timer") {
                manager.startUpdates()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
