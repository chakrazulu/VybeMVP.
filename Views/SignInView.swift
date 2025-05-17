//
//  SignInView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @Binding var isSignedIn: Bool
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            SignInWithAppleButton(.signIn, onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                signInViewModel.handleSignIn(result: result)
            })
            .signInWithAppleButtonStyle(.black)
            .frame(maxWidth: 350)
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

