//
//  OnboardingViews.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import SwiftUI

struct Onboarding: View {
    @StateObject var vm: OnboardingViewModel
    
    
    var body: some View {
        VStack {
            OnboardingStepsView(vm: vm)

        }
    }
}
struct OnboardingStepsView: View {
    @ObservedObject var vm: OnboardingViewModel

    var body: some View {
        switch vm.onboardingStep {
            case .appLoading_1:
                ProgressView("Loading")
            case .signup_2:
                AuthView(vm: vm)
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(5)
            case .contentView_4:
                ContentView()
        }
    }
}

struct AuthView: View {
    @ObservedObject var vm: OnboardingViewModel

    @State private var email: String = "test@test.com"
    @State private var password: String = "12345678"

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            VStack {
                Button("Sign Up") {
                    Task {
                        await vm.authenticationManager.signUpWithEmailAndPassword(email: email, password: password)
                    }
                }
                Button("Sign In") {
                    Task {
                        await vm.authenticationManager.signInWithEmailAndPassword(email: email, password: password)
                    }
                }
            }
        }
    }
}

struct SignOutView: View {
    var signOutAction: () -> Void
    
    var body: some View {
        Button("Sign Out", action: signOutAction)
            .padding()
            .background(Color.red.opacity(0.3))
            .cornerRadius(5)
    }
}
