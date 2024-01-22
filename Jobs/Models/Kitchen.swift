//
//  Kitchen.swift
//  Jobs
//
//  Created by Daniel Watson on 17.12.23.
//

import Foundation
import Firebase

extension KitchenManager {
    final class Kitchen: ObservableObject, Identifiable, FirestoreEntity, Listenable {
        var collectionName = "kitchens"
        
        @Published var id: String = ""
        @Published var name: String = ""
        @Published var createdBy: String = ""
        @Published var team: [TeamMember] = []

        init() {}

        // init(fromDocumentSnapshot:)
        init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            self.update(with: data)
        }
        
        func update(with data: [String: Any]) {
            self.name = data["name"] as? String ?? self.name
            self.createdBy = data["createdBy"] as? String ?? self.createdBy

            self.team = fireArray(from: data["team"] as? [[String: Any]] ?? [], using: TeamMember.init(fromDictionary:))

        }

        func toFirestore() -> [String: Any] {
            var data = [String: Any]()
            data["id"] = id
            data["name"] = name
            data["createdBy"] = createdBy
            data["team"] = team.map { $0.toFirestore() }

            
            return data
        }
    }
}

