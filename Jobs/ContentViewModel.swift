//
//  OnboardingViewModel.swift
//  Jobs
//  Logging Format: "Onboarding[functionName] statement content"
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import Firebase
import FirebaseAuth

@MainActor
final class ContentViewModel: ObservableObject {
    
    var email = "fire118@fire.com"
    var password = "Hello1234"
    var miseboxUserManager = MiseboxUserManager()
    let authManager = AuthenticationManager()
    
    var jobsCount = 10 // Number of jobs
    var teamSize = 5   // Team size
    
    @Published var session: Session
    @Published var miseboxUser: MiseboxUserManager.MiseboxUser
        
    @Published var showVerifyUserSheet = false
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    var authUser: AuthenticationManager.FirebaseUser? = nil
    
    
    init(session: Session, miseboxUser: MiseboxUserManager.MiseboxUser)  {
        self.session = session
        self.miseboxUser = miseboxUser
        Task {
            await authenticate()
        }
    }
    
    func authenticate() async {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            Task {
                if let firebaseUser = user {
                    print("Firebase user is signed in with UID: \(firebaseUser.uid)")
                    self.miseboxUser.id = firebaseUser.uid
                    await self.proceedWithFirebaseUser()
                } else {
                    try await self.authManager.signInAnon()
                    print("anon sign in")
                }
            }
        }
    }
    private func proceedWithFirebaseUser() async {
        do {
            let exists = try await miseboxUserManager.checkMiseboxUserExists(id: self.miseboxUser.id)
            if exists {
                // User exists in Firestore, initialize Firestore listener
                miseboxUserManager.documentListener(miseboxUser: self.miseboxUser)
                self.session.miseboxUserId = self.miseboxUser.id
                self.showVerifyUserSheet = false
            } else {
                print("User not found in in misebox-users.")
                self.showVerifyUserSheet = true // updated the isline
            }
        } catch {
            // Handle any errors that occur during the Firestore check
            print("Error in proceeding with Firebase user: \(error.localizedDescription)")
        }
    }
    
    
    func setUserLinkingEmail() async throws {
        print("SandBoxViewModel[setUserLinkingEmail] Linking email and password to the current user")
        do {
            self.miseboxUser.accountProviders.append("email")
            try await authManager.linkEmail(email: email, password: password)
            try await miseboxUserManager.setMiseboxUser(user: self.miseboxUser)
            self.showVerifyUserSheet = false
            miseboxUserManager.documentListener(miseboxUser: self.miseboxUser)
        } catch {
            print("Error linking account: \(error.localizedDescription)")
            throw error
        }
    }
    func signOut() async throws {
        
        // reset Session
        // reset MisebixUser
        // reset Kitchen
        
        
        miseboxUser.resetMiseboxUserData() // Reset miseboxUser by replacing it with a new instance
        try authManager.signOut()
        print("User signed out successfully.")
        print("Current state of miseboxUser after sign out:")
        print("ID: \(miseboxUser.id)")
        print("Name: \(miseboxUser.name)")
        print("Role: \(miseboxUser.role)")
        print("Verified: \(miseboxUser.verified)")
        print("Account Providers: \(miseboxUser.accountProviders)")
    }
}
