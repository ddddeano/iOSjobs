//
//  UXComponents.swift
//  Jobs
//
//  Created by Daniel Watson on 14.12.23.
//

import SwiftUI

struct UXComponents: View {
    
    @State private var selectedEndHour = 0
    @State private var selectedEndMinute = 0
    
    var body: some View {
        VStack {
            SubmitButtonView(text: "Example Text", action: {})
            TimePicker(selectedHour: $selectedEndHour, selectedMinute: $selectedEndMinute, startOrFinish: .end)
            ShiftCalendarCellView(shift: JobManager.Shift(date: Date()))
            DashboardButton(title: "test", iconName: "plus.circle.fill") {
                print("click")
            }
        }
    }
}

#Preview {
    UXComponents()
}

struct SubmitButtonView: View {
    var text: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
        }
        .buttonStyle(ScalingButtonStyle())
    }
}

struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct TimePicker: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    var startOrFinish: TimeType
    let cornerRadius: CGFloat = 10
    let width: CGFloat = 50
    let height: CGFloat = 80
    let opacity: Double = 0.2
    let fontSize: CGFloat = 18  // Variable for font size

    var body: some View {
         HStack(spacing: 10) { // Increased spacing
             Picker("Hour", selection: $selectedHour) {
                 ForEach(0..<24, id: \.self) {
                     Text("\($0)")
                         .tag($0)
                         .font(.system(size: fontSize))
                         .padding(.vertical, 20) // Added vertical padding
                 }
             }
             .pickerStyle(WheelPickerStyle())
             .frame(width: width, height: height)
             .background(startOrFinish == .start ? Color.green.opacity(opacity) : Color.red.opacity(opacity))
             .cornerRadius(cornerRadius)
             .compositingGroup() // This can help with clarity
             .shadow(radius: 3)   // Adding a subtle shadow for depth

             Picker("Minute", selection: $selectedMinute) {
                 ForEach(0..<4, id: \.self) { index in
                     Text(String(format: "%02d", index * 15))
                         .tag(index)
                         .font(.system(size: fontSize))
                 }
             }
             .pickerStyle(WheelPickerStyle())
             .frame(width: width, height: height)
             .background(startOrFinish == .start ? Color.green.opacity(opacity) : Color.red.opacity(opacity))
             .cornerRadius(cornerRadius)
             .compositingGroup()
             .shadow(radius: 3)
         }
     }
}

enum TimeType {
    case start, end
}

// Example usage
struct TimePicker_Previews: PreviewProvider {
    @State static var selectedHour: Int = 9
    @State static var selectedMinute: Int = 0

    static var previews: some View {
        TimePicker(selectedHour: $selectedHour, selectedMinute: $selectedMinute, startOrFinish: .start)
    }
}

struct ShiftCalendarCellView: View {
    var shift: JobManager.Shift
    
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
        VStack {
            Text(day)
                .font(.subheadline)
            Text(dayNumber)
                .font(.headline)
        }
        .frame(width: 50, height: 50)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
struct DashboardButton: View {
    var title: String
    var iconName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.title)
                Text(title)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}


struct DashboardButton_Previews: PreviewProvider {
    static var previews: some View {
        DashboardButton(title: "Example Button", iconName: "star.fill") {
            
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
