//
//  ExploreJobsDashboard.swift
//  Jobs
//
//  Created by Daniel Watson on 12.12.23.
//

import SwiftUI

class ExploreJobsViewModel: ObservableObject {
    private var jobManager = JobManager()
    @Published var allJobs: [JobManager.Job] = []
    
    init() {
        fetchAllJobs()
    }
    
    func fetchAllJobs() {
        /*jobManager.fetchAllJobs { jobs in
         DispatchQueue.main.async {
         self.allJobs = jobs
         print("Fetched jobs: \(jobs)")
         }
         }
         }*/
    }} 


struct ExploreJobsDashboard: View {
    @StateObject var vm = ExploreJobsViewModel()

    var body: some View {
        Text("Hello")
        /* NavigationStack {
         VStack {
         ForEach(vm.allJobs, id: \.id) { job in
         NavigationLink(destination: JobDetailView(job: job)) {
         JobCard(job: job)
         }
         }
         .padding(.bottom, 10)
         }
         .navigationTitle("Explore Jobs")
         }
         }*/
    }
}

struct JobCard: View {
    let job: JobManager.Job

    var body: some View {
        VStack(alignment: .leading) {
            Text(job.role)
                .font(.headline)
                .foregroundColor(.blue)
            Text("Pay: \(job.pay)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            // Add more details as needed
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct JobDetailView: View {
    let job: JobManager.Job

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(job.role)
                    .font(.largeTitle)
                
                Text("Posted by: \(job.createdBy)")
                    .font(.title2)
                
                Divider()
                
                Text("Pay: \(job.pay)")
                    .font(.title3)
                
                Text("Short Bio")
                    .font(.title3)
                Text(job.shortBio)

                // Add more detailed information for longBio, dressCode, location, etc.
            }
            .padding()
        }
        .navigationBarTitle("Job Details", displayMode: .inline)
    }
}


#Preview {
    ExploreJobsDashboard()
}
