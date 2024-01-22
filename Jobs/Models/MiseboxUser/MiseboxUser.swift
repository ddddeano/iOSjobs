//
//  MiseboxUser.swift
//  Jobs
//  Logging Format: "MiseboxUser[functionName] statement content"
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

extension MiseboxUserManager {
    final class MiseboxUser: ObservableObject, Identifiable, Listenable {
        var collectionName = "misebox-users"
        
        @Published var id: String = ""
        @Published var name: String = ""
        @Published var role: String = ""
        @Published var primaryKitchen: Kitchen? = nil
        @Published var kitchens: [Kitchen] = []
        @Published var verified: Bool = false
        @Published var accountProviders: [String] = []
        
        init() {}
        
        // Initializer from DocumentSnapshot
        init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        func update(with data: [String: Any]) {
            self.name = data["name"] as? String ?? self.name
            self.role = data["role"] as? String ?? self.role
            self.verified = data["verified"] as? Bool ?? self.verified
            
            self.primaryKitchen = fireObject(from: data["primary_kitchen"] as? [String: Any] ?? [:], using: Kitchen.init(fromDictionary:))
            self.kitchens = fireArray(from: data["kitchens"] as? [[String: Any]] ?? [], using: Kitchen.init(fromDictionary:))
            
            if let providers = data["account_providers"] as? [String] {
                self.accountProviders = providers
            }
        }
        
        func toFirestore() -> [String: Any] {
            var data = [String: Any]()
            data["id"] = id
            data["name"] = name
            data["role"] = role
            data["verified"] = verified
            data["kitchens"] = kitchens.map { $0.toFirestore() }
            data["primary_kitchen"] = primaryKitchen?.toFirestore()
            data["account_providers"] = accountProviders
            return data
        }
            func resetMiseboxUserData() {
                id = ""
                name = ""
                role = ""
                primaryKitchen = nil
                kitchens = []
                verified = false
                accountProviders = []
        }
    }
}
