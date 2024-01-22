//
//  JobManager.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import Firebase

final class JobManager {
    
    private var firestoreManager = FirestoreManager()
    private var rootCollection = "jobs"
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
  
    struct Shift: Identifiable, FirestoreEntity {
        var collectionName = "shifts"
        
        var id = UUID().uuidString
        var date: Date
        var endTime: String
        var startTime: String
        
        init(date: Date, startTime: String = "", endTime: String = "") {
            self.date = date
            self.startTime = startTime
            self.endTime = endTime
        }
        
        init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data(),
                  let dateTimestamp = data["date"] as? Timestamp,
                  let startTime = data["startTime"] as? String,
                  let endTime = data["endTime"] as? String else {
                return nil
            }
            self.id = documentSnapshot.documentID
            self.date = dateTimestamp.dateValue()
            self.startTime = startTime
            self.endTime = endTime
        }
        
        init?(fromDictionary firestoreData: [String: Any]) {
            guard let dateTimestamp = firestoreData["date"] as? Timestamp,
                  let startTime = firestoreData["startTime"] as? String,
                  let endTime = firestoreData["endTime"] as? String,
                  let id = firestoreData["id"] as? String else {
                return nil
            }
            self.id = id
            self.date = dateTimestamp.dateValue()
            self.startTime = startTime
            self.endTime = endTime
        }
        
        func toFirestore() -> [String: Any] {
            return [
                "date": Timestamp(date: date),
                "startTime": startTime,
                "endTime": endTime
            ]
        }
    }
}
