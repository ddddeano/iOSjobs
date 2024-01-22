//
//  KitchenManager.swift
//  KitchenManager Logging Format: "KitchenManager[functionName] statement content"
//  Jobs
//
//  Created by Daniel Watson on 17.12.23.
//

import Foundation
import Firebase
import Combine

final class KitchenManager {
    private var firestoreManager = FirestoreManager()
    private var rootCollection = "kitchens"
    private var listener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    deinit {
        listener?.remove()
    }
    
    func createKitchen(kitchen: Kitchen) async throws -> String {
         let documentId = try await firestoreManager.createDoc(collection: rootCollection, entity: kitchen)
         return documentId
     }
    
    func documentListener(kitchen: Kitchen) {
         self.listener = firestoreManager.addDocumentListener(for: kitchen) { result in
             switch result {
             case .success(_):
                 self.verify(id: kitchen.id)
             case .failure(let error):
                 print("Document listener failed with error: \(error.localizedDescription)")
             }
         }
     }

    func collectionListener(completion: @escaping (Result<[Kitchen], Error>) -> Void) {
        self.listener = firestoreManager.addCollectionListener(collection: rootCollection, completion: completion)
    }

    func update(id: String, data: [String: Any]) {
        print("KitchenManager[update] Updating kitchen with ID: \(id)")
        firestoreManager.updateDocument(collection: rootCollection, documentID: id, updateData: data)
    }
    func verify(id: String) {
        let data = ["verified" : true]
        update(id: id, data: data)
    }

    struct TeamMember: Identifiable, Dependant, FirestoreEntity {
        var collectionName = "team"
        
        var id: String
        var name: String
        var role: String

        init(id: String = "", name: String, role: String) {
            self.id = id
            self.name = name
            self.role = role
        }

        init?(fromDictionary fire: [String: Any]) {
            guard let id = fire["id"] as? String else { return nil }
            self.id = id
            self.name = fire["name"] as? String ?? ""
            self.role = fire["role"] as? String ?? ""
        }
        
        init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.init(fromDictionary: data)
        }
        
        func toFirestore() -> [String: Any] {
            return ["id": id, "name": name, "role": role]
        }
    }
    func addTeamMemberToKitchenTeam(teamMember: TeamMember, kitchenId: String ) {
        firestoreManager.addDependantToEntity(collection: rootCollection, documentID: kitchenId, field: "team", item: teamMember)
    }
}


