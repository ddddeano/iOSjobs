//
//  ShiftDates.swift
//  Jobs
//
//  Created by Daniel Watson on 11.12.23.
//

import SwiftUI


struct ShiftManagerView: View {
    var createJobVm: CreateJobViewModel
    @EnvironmentObject var job: JobManager.Job
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            CreatedShiftsView(shifts: $job.shifts)
            ShiftCreationView(createJobVm: createJobVm)
            Button("Next: Manage Shifts") {
                print(navigationPath)
                navigationPath.append(StackItem.manageShifts)
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

struct CreatedShiftsView: View {
    @Binding var shifts: [JobManager.Shift]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 20) {
                ForEach(shifts) { shift in
                    ShiftCalendarCellView(shift: shift)
                        .padding(.horizontal, 5)
                }
            }
            .padding(.vertical)
        }
    }
}

struct ShiftCreationView: View {
    var createJobVm: CreateJobViewModel

    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            Button("Add Shift") {
                let newShift = JobManager.Shift(date: selectedDate)
                createJobVm.addShift(newShift: newShift)
            }
        }
    }
}


