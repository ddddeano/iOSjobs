//
//  Job.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import Firebase

extension JobManager {
    class Job: ObservableObject, Identifiable, FirestoreEntity {
        
        @Published var id = ""
        @Published var role = ""
        @Published var createdBy = ""
        @Published var shifts = [Shift]()
        @Published var pay = ""
        @Published var shortBio = ""
        @Published var longBio = ""
        @Published var dressCode = ""
        @Published var location = ""
        
        init() {}
        
        required init?(fromDocumentSnapshot documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            
            self.id = documentSnapshot.documentID
            self.role = data["role"] as? String ?? ""
            self.createdBy = data["createdBy"] as? String ?? ""
            self.shifts = (data["shifts"] as? [[String: Any]])?.compactMap { Shift(fromDictionary: $0) } ?? []

            self.pay = data["pay"] as? String ?? ""
            self.shortBio = data["shortBio"] as? String ?? ""
            self.longBio = data["longBio"] as? String ?? ""
            self.dressCode = data["dressCode"] as? String ?? ""
            self.location = data["location"] as? String ?? ""
            
        }
        
        func toFirestore() -> [String: Any] {
            return [
                "role": role,
                "createdBy": createdBy,
                "shifts": shifts.map { $0.toFirestore() },
                "pay": pay,
                "shortBio": shortBio,
                "longBio": longBio,
                "dressCode": dressCode,
                "location": location
            ]
        }
    }
}
