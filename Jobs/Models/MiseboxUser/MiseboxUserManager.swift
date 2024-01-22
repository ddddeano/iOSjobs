//
//  MiseboxUserManager.swift
//  MiseboxUserManager Logging Format: "UserManager[functionName] statement content"
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import Firebase
import Combine

final class MiseboxUserManager {
    private var firestoreManager = FirestoreManager()
    private var rootCollection = "misebox-users"
    private var listener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    deinit {
        listener?.remove()
    }

    func checkMiseboxUserExists(id: String) async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: rootCollection, documentID: id)
    }
    
    func setMiseboxUser(user: MiseboxUser) async throws  {
        try await firestoreManager.setDoc(collection: rootCollection, entity: user)
    }
    
    func documentListener(miseboxUser: MiseboxUser) {
         self.listener = firestoreManager.addDocumentListener(for: miseboxUser) { result in
             switch result {
             case .success(_):
                 self.verify(id: miseboxUser.id)
             case .failure(let error):
                 print("Document listener failed with error: \(error.localizedDescription)")
             }
         }
     }

    func collectionListener(completion: @escaping (Result<[MiseboxUser], Error>) -> Void) {
        self.listener = firestoreManager.addCollectionListener(collection: rootCollection, completion: completion)
    }

    func update(id: String, data: [String: Any]) {
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    func verify(id: String) {
        let data = ["verified" : true]
        update(id: id, data: data)
    }
 
    struct Chef: Identifiable, Dependant, FirestoreEntity {
        var collectionName = "chefs"
        
        var id: String
        var name: String
        
        init(id: String = "", name: String = "", inMode: Bool = true) {
            self.id = id
            self.name = name
        }
        
        init?(fromDictionary fire: [String: Any]) {
            guard let id = fire["id"] as? String,
                  let name = fire["name"] as? String else { return nil }
            self.id = id
            self.name = name
        }
        
        init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.init(fromDictionary: data)
        }
        
        func toFirestore() -> [String: Any] {
            return ["id": id, "name": name]
        }

    }

    func addChefToUser(chef: Chef, miseboxUserId: String) {
        let updateData: [String: Any] = ["chef": chef.toFirestore()]
        firestoreManager.updateDocument(collection: rootCollection, documentID: miseboxUserId, updateData: updateData)
    }
    struct Kitchen: Identifiable, Dependant, FirestoreEntity {
        var collectionName = "kitchens"
        
        var id: String
        var name: String
        
        init(id: String = "", name: String = "") {
            self.id = id
            self.name = name
        }
        init(from kitchen: KitchenManager.Kitchen) {
            self.id = kitchen.id
            self.name = kitchen.name
        }
        init?(fromDictionary fire: [String: Any]) {
            guard let id = fire["id"] as? String,
                  let name = fire["name"] as? String else { return nil }
            self.id = id
            self.name = name
        }
        
        init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.init(fromDictionary: data)
        }
        
        func toFirestore() -> [String: Any] {
            return ["id": id, "name": name]
        }
    }

    func setAsPrimaryKitchen(userId: String, kitchen: Kitchen) {
        let updateData: [String: Any] = ["primary_kitchen": kitchen.toFirestore()]
        self.update(id: userId, data: updateData)
    }
    func addKitchenToUser(kitchen: Kitchen, miseboxUserId: String) {
        firestoreManager.addDependantToEntity(collection: rootCollection, documentID: miseboxUserId, field: "kitchens", item: kitchen)
    }
}
