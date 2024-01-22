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
                ZStack {
                    Color("PrimaryColour")
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        CustomButton(title: "Create Job", action: {
                            navigationPath.append(StackItem.createJob)
                        }, style: .primary, iconName: "plus.circle.fill")
                        
                        CustomButton(title: "My Jobs", action: {
                            navigationPath.append(StackItem.myJobs)
                        }, style: .primary, iconName: "briefcase.fill")
                        
                        CustomButton(title: "My Applicants", action: {
                            // Define action for My Applicants
                        }, style: .primary, iconName: "person.3.fill")
                        
                        // Navigation destinations for each item
                        .navigationDestination(for: StackItem.self) { item in
                            switch item {
                            case .createJob:
                                CreateJobView(createJobVm: CreateJobViewModel(job: job), navigationPath: $navigationPath)
                                    .environmentObject(job)
                                    .background(Color("PrimaryColour")) // Set your desired background color
                                
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
                }
        }
        .background(Color("PrimaryColour")) // Set your desired background color
        .edgesIgnoringSafeArea(.all) // Extend the background color to the edges of the screen
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

