////
//  AuthenticationManager.swift
//  Jobs
//  Logging Format: "Authentication[functionName] statement content"
//  Created by Daniel Watson on 15.12.23.
//
import Foundation
import Firebase
import FirebaseAuth

class AuthenticationManager: ObservableObject {
    
    struct FirebaseUser {
        let uid: String
        let email: String?
        let photoUrl: String?
        let isAnon: Bool
        
        init(user: User) {
            self.uid = user.uid
            self.email = user.email
            self.photoUrl = user.photoURL?.absoluteString
            self.isAnon = user.isAnonymous
        }
    }

    enum AuthProviderOption: String {
        case email = "password"
        case google = "google.com"
        case apple = "apple.com"
    }
    
    enum AuthenticationError: Error {
        case userNotFound
        case badServerResponse
        case authenticationFailed(reason: String)

        var localizedDescription: String {
            switch self {
            case .userNotFound:
                return "Authentication: User not found."
            case .badServerResponse:
                return "Authentication: Bad server response."
            case .authenticationFailed(let reason):
                return "Authentication: Authentication failed - \(reason)"
            }
        }
    }
 

    @Published var authError: AuthenticationError?
    
    func authenticate() async throws -> FirebaseUser {
        if let currentUser = Auth.auth().currentUser {
            // User is already signed in
            print("Authentication[authenticate] User already signed in. UID: \(currentUser.uid)")
            return FirebaseUser(user: currentUser)
        } else {
            // No user is signed in, proceed with anonymous sign-in
            print("Authentication[authenticate] No user found. Proceeding with anonymous sign-in.")
            let user = try await signInAnon()
            print("Authentication[authenticate] Signed in anonymously. UID: \(user.uid)")
            return user
        }
    }


    func getAuthenticatedUser() throws -> FirebaseUser {
        // Not async because the SDK lets us check locally first.
        guard let user = Auth.auth().currentUser else {
            print("Authentication[getAuthenticatedUser] No authenticated user found locally.")
            throw AuthenticationError.userNotFound
        }
        return FirebaseUser(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            // AI errors
            throw URLError(.badServerResponse)
        }
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("provider option not found \(provider.providerID)")
            }
        }
        return providers
    }
    func signOut() throws {
        try Auth.auth().signOut()
    }
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
    }

    // MARK: Signin email functions
    @discardableResult
    func createUser(email: String, password: String) async throws -> FirebaseUser {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return FirebaseUser(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> FirebaseUser {
        let authResultData = try await Auth.auth().signIn(withEmail: email, password: password)
        return FirebaseUser(user: authResultData.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await  user.updatePassword(to: password)
    }
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await  user.updateEmail(to: email)
    }

    // MARK: Sign in SSO Functions
    func signInWith(credential: AuthCredential) async throws -> FirebaseUser {
        let authResultData =  try await Auth.auth().signIn(with: credential)
        return FirebaseUser(user: authResultData.user)
    }

    // MARK: Sign in Anonymous
    @discardableResult
    func signInAnon() async throws -> FirebaseUser {
        let authResultData =  try await Auth.auth().signInAnonymously()
        return FirebaseUser(user: authResultData.user)
    }
    
   
    @discardableResult
    func linkEmail(email: String, password: String) async throws -> FirebaseUser {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return try await linkCredential(credential: credential)
    }

    private func linkCredential(credential: AuthCredential) async throws -> FirebaseUser {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        let authDataResult = try await user.link(with: credential)
        return FirebaseUser(user: authDataResult.user)
    }
}
