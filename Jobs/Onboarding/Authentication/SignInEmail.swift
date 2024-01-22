//
//  SignInEmail.swift
//  Jobs
//
//  Created by Daniel Watson on 28.12.23.
//

import SwiftUI
import Foundation
import FirebaseAuth

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = "fire10@fire.com"
    @Published var password = "Hello1234"
    private var authManager: AuthenticationManager
    
    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }
    
    func signUp() async throws {
        print("pressed")
          try await authManager.createUser(email: email, password: password)
    }


    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("no email or password")
            return
        }
        
        try await authManager.signInUser(email: email, password: password)
    }
}



struct SignInEmailView: View {
    
    @StateObject var vm: SignInEmailViewModel
    @Binding var showSignInView: Bool
    @State private var isSignUp = true // State to toggle between sign up and sign in
    
    var body: some View {
        VStack {
            // Toggle between Sign Up and Sign In using custom buttons
            HStack {
                CustomButton(title: "Sign Up", action: {
                    isSignUp = true
                }, style: isSignUp ? .primary : .secondary)

                CustomButton(title: "Sign In", action: {
                    isSignUp = false
                }, style: !isSignUp ? .primary : .secondary)
            }

            TextField("Email...", text: $vm.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)

            SecureField("Password..", text: $vm.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)

            if isSignUp {
                CustomButton(title: "Sign Up", action: {
                    Task {
                        do {
                            try await vm.signUp()
                            //showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }, style: .primary)
            } else {
                CustomButton(title: "Sign In", action: {
                    Task {
                        do {
                            try await vm.signIn()
                           // showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }, style: .secondary)
            }
        }
    }
}


#Preview {
    SignInEmailView(vm: SignInEmailViewModel(authManager: AuthenticationManager()), showSignInView : .constant(false))
}
