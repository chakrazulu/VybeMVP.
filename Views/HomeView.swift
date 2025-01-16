//
//  HomeView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to Vybe!")
                .font(.title)
                .padding()

            Text("Your Focus Number will appear here.")
                .font(.body)
                .foregroundColor(.gray)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
