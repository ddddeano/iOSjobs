//
//  ContentView.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import SwiftUI

func topRightToolBar(navigationPath: Binding<NavigationPath>) -> some ToolbarContent {
    ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button(action: {
            navigationPath.wrappedValue = NavigationPath([MiseboxViews.notifs])
        }) {
            Image(systemName: MiseboxViews.notifs.rawValue)
        }
        Button(action: {
            navigationPath.wrappedValue = NavigationPath([MiseboxViews.chats])
        }) {
            Image(systemName: MiseboxViews.chats.rawValue)
        }
    }
}

func menuToolbar(navigationPath: Binding<NavigationPath>) -> some ToolbarContent {
    ToolbarItemGroup(placement: .navigationBarLeading) {
        Menu {
            Button("Option 1") {
                navigationPath.wrappedValue = NavigationPath([MiseboxViews.kitchens])
            }
            Button("Option 2") {
                navigationPath.wrappedValue = NavigationPath([MiseboxViews.option2])
            }
        } label: {
            Image("LogoType")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
        }
    }
}

func bottomToolbar(navigationPath: Binding<NavigationPath>) -> some ToolbarContent {
    ToolbarItemGroup(placement: .bottomBar) {
        HStack(spacing: 40) {  // Adjust spacing as needed
            Button(action: {
                navigationPath.wrappedValue = NavigationPath()
            }) {
                Image(systemName: "house")
            }
            Button(action: {
                navigationPath.wrappedValue = NavigationPath([MiseboxViews.search])
            }) {
                Image(systemName: MiseboxViews.create.rawValue)
            }
            Button(action: {
                navigationPath.wrappedValue = NavigationPath([MiseboxViews.profile])
            }) {
                Image(systemName: MiseboxViews.profile.rawValue)
            }
            Button(action: {
                navigationPath.wrappedValue = NavigationPath([MiseboxViews.lovelyView])
            }) {
                Image(systemName: MiseboxViews.lovelyView.rawValue)
            }
        }
        .padding()
    }
}


@ViewBuilder
func viewForItem(_ item: MiseboxViews, navigationPath: Binding<NavigationPath>, miseboxUser: MiseboxUserManager.MiseboxUser) -> some View {
    switch item {
        // bottom bar (4)
    case .search:
        SearchView()
    case .create:
        CreateView()
    case .profile:
        ProfileView()
        
        //top right bar (2)
    case .notifs:
        NotifsView()
    case .chats:
        ChatsView()
        //option views
    case .kitchens:
        KitchenDashboard(vm: KitchensViewModel(miseboxUser: miseboxUser), navigationPath: navigationPath)
        //place holders
    case .bellView:
        BellView()
    case .option2:
        Option2View()
    case .lovelyView:
        LovelyView()
    }
}

//case .createJob:
 //   CreateJobView(createJobVm: CreateJobViewModel(job: JobManager.Job()), navigationPath: navigationPath)


enum MiseboxViews: String, Hashable {
    // bottom bar (4)
    case search = "magnifyingglass"
    case create = "plus"
    case profile = "person.fill"
    
    //top right bar (2)
    case notifs = "bell.fill"
    case chats = "message.fill"
    
    //options (2)
    case kitchens
    
    // place holders (0) delete when we have finished
    case bellView = "bell"
    case option2 = "square.grid.2x2"
    case lovelyView = "heart.fill"
}


struct ContentView: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @StateObject var vm: ContentViewModel
    
    @State var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Home(navigationPath: $navigationPath)
                .applyCommonNavigationModifiers(navigationPath: $navigationPath)
                .navigationDestination(for: MiseboxViews.self) { item in
                    viewForItem(item, navigationPath: $navigationPath, miseboxUser: miseboxUser)
                        .applyCommonNavigationModifiers(navigationPath: $navigationPath)
                }
            .sheet(isPresented: $vm.showVerifyUserSheet) {
                VerifyUserView(vm: vm)
            }
        }
    }
}




struct AppHeaderView: View {
    @EnvironmentObject var user: MiseboxUserManager.MiseboxUser
    @ObservedObject var vm: ContentViewModel
    let headerStyle = StyleType.primary.style // Use the primary style

    var body: some View {
        NavigationLink(destination: AppSettingsView(vm: vm)) {
            ZStack {
                RoundedRectangle(cornerRadius: headerStyle.cornerRadius)
                    .foregroundColor(headerStyle.backgroundColor)
                    .shadow(radius: headerStyle.shadowRadius)
                    .frame(height: 60) // Adjusted for better appearance

                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35) // Adjusted size
                        .padding(.leading, 10)
                        .foregroundColor(headerStyle.foregroundColor)

                    VStack(alignment: .leading) {
                        Text(user.verified ? user.name : "Not Verified")
                            .font(.caption)
                            .foregroundColor(user.verified ? .green : .red)
                        Text(user.primaryKitchen != nil ? "Kitchen: \(user.primaryKitchen!.name)" : "No Kitchen Set")
                            .font(.caption)
                            .foregroundColor(headerStyle.foregroundColor)
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }
        }
        .foregroundColor(headerStyle.foregroundColor)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let miseboxUser = MiseboxUserManager.MiseboxUser()
        miseboxUser.id = "12345"
        miseboxUser.name = "Dave"
        miseboxUser.role = "Chef"
        miseboxUser.verified = true  // or false to test the unverified state

        let mockSession = Session()
        let mockContentViewModel = ContentViewModel(session: mockSession, miseboxUser: miseboxUser)

        // Conditionally show the verify user sheet based on the user's verification status
        mockContentViewModel.showVerifyUserSheet = false

        return ContentView(vm: mockContentViewModel)
            .environmentObject(miseboxUser)
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let miseboxUser = MiseboxUserManager.MiseboxUser()
        miseboxUser.id = "12345"
        miseboxUser.name = "Dave"
        miseboxUser.role = "Chef"
        miseboxUser.verified = true
        miseboxUser.primaryKitchen = MiseboxUserManager.Kitchen(id: "kitchen-1", name: "Gourmet Kitchen")
        // Set other necessary properties as needed

        let mockSession = Session()
        let mockContentViewModel = ContentViewModel(session: mockSession, miseboxUser: miseboxUser)

        return AppHeaderView(vm: mockContentViewModel)
            .environmentObject(miseboxUser)
    }
}



