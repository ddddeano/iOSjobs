//
//  UserProfile.swift
//  Jobs
//
//  Created by Daniel Watson on 04.01.24.
//

import SwiftUI

class UserProfileViewModel: ObservableObject {
    private var miseboxUserManager = MiseboxUserManager()
    @Published var miseboxUser: MiseboxUserManager.MiseboxUser

    init(miseboxUser: MiseboxUserManager.MiseboxUser) {
        self.miseboxUser = miseboxUser
    }

    func updateUserName() {
           let data = ["name": miseboxUser.name]
           miseboxUserManager.update(id: miseboxUser.id, data: data)
       }

       func updateUserRole() {
           let data = ["role": miseboxUser.role]
           miseboxUserManager.update(id: miseboxUser.id, data: data)
       }

       func updateUserVerified() {
           let data = ["verified": miseboxUser.verified]
           miseboxUserManager.update(id: miseboxUser.id, data: data)
       }
}
struct UserDashboard: View {
    @EnvironmentObject var user: MiseboxUserManager.MiseboxUser
    @StateObject var vm: UserProfileViewModel
    
    var body: some View {
        Form {
            UserInformation(vm: vm)
            VerificationInfo(vm: vm)
        }
        .navigationBarTitle("User Profile", displayMode: .inline)
    }
}

struct UserInformation: View {
    @EnvironmentObject var user: MiseboxUserManager.MiseboxUser
    @ObservedObject var vm: UserProfileViewModel

    var body: some View {
          Section(header: HStack {
              Text("User: \(user.id)")
              Spacer()
              Image(systemName: "doc.on.doc") // Replace with your preferred clipboard copy icon
                  .onTapGesture {
                      // Implement clipboard copying functionality here
                  }
          }) {
            HStack {
                Text("Role:")
                Spacer()
                TextField("Role", text: $user.role)
                    .multilineTextAlignment(.trailing)
                Button("Update") {
                    vm.updateUserRole()
                }
            }
              HStack {
                  Text("Name:")
                Spacer()
                TextField("Name", text: $user.name)
                    .multilineTextAlignment(.trailing)
                Button("Update") {
                    vm.updateUserName()
                }
            }
        }
    }
}


struct VerificationInfo: View {
    @EnvironmentObject var user: MiseboxUserManager.MiseboxUser
    @ObservedObject var vm: UserProfileViewModel
    
    var body: some View {
        Section(header: Text("Verification Info")) {
            HStack {
                Text("Verified:")
                Spacer()
                Text(user.verified ? "Yes" : "No")
                    .foregroundColor(user.verified ? .green : .red)
            }
            
            if user.verified {
                VStack(alignment: .leading) {
                    Text("Verified With:")
                    ForEach(user.accountProviders, id: \.self) { provider in
                        Text(provider)
                            .padding(.leading)
                    }
                }
            } else {
                Text("User is not verified")
                    .padding(.leading)
            }
        }
    }
}


struct VerifyUserView: View {
    @ObservedObject var vm: ContentViewModel
    @State private var isNameValid: Bool = false // State for tracking name validity

    var body: some View {
        VStack {
            TextField("Enter your name", text: $vm.miseboxUser.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: vm.miseboxUser.name) { newValue in
                    isNameValid = !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                .padding()
                .background(isNameValid ? Color.clear : Color.red.opacity(0.3))

            Button("Sign In with Email") {
                Task {
                    try? await vm.setUserLinkingEmail()
                }
            }
            .padding()
            .disabled(!isNameValid)

            Button("Skip") {
                vm.showVerifyUserSheet = false
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
            userProfilePreviewWithKitchen()
                .previewDisplayName("With Primary Kitchen")
        }
            NavigationStack {
                userProfilePreviewWithoutKitchen()
                    .previewDisplayName("Without Primary Kitchen")
            }
        }
    }

    static func userProfilePreviewWithKitchen() -> some View {
        let primaryKitchen = MiseboxUserManager.Kitchen(id: "kitchen-123", name: "Gourmet Haven")
        let kitchens = [
            primaryKitchen,
            MiseboxUserManager.Kitchen(id: "kitchen-456", name: "Culinary Corner"),
            MiseboxUserManager.Kitchen(id: "kitchen-789", name: "Chef's Delight")
        ]

        return setupUserProfileView(primaryKitchen: primaryKitchen, kitchens: kitchens)
    }

    static func userProfilePreviewWithoutKitchen() -> some View {
        return setupUserProfileView(primaryKitchen: nil, kitchens: [])
    }

    static func setupUserProfileView(primaryKitchen: MiseboxUserManager.Kitchen?, kitchens: [MiseboxUserManager.Kitchen]) -> some View {
        let miseboxUser = MiseboxUserManager.MiseboxUser()
        miseboxUser.id = "12345"
        miseboxUser.name = "Dave"
        miseboxUser.role = "Chef"
        miseboxUser.verified = true
        miseboxUser.primaryKitchen = primaryKitchen
        miseboxUser.kitchens = kitchens
        miseboxUser.accountProviders = ["Email", "Google"]

        let vm = UserProfileViewModel(miseboxUser: miseboxUser)
        return UserDashboard(vm: vm)
            .environmentObject(miseboxUser)
    }
}
