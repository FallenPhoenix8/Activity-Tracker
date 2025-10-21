//
//  ActivityAddView.swift
//  Activity Tracker
//

import SwiftUI

struct ActivityAddView: View {
    let maxHoursOfSelected: Double
    let remainingHours: Double
    let currentActivity: ActivityModel?
    let onAddActivity: (String) -> Void
    let onUpdateHours: () -> Void

    @Binding var currentHoursPerDay: Double

    @State private var newName = ""
    @State private var isAdded = false

    var body: some View {
        Form {
            Section {
                VStack {
                    Text("Add a new activity")

                    TextField("Enter new activity", text: $newName)
                        .padding()
                        .background(AppTheme.activeFillStyle)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    if isAdded {
                        HoursSlider(
                            currentActivity: currentActivity,
                            maxHoursOfSelected: maxHoursOfSelected,
                            onUpdateHours: onUpdateHours,
                            currentHoursPerDay: $currentHoursPerDay
                        )
                    }

                    Button("Add") {
                        onAddActivity(newName)
                        isAdded = true
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(remainingHours <= 0)
                }
            }
        }
    }
}

#Preview {
    ActivityAddView(
        maxHoursOfSelected: 8,
        remainingHours: 10,
        currentActivity: nil,
        onAddActivity: { _ in },
        onUpdateHours: {},
        currentHoursPerDay: .constant(10)
    )
}
