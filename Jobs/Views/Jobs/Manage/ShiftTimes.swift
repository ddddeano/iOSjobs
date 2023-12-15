//
//  ShiftTimes.swift
//  Jobs
//
//  Created by Daniel Watson on 14.12.23.
//

import Foundation
import SwiftUI

struct ManageShiftsView: View {
    @EnvironmentObject var job: JobManager.Job
    @ObservedObject var createJobVm: CreateJobViewModel
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            List(job.shifts.indices, id: \.self) { index in
                ShiftRow(shift: $job.shifts[index])
            }

            Button("Submit") {
                createJobVm.showJobReviewSheet = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $createJobVm.showJobReviewSheet, onDismiss: dismiss) {
            JobReviewSheet(vm: createJobVm, job: job)
        }
        .navigationTitle("Manage Shifts")
    }

    private func dismiss() {
        navigationPath.removeLast(navigationPath.count)
    }
}



struct ShiftRow: View {
    @Binding var shift: JobManager.Shift

    @State private var selectedStartHour = 0
    @State private var selectedStartMinute = 0
    @State private var selectedEndHour = 0
    @State private var selectedEndMinute = 0

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: shift.date)
    }
    
    var dayNumber: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: shift.date)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .center, spacing: 2) {
                    Text(day)
                        .font(.subheadline)
                    Text(dayNumber)
                        .font(.headline)
                        .padding(.horizontal, 20)
                }
            .frame(minWidth: 60)
            HStack(spacing: 20) {
                TimePicker(selectedHour: $selectedStartHour, selectedMinute: $selectedStartMinute, startOrFinish: .start)
                Spacer()
                TimePicker(selectedHour: $selectedEndHour, selectedMinute: $selectedEndMinute, startOrFinish: .end)
            }
            .padding(.horizontal, 10) // Apply horizontal padding
        }
        .onChange(of: selectedStartHour) { _ in updateStartTime() }
        .onChange(of: selectedStartMinute) { _ in updateStartTime() }
        .onChange(of: selectedEndHour) { _ in updateEndTime() }
        .onChange(of: selectedEndMinute) { _ in updateEndTime() }
        .padding(.horizontal, 20)
    }

    private func updateStartTime() {
        shift.startTime = "\(selectedStartHour):\(selectedStartMinute * 15)"
    }

    private func updateEndTime() {
        shift.endTime = "\(selectedEndHour):\(selectedEndMinute * 15)"
    }
}

struct ShiftRow_Previews: PreviewProvider {
    static var previews: some View {
        ShiftRow(shift: .constant(JobManager.Shift(date: Date(), startTime: "09:00", endTime: "17:00")))
    }
}
