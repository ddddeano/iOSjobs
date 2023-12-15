//
//  ContentView.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import SwiftUI


class ContentViewModel: ObservableObject {

    // app notifications centre etc
    // user bits and bobs
    
}

struct ContentView: View {
    @StateObject var vm = ContentViewModel()

    var body: some View {
            TabView {
                ManageJobsDashboard()
                    .tabItem {
                        Label("Create Job", systemImage: "plus.circle.fill")
                    }
                ExploreJobsDashboard()
                    .tabItem {
                        Label("View Jobs", systemImage: "magnifyingglass.circle.fill")
                    }
            }
            .tabViewStyle(DefaultTabViewStyle())
            .padding(.top, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

