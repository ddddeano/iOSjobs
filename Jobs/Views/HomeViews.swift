//
//  Home.swift
//  Jobs
//
//  Created by Daniel Watson on 06.01.24.
//

import SwiftUI

struct Home: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        NavigationLink(destination: HomeChild(navigationPath: $navigationPath)) {
            Text("Go to Child")
        }
    }
}

struct HomeChild: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
       Text("Hello From Child")
           .navigationBarBackButtonHidden(false)
           .toolbar {
               bottomToolbar(navigationPath: $navigationPath)
           }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(navigationPath: .constant(NavigationPath()))
    }
}

