//
//  FocusNumberView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/17/25.
//
import SwiftUI

struct MainView: View {
    @StateObject private var focusManager = FocusNumberManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Focus Number")
                .font(.headline)
            
            Text("\(focusManager.currentFocusNumber)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.purple)
                .padding()
                .background(Circle().fill(Color.purple.opacity(0.2)))
                .shadow(radius: 10)

            HStack(spacing: 20) {
                Button(action: {
                    focusManager.enableAutoFocusNumber()
                }) {
                    Text("Enable Auto-Update")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    focusManager.userDidPickFocusNumber(Int.random(in: 0...9)) // Replace with UI picker later
                }) {
                    Text("Pick a Number")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .onAppear {
            focusManager.startUpdates()
        }
        .onDisappear {
            focusManager.timer?.invalidate()
        }
    }
}
