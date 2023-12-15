//
//  CreateJob.swift
//  Jobs
//
//  Created by Daniel Watson on 14.12.23.
//

import SwiftUI

class CreateJobViewModel: ObservableObject {
    private var jobManager = JobManager()
    
    @Published var showJobReviewSheet = false
    @Published var showNavigationStack = true
    @Published var job: JobManager.Job
 
    init(job: JobManager.Job) {
        self.job = job
    }
    
    func submitJob() {
        createJob(job: job)
        self.job = JobManager.Job()
    }
    
    private func createJob(job: JobManager.Job) {
        self.showJobReviewSheet = false
        jobManager.createJob(job: job) { result in
            switch result {
            case .success(let documentId):
                print("Job created successfully with ID: \(documentId)")
            case .failure(let error):
                print("Error creating job: \(error.localizedDescription)")
            }
        }
    }
    
    func addShift(newShift: JobManager.Shift) {
        job.shifts.append(newShift)
    }
}

struct CreateJobView: View {
    @StateObject var createJobVm: CreateJobViewModel
    @EnvironmentObject var job: JobManager.Job
    @Binding var navigationPath: NavigationPath // Receiving this as a binding from the parent
    
    var body: some View {
        VStack {
            Text("Creating a job...")
                .font(.title)
                .padding()
            
            InputFieldsView()
            
            Button("Manage Shifts") {
                print(navigationPath)
                navigationPath.append(StackItem.shiftManager)
                print(navigationPath)
            }
            .font(.headline)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        
        }
    }
}


struct JobReviewSheet: View {
    @ObservedObject var vm: CreateJobViewModel
    var job: JobManager.Job

    var body: some View {
        VStack {
            Text("Review Job")
                .font(.title)
            

            Button("Submit Job") {
                vm.submitJob()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}


struct InputFieldsView: View {
    @EnvironmentObject var job: JobManager.Job

    var body: some View {
        Group {
            TextField("Job Role", text: $job.role)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Pay", text: $job.pay)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        
            TextField("Short Bio", text: $job.shortBio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Long Bio", text: $job.longBio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Dress Code", text: $job.dressCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Location", text: $job.location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

