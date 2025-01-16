//
//  AboutView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About Vybe")
                .font(.title)
                .padding()

            Text("Vybe is designed to help you align with your daily focus number.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
