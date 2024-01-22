//
//  Session.swift
//  Jobs
//
//  Created by Daniel Watson on 04.01.24.
//

import Foundation

class Session: ObservableObject {
    @Published var miseboxUserId = ""
    func resetSession() {
        self.miseboxUserId = ""
    }
}
