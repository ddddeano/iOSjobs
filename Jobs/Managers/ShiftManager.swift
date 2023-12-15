//
//  ShiftManager.swift
//  Jobs
//
//  Created by Daniel Watson on 13.12.23.
//

import Foundation
import Firebase

final class ShiftManager {

    private var firestoreManager = FirestoreManager()
    private var baseCollection = "jobs"

    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    func createShift(shift: Shift, completion: @escaping (Result<String, Error>) -> Void) {
        let shiftCollection = "\(baseCollection)/\(shift.jobId)/shifts"
         firestoreManager.createDoc(collection: shiftCollection, entity: shift) { result in
             switch result {
             case .success(let documentId):
                 print("Shift created successfully with ID: \(documentId)")
                 completion(.success(documentId))
             case .failure(let error):
                 print("Error creating shift: \(error)")
                 completion(.failure(error))
             }
         }
     }
    
    func fetchAllShifts(forJobId jobId: String, completion: @escaping ([Shift]) -> Void) {
        let shiftCollection = "\(baseCollection)/\(jobId)/shifts"
        listener = firestoreManager.fetchAllDocuments(collection: shiftCollection) { (result: Result<[Shift], FirestoreManager.FirestoreError>) in
            switch result {
            case .success(let shifts):
                completion(shifts)
            case .failure(let error):
                print("Error fetching shifts: \(error)")
                completion([])
            }
        }
    }
}
