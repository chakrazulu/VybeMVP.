//
//  FocusNumberPicker.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/18/25.
//
import SwiftUI

struct FocusNumberPicker: View {
    @Binding var selectedFocusNumber: Int
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var focusManager = FocusNumberManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Focus Number", selection: $selectedFocusNumber) {
                    ForEach(0...9, id: \.self) { number in
                        Text("\(number)")
                            .tag(number)
                    }
                }
                .pickerStyle(.wheel)
                .padding()
                .onChange(of: selectedFocusNumber) { oldValue, newValue in
                    focusManager.userDidPickFocusNumber(newValue)
                }
            }
            .navigationTitle("Choose Focus Number")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FocusNumberPicker(selectedFocusNumber: .constant(1))
}
