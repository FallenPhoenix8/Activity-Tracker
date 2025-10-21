//
//  HoursSlider.swift
//  Activity Tracker
//

import SwiftUI

struct HoursSlider: View {
    let currentActivity: ActivityModel?
    let maxHoursOfSelected: Double
    let onUpdateHours: () -> Void
    @Binding var currentHoursPerDay: Double
    var body: some View {
        if let currentActivity {
            LabeledContent("\(currentHoursPerDay.formatted()) Hours") {
                Slider(
                    value: $currentHoursPerDay,
                    in: 0 ... maxHoursOfSelected,
                    step: 0.5
                ) {
                    Text("Hours for \(currentActivity.name)")
                } currentValueLabel: {
                    Text("\(currentHoursPerDay, specifier: "%.1f") h")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                .onChange(of: currentHoursPerDay) { _, _ in
                    onUpdateHours()
                }
            }
        }
    }
}

#Preview {
    HoursSlider(
        currentActivity: ActivityModel(name: "Do something", hoursPerDay: 5),
        maxHoursOfSelected: 10,
        onUpdateHours: {},
        currentHoursPerDay: .constant(12)
    )
}
