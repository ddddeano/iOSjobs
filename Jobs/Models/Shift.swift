//
//  Shift.swift
//  Jobs
//
//  Created by Daniel Watson on 13.12.23.
//

import Foundation
import Firebase
extension ShiftManager {
    final class Shift: ObservableObject, Identifiable, FirestoreEntity {
        
        @Published var id = ""
        @Published var jobId = ""
        @Published var date: Date
        @Published var startTime: Date
        @Published var endTime: Date
        
        init(date: Date, jobId: String) {
            self.date = date
            self.jobId = jobId
            self.startTime = date
            self.endTime = Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? date
        }
        
        required init?(fromDocumentSnapshot documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            
            self.id = documentSnapshot.documentID
            self.jobId = data["jobId"] as? String ?? ""
            
            self.date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
            self.startTime = (data["startTime"] as? Timestamp)?.dateValue() ?? Date()
            self.endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
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
