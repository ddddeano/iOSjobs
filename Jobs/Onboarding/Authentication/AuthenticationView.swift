//
//  AuthenticationView.swift
//  Jobs
//
//  Created by Daniel Watson on 28.12.23.
//

import SwiftUI

import Foundation

class AuthenticationViewModel: ObservableObject {
    
    var authManager = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    func signIn(email: String, password: String) {
        isLoading = true
        // Implement sign-in logic here
        // On success:
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.isLoading = false
        }
        // On failure:
        DispatchQueue.main.async {
            self.errorMessage = "Failed to sign in."
            self.isLoading = false
        }
    }

    func signUp(email: String, password: String) {
        isLoading = true
        // Implement sign-up logic here
        // On success:
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.isLoading = false
        }
        // On failure:
        DispatchQueue.main.async {
            self.errorMessage = "Failed to sign up."
            self.isLoading = false
        }
    }

    func signOut() {
        // Implement sign-out logic here
        isAuthenticated = false
    }
    
    /*func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DataBaseUser(auth: authDataResult)
        try await UserManager.shared.craeteNewUser(user: user)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DataBaseUser(auth: authDataResult)
        try await UserManager.shared.craeteNewUser(user: user)
    }*/
    
    /*func signInAnon() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnon()
        let user = DataBaseUser(auth: authDataResult)
        try await UserManager.shared.craeteNewUser(user: user)
        
        //try await UserManager.shared.createNewUser(auth: authDataResult )
    }*/
}



struct AuthenticationView: View {
    @EnvironmentObject var user: MiseboxUserManager.MiseboxUser
    
    @State private var email: String = "test@test.com"
    @State private var password: String = "12345678"

    @StateObject private var vm = AuthenticationViewModel()
    @Binding var showSigninView: Bool
    
    var body: some View {
        VStack {
        
                SignInEmailView(vm: SignInEmailViewModel(authManager: vm.authManager), showSignInView: $showSigninView)
         
            
           /* SignInWithGoogleButtonView()
                .frame(height: 50)
                .onTapGesture {
                    Task {
                        do {
                            try await vm.signInGoogle()
                            showSigninView = false
                        } catch {
                            print(error)
                        }
                    }
                }*/

            /*SignInWithAppleButtonView(type: .default, style: .black)
                .frame(height: 50)
                .onTapGesture {
                    Task {
                        do {
                            try await vm.signInApple()
                            showSigninView = false
                        } catch {
                            print(error)
                        }
                    }
                }*/

            Spacer()
        }
        .padding()
        .navigationTitle("Sign in")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSigninView: .constant(false))
    }
}


   
    
  
    
    
    /*private func signUpForm() -> some View {
     Group {
     CustomTextField(placeholder: "Name", text: $user.name, style: .primary)
     CustomTextField(placeholder: "Email", text: $email, style: .primary)
     CustomSecureField(placeholder: "Password", text: $password, style: .primary)
     CustomButton(title: "Sign Up", action: {
     vm.authenticationManager.signUpWithEmailAndPassword(email: email, password: password)
     }, style: .primary)
     Spacer(minLength: 0) // Spacer to ensure consistent layout
     }
     }*/
    
    /*private func signInForm() -> some View {
     Group {
     Spacer(minLength: 0) // Spacer to match the layout of signUpForm
     CustomTextField(placeholder: "Email", text: $email, style: .primary)
     CustomSecureField(placeholder: "Password", text: $password, style: .primary)
     CustomButton(title: "Sign In", action: {
     vm.authenticationManager.signInWithEmailAndPassword(email: email, password: password)
     }, style: .secondary)
     }
     }
    
    private func logoView() -> some View {
        VStack(spacing: 0) {
            Image("LogoIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            Image("LogoType")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}*/
