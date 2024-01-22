//
//  FirestoreManager.swift
//  FirestoreManager Logging Format: "FirestoreManager[functionName] statement content"
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import Combine
import Firebase

class FirestoreManager {
    private let db = Firestore.firestore()

    // MARK: - Enums
    enum FirestoreError: Error {
        case unknown, invalidSnapshot, networkError, documentNotFound
    }

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Document Management

    func checkDocumentExists(collection: String, documentID: String) async throws -> Bool {
        print("FirestoreManager[checkDocumentExists] Checking if document exists in \(collection) with ID: \(documentID)")
        let docRef = db.collection(collection).document(documentID)
        let documentSnapshot = try await docRef.getDocument()
        return documentSnapshot.exists
    }
    
    // Add a new document to the specified collection
    func createDoc<T: FirestoreEntity>(collection: String, entity: T) async throws -> String {
        print("FirestoreManager[createDoc] Creating document in \(collection)")
        do {
            let document = try await db.collection(collection).addDocument(data: entity.toFirestore())
            return document.documentID
        } catch {
            throw error // Re-throw the error to be handled by the caller
        }
    }
    func setDoc<T: FirestoreEntity>(collection: String, entity: T) async throws {
        print("FirestoreManager[setDoc] Setting document in \(collection) with ID: \(entity.id)")
        let document = db.collection(collection).document(entity.id)
        try await document.setData(entity.toFirestore())
    }
    
    func addDocumentListener<T: Listenable>(for entity: T, completion: @escaping (Result<T, Error>) -> Void) -> ListenerRegistration {
        let docRef = db.collection(entity.collectionName).document(entity.id)
        return docRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = documentSnapshot, document.exists, let data = document.data() else {
                completion(.failure(NSError(domain: "FirestoreManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Document does not exist or no data found"])))
                return
            }
            var updatedEntity = entity
            updatedEntity.update(with: data)
            completion(.success(updatedEntity))
        }
    }

    func addCollectionListener<T: FirestoreEntity>(collection: String, completion: @escaping (Result<[T], Error>) -> Void) -> ListenerRegistration {
        let collectionRef = db.collection(collection)
        return collectionRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = querySnapshot else {
                completion(.failure(NSError(domain: "FirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                return
            }
            var entities = [T]()
            for document in snapshot.documents {
                if let entity = T(documentSnapshot: document) {
                    entities.append(entity)
                }
            }
            completion(.success(entities))
        }
    }
    enum FirestoreUpdateOperation {
        case set
        case arrayUnion
        case arrayRemove
    }

    func updateDocument(collection: String, documentID: String, updateData: [String: Any], operation: FirestoreUpdateOperation = .set) {
        print("FirestoreManager[updateDocument] Updating document in \(collection) with ID: \(documentID)")
        let docRef = db.collection(collection).document(documentID)

        var finalUpdateData = updateData

        switch operation {
        case .set:
            // Regular update
            break
        case .arrayUnion, .arrayRemove:
            // Convert updateData for arrayUnion or arrayRemove
            for (key, value) in updateData {
                if operation == .arrayUnion {
                    finalUpdateData[key] = FieldValue.arrayUnion([value])
                } else if operation == .arrayRemove {
                    finalUpdateData[key] = FieldValue.arrayRemove([value])
                }
            }
        }

        docRef.updateData(finalUpdateData) { error in
            if let error = error {
                print("FirestoreManager[updateDocument] Error updating document: \(error)")
            } else {
                print("FirestoreManager[updateDocument] Document successfully updated")
            }
        }
    }

    
    func addDependantToEntity<D: Dependant>(collection: String, documentID: String, field: String, item: D) {
        print("FirestoreManager[addDependantToEntity] Adding dependant to entity in \(collection) with ID: \(documentID)")
        let docRef = db.collection(collection).document(documentID)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("FirestoreManager[addDependantToEntity] Error retrieving document: \(error)")
                return
            }
            
            var fieldData: [[String: Any]] = []
            if let data = document?.data(), let existingData = data[field] as? [[String: Any]] {
                fieldData = existingData
            }
            
            fieldData.append(item.toFirestore())
            
            docRef.setData([field: fieldData], merge: true) { error in
                if let error = error {
                    print("FirestoreManager[addDependantToEntity] Error updating document: \(error)")
                } else {
                    print("FirestoreManager[addDependantToEntity] Successfully updated document.")
                }
            }
        }
    }
    func removeDependantFromEntity(collection: String, documentID: String, field: String, itemIdToRemove: String) {
        print("FirestoreManager[removeDependantFromEntity] Removing dependant from entity in \(collection) with ID: \(documentID)")
        let docRef = db.collection(collection).document(documentID)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("FirestoreManager[removeDependantFromEntity] Error retrieving document: \(error)")
                return
            }
            
            guard var fieldData = document?.data()?["\(field)"] as? [[String: Any]] else {
                print("FirestoreManager[removeDependantFromEntity] Field data not found in document.")
                return
            }
            
            // Remove the item with the specified itemIdToRemove
            fieldData.removeAll { $0["id"] as? String == itemIdToRemove }
            
            docRef.setData([field: fieldData], merge: true) { error in
                if let error = error {
                    print("FirestoreManager[removeDependantFromEntity] Error updating document: \(error)")
                } else {
                    print("FirestoreManager[removeDependantFromEntity] Successfully updated document.")
                }
            }
        }
    }
}

protocol FirestoreEntity {
    var id: String { get set }
    init?(documentSnapshot: DocumentSnapshot)
    func toFirestore() -> [String: Any]
    var collectionName: String { get } // Add this line
}

protocol Listenable: FirestoreEntity {
    func update(with data: [String: Any])
}

protocol Dependant: FirestoreEntity {
    init?(fromDictionary dictionary: [String: Any])
}
func fireObject<T>(from dictionaryData: [String: Any], using initializer: (Dictionary<String, Any>) -> T?) -> T? {
    return initializer(dictionaryData)
}
func fireArray<T>(from arrayData: [[String: Any]], using initializer: (Dictionary<String, Any>) -> T?) -> [T] {
    return arrayData.compactMap(initializer)
}

