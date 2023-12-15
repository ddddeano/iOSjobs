//
//  MiseboxUser.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import Combine
import Firebase

extension MiseboxUserManager {
    final class MiseboxUser: ObservableObject, Identifiable, FirestoreEntity {
        var manager = MiseboxUserManager()
        
        @Published var id = ""
        @Published var name = ""
        
        @Published var chef: Chef? = nil
        @Published var kitchen: Kitchen? = nil
        
        
        init() {}
        
        func update(with user: MiseboxUser) {
            DispatchQueue.main.async {
                self.id = user.id
                self.name = user.name
                self.chef = user.chef
                self.kitchen = user.kitchen
            }
        }
        
        init?(fromDocumentSnapshot: DocumentSnapshot) {
            guard let data = fromDocumentSnapshot.data() else { return nil }
            
            self.id = fromDocumentSnapshot.documentID
            
            self.name = data["name"] as? String ?? "nousename"
            
            self.chef = (data["chef"] as? [String: Any]).map { Chef(fromDictionary: $0) } ?? nil
            self.kitchen = (data["kitchen"] as? [String: Any]).map { Kitchen(fromDictionary: $0) } ?? nil


        }
        
        func toFirestore() -> [String: Any] {
            return [
                "id": id,
                "name": name,
                "chef": chef?.toFirestore() ?? [:],
                "kitchen": kitchen?.toFirestore() ?? [:],
            ]
        }
    }
}
