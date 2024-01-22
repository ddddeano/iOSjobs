//
//  AppViews.swift
//  Jobs
//
//  Created by Daniel Watson on 05.01.24.
//

import SwiftUI


struct AppSettingsView: View {
    @EnvironmentObject var user: MiseboxUserManager.MiseboxUser
    @ObservedObject var vm: ContentViewModel
      
    var body: some View {
        List {
            // Navigation link to the UserProfileView
            NavigationLink(destination: UserDashboard(vm: UserProfileViewModel(miseboxUser: user))) {
                UserProfileCell(user: user)
            }
            
            // Navigation link to the KitchenProfileView
            /*NavigationLink(destination: KitchenDashboard(vm: KitchensViewModel(miseboxUser: user))) {
                KitchenProfileCell()
            }*/

            // Navigation link to Jobs view (replace with actual destination)
            NavigationLink(destination: Text("Jobs Dashboard")) {
                JobsProfileCell(jobsCount: vm.jobsCount)
            }

            // Navigation link to Team view (replace with actual destination)
            NavigationLink(destination: Text("Team Dashboard")) {
                TeamProfileCell(teamSize: vm.teamSize)
            }

            // Sign Out button
            Button("Sign Out") {
                Task {
                    try? await vm.signOut()
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("App Settings", displayMode: .inline)
    }
}

struct ProfileCell: View {
    var iconName: String
    var iconColor: Color
    var title: String
    var subtitle: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(10)
                .background(Circle().fill(iconColor))
                .foregroundColor(.white)

            VStack(alignment: .leading) {
                Text(title).bold()
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(subtitle.hasPrefix("Please") ? .red : .primary)
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
}

struct UserProfileCell: View {
    var user: MiseboxUserManager.MiseboxUser

    var body: some View {
        ProfileCell(
            iconName: "person.crop.circle",
            iconColor: .green,
            title: user.name,
            subtitle: user.verified ? "Role: \(user.role)" : "Please verify."
        )
    }
}

struct KitchenProfileCell: View {
    @EnvironmentObject var user: MiseboxUserManager.MiseboxUser

    var body: some View {
        ProfileCell(
            iconName: "star.fill",
            iconColor: .yellow,
            title: user.primaryKitchen?.name ?? "No primary kitchen set",
            subtitle: user.primaryKitchen != nil ? "Primary Kitchen" : "Please assign a kitchen"
        )
    }
}

struct JobsProfileCell: View {
    var jobsCount: Int

    var body: some View {
        ProfileCell(
            iconName: "briefcase.fill",
            iconColor: .blue,
            title: "Jobs",
            subtitle: jobsCount > 0 ? "Total: \(jobsCount)" : "Please create a job."
        )
    }
}



struct TeamProfileCell: View {
    var teamSize: Int

    var body: some View {
        ProfileCell(
            iconName: "person.3.fill",
            iconColor: .orange,
            title: "Team",
            subtitle: teamSize > 0 ? "Members: \(teamSize)" : "Please add team members."
        )
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                appSettingsPreviewWithUser()
                    .previewDisplayName("With Positive")
            }
            NavigationStack {
                appSettingsPreviewWithoutUser()
                    .previewDisplayName("With Negative")
            }
        }
    }

    static func appSettingsPreviewWithUser() -> some View {
        // Mock user data with positive states
        let miseboxUser = MiseboxUserManager.MiseboxUser()
        miseboxUser.id = "12345"
        miseboxUser.name = "Dave"
        miseboxUser.role = "Chef"
        miseboxUser.verified = true
        miseboxUser.primaryKitchen = MiseboxUserManager.Kitchen(id: "kitchen-789", name: "Chef's Delight")
        
        let vm = ContentViewModel(session: Session(), miseboxUser: miseboxUser) // Using a mock Session
        
        return AppSettingsView(vm: vm)
            .environmentObject(miseboxUser)
    }

    static func appSettingsPreviewWithoutUser() -> some View {
        // Mock user data with negative states
        let miseboxUser = MiseboxUserManager.MiseboxUser()
        miseboxUser.id = "67890"
        miseboxUser.name = "Alex"
        miseboxUser.role = "Waiter"
        miseboxUser.verified = false
        miseboxUser.primaryKitchen = nil // No primary kitchen
        
        let vm = ContentViewModel(session: Session(), miseboxUser: miseboxUser)
        vm.jobsCount = 0
        vm.teamSize = 0
        
        return AppSettingsView(vm: vm)
            .environmentObject(miseboxUser)
    }
}
