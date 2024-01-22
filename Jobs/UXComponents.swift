//
//  UXComponents.swift
//  Jobs
//
//  Created by Daniel Watson on 14.12.23.
//

extension View {
    func applyCommonNavigationModifiers(navigationPath: Binding<NavigationPath>) -> some View {
        self.modifier(CommonNavigationModifiers(navigationPath: navigationPath))
    }
}

struct CommonNavigationModifiers: ViewModifier {
    @Binding var navigationPath: NavigationPath

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                bottomToolbar(navigationPath: $navigationPath)
                menuToolbar(navigationPath: $navigationPath)
                topRightToolBar(navigationPath: $navigationPath)
            }
            .transition(.slide)
    }
}

import SwiftUI
// MARK: - UXComponents View (for Preview)

struct UXComponents: View {
    @State private var int = 0
    @State private var string = "sample"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Atoms").font(.headline).padding(.top)
                // Atom Components
                CustomLabel(text: "Sample Label", style: .primary)
                CustomTextField(placeholder: "Primary Text Field", text: $string, style: .primary)
                CustomButton(title: "Primary Button", action: {}, style: .primary)
                CustomButton(title: "Icon Button", action: {
                }, style: .primary, iconName: "plus.circle.fill")

                CustomSecureField(placeholder: "Password", text: $string, style: .primary)
                TimePickerComponent(label: "Hour", selection: $int, range: 0...23, style: StyleType.forTimeType(.start)) // Included as an atom
                
                Text("Molecules").font(.headline).padding(.top)
                // Molecule Components
                TimePicker(selectedHour: $int, selectedMinute: $int, startOrFinish: .end)

                ShiftCalendarCellView(
                    shift: JobManager.Shift(date: Date()),
                    style: StyleType.primary.style
                )
                ShiftCalendarCellView(
                    shift: JobManager.Shift(date: Date()),
                    style: StyleType.secondary.style
                )


                Text("Organisms").font(.headline).padding(.top)
                // Organism Components
            }
        }
    }
}

#Preview {
    UXComponents()
}

// MARK: - Atoms
// These are the basic building blocks of the UI.

struct CustomLabel: View {
    var text: String
    var style: StyleType

    var body: some View {
        Text(text)
            .modifier(CustomLabelStyle(style: style))
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var style: StyleType

    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(CustomTextFieldStyle(style: style.style))
    }
}
struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    var style: StyleType

    var body: some View {
        SecureField(placeholder, text: $text)
            .textFieldStyle(CustomTextFieldStyle(style: style.style))
    }
}

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var style: StyleType
    var iconName: String? // Optional icon name

    var body: some View {
        Button(action: action) {
            HStack {
                if let iconName = iconName {
                    Image(systemName: iconName) // Display the icon if provided
                        .font(.title)
                }
                Text(title)
                    .fontWeight(.bold)
            }
        }
        .buttonStyle(CustomButtonStyle(style: style.style))
    }
}


struct TimePickerComponent: View {
    var label: String
    @Binding var selection: Int
    var range: ClosedRange<Int>
    var step: Int = 1 // Step parameter reintroduced
    var style: Style

    var body: some View {
        Picker(label, selection: $selection) {
            ForEach(range, id: \.self) { index in
                Text("\(index * step)")
                    .tag(index)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(width: 60, height: 100)
        .background(style.backgroundColor.opacity(0.8))
        .cornerRadius(style.cornerRadius)
        .shadow(radius: style.shadowRadius)
    }
}



// MARK: - Molecules
// These are combinations of one or more atoms.


struct TimePicker: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    var startOrFinish: TimeType

    var body: some View {
        HStack(spacing: 10) {
            TimePickerComponent(
                label: "Hour",
                selection: $selectedHour,
                range: 0...23,
                step: 1, // Step for hours
                style: StyleType.forTimeType(startOrFinish) // Style based on startOrFinish
            )
            TimePickerComponent(
                label: "Minute",
                selection: $selectedMinute,
                range: 0...59,
                step: 15, // Step for minutes
                style: StyleType.forTimeType(startOrFinish) // Same style for minutes
            )
        }
    }
}

struct ShiftCalendarCellView: View {
    var shift: JobManager.Shift
    var style: Style // Add a style parameter

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
                .foregroundColor(style.foregroundColor)
            Text(dayNumber)
                .font(.headline)
                .foregroundColor(style.foregroundColor)
        }
        .frame(width: 60, height: 60) // Adjusted for better appearance
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
        .shadow(radius: style.shadowRadius)
        .padding(.horizontal)
    }
}

// MARK: - Supporting Structures, Enums, Styles

struct Style {
    let foregroundColor: Color
    let backgroundColor: Color
    let shadowRadius: CGFloat = 5
    let cornerRadius: CGFloat = 5

    // Initialize with default values for shadow radius and corner radius
    init(foregroundColor: Color, backgroundColor: Color) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
}

enum StyleType {
    case primary, secondary

    var style: Style {
        switch self {
        case .primary:
            return Style(
                foregroundColor: Color("PrimaryColour"),
                backgroundColor: Color("SecondaryColour")
            )
        case .secondary:
            return Style(
                foregroundColor: Color("SecondaryColour"),
                backgroundColor: Color("PrimaryColour")
            )
        }
    }
}
extension StyleType {
    static func forTimeType(_ timeType: TimeType) -> Style {
        switch timeType {
        case .start:
            return Style(
                foregroundColor: Color.green,
                backgroundColor: Color.green.opacity(0.2)
            )
        case .end:
            return Style(
                foregroundColor: Color.red,
                backgroundColor: Color.red.opacity(0.2)
            )
        }
    }
}

struct CustomLabelStyle: ViewModifier {
    var style: StyleType

    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .foregroundColor(style.style.foregroundColor)
            .padding()
            .cornerRadius(style.style.cornerRadius)
    }
}


struct CustomButtonStyle: ButtonStyle {
    var style: Style
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(style.foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .shadow(radius: style.shadowRadius)
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    var style: Style
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .shadow(radius: style.shadowRadius)
            .padding(.horizontal)
    }
}

enum TimeType {
    case start, end
}

