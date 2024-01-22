//
//  JobsApp.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import SwiftUI
import Firebase

@main
struct JobsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var miseboxUser = MiseboxUserManager.MiseboxUser()
    @StateObject var session = Session()
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: ContentViewModel(session: session, miseboxUser: miseboxUser))
                .environmentObject(session)
                .environmentObject(miseboxUser)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
enum MiseboxError: Error {
    case selfIsNil
    case documentDoesNotExist
}
