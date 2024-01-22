//  Sandbox.swift
//  Jobs
//
//  Created by Daniel Watson on 27.12.23.
import SwiftUI




struct HeartView: View {
    
    var body: some View {
        Text("Heart View Content")
    }
}

struct BellView: View {

    var body: some View {
        Text("Bell View Content")
    }
}

struct Option1View: View {

    var body: some View {
        Text("Option 1 View Content")
    }
}

struct Option2View: View {

    var body: some View {
        Text("Option 2 View Content")
    }
}


struct SearchView: View {

    var body: some View {
        Text("Search View Content")
    }
}

struct CreateView: View {

    var body: some View {
        Text("Create View Content")
    }
}

struct ReelsView: View {

    var body: some View {
        Text("Reels View Content")
    }
}

struct ProfileView: View {

    var body: some View {
        Text("Profile View Content")
    }
}

struct LovelyView: View {

    var body: some View {
        Text("LovellyView")
    }
}


// Plus any other views you may need...



/*
@MainActor
class SandBoxViewModel: ObservableObject {
    var email = "fire118@fire.com"
    var password = "Hello1234"
    var miseboxUserManager = MiseboxUserManager()
    let authManager = AuthenticationManager()
    var miseboxUser: MiseboxUserManager.MiseboxUser
    
    @Published var showSheet = false
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(miseboxUser: MiseboxUserManager.MiseboxUser) {
        self.miseboxUser = miseboxUser
        Task {
            await authenticate()
        }
    }
    
    func authenticate() async {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [unowned self] _, user in
            Task {
                if let firebaseUser = user {
                    print("Firebase user is signed in with UID: \(firebaseUser.uid)")
                    self.miseboxUser.id = firebaseUser.uid
                    await proceedWithFirebaseUser()
                } else {
                    try await authManager.signInAnon()
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
                self.showSheet = false
            } else {
                print("User not found in in misebox-users.")
                self.showSheet = true // updated the isline
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
            self.showSheet = false
            miseboxUserManager.documentListener(miseboxUser: self.miseboxUser)
        } catch {
            print("Error linking account: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func setUserLinkingGmail() async throws {
        print("SandBoxViewModel[setUserLinkingGmail] Linking Gmail to the current user")
        /*    do {
         self.miseboxUser.accountProviders.append("google")
         try await authManager.linkGoogle(email: email, password: password)
         try await miseboxUserManager.setMiseboxUser(user: self.miseboxUser)
         self.showSheet = false
         miseboxUserManager.initialiseMiseboxUser(user: self.miseboxUser)
         } catch {
         print("Error linking account: \(error.localizedDescription)")
         throw error
         }*/
    }
    
    func signOut() async throws {
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

struct Sandbox: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @StateObject var vm: SandBoxViewModel
    
    var body: some View {
        VStack {
            Text("Content")
            Text("User Role: \(miseboxUser.role)")
            // Display whether the user is verified
            if miseboxUser.verified {
                Text("Status: Verified")
                    .foregroundColor(.green)
            } else {
                Text("Status: Not Verified")
                    .foregroundColor(.red)
            }
            Text("Misebox user ID: \(miseboxUser.id)")
            
            Button("Sign Out") {
                Task {
                    try? await vm.signOut()
                }
            }
        }
        .sheet(isPresented: $vm.showSheet) {
            SignInSand(vm: vm)
        }
    }
}



struct SignInSand: View {
    @ObservedObject var vm: SandBoxViewModel
    
    var body: some View {
        VStack {
            Button("Sign In with Email") {
                Task {
                    try? await vm.setUserLinkingEmail()
                }
            }
            Button("Skip") {
                vm.showSheet = false
            }
        }
    }
}
*/
