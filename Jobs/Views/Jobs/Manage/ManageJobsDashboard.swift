//
//  ManageJobs.swift
//  Jobs
//
//  Created by Daniel Watson on 10.12.23.
//

import SwiftUI
import SwiftUI

struct ManageJobsDashboard: View {
    @StateObject var job = JobManager.Job()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                DashboardButton(title: "Create Job", iconName: "plus.circle.fill") {
                    navigationPath.append(StackItem.createJob)
                }
                DashboardButton(title: "My Jobs", iconName: "briefcase.fill") {
                    navigationPath.append(StackItem.myJobs)
                }
                DashboardButton(title: "My Applicants", iconName: "person.3.fill") {
                    
                }

                .navigationDestination(for: StackItem.self) { item in
                    switch item {
                    case .createJob:
                        CreateJobView(createJobVm: CreateJobViewModel(job: job), navigationPath: $navigationPath)
                            .environmentObject(job)
                    case .shiftManager:
                        ShiftManagerView(createJobVm: CreateJobViewModel(job: job), navigationPath: $navigationPath)
                            .environmentObject(job)
                    case .manageShifts:
                        ManageShiftsView(createJobVm: CreateJobViewModel(job: job), navigationPath: $navigationPath)
                            .environmentObject(job)
                    case .myJobs:
                        MyJobsView(navigationPath: $navigationPath)
                    case .myApplicants:
                        MyApplicantsView(navigationPath: $navigationPath)
                    }
                }
            }
            .navigationTitle("Jobs Dashboard")
        }
    }
}

// Update StackItem enum to include new cases
enum StackItem: Hashable {
    case createJob
    case shiftManager
    case manageShifts
    case myJobs
    case myApplicants
    // Add other cases as needed
}


struct MyJobsView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("My Jobs")
                .font(.largeTitle)
                .padding()
            
            Text("Here you can manage all your job postings.")
                .padding()
        }
        .navigationBarTitle("My Jobs", displayMode: .inline)
    }
}
struct MyApplicantsView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("My Applicants")
                .font(.largeTitle)
                .padding()
            
            Text("Here you can review all applicants for your job postings.")
                .padding()
        }
        .navigationBarTitle("My Applicants", displayMode: .inline)
    }
}

