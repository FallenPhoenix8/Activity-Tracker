//
//  ActivityView.swift
//  Activity Tracker
//

import Charts
import SwiftData
import SwiftUI

struct ActivityView: View {
    // MARK: - Constants

    let hoursPerDayStep: Double = 0.2

    // MARK: - Data Initialization

    @Query(sort: \ActivityModel.name, order: .forward)
    var activities: [ActivityModel]

    @Environment(\.modelContext) private var context

    // MARK: - State

    @State private var newName: String = ""
    @State private var currentHoursPerDay: Double = 0
    @State private var currentActivity: ActivityModel? = nil
    @State private var selectCount: Int? = nil

    // MARK: - Computed Properties

    // Should not be more than 24 hours
    var totalHours: Double {
        let hours = activities.reduce(0.0) { result, next in
            result + next.hoursPerDay
        }
        return hours
    }

    var remainingHours: Double {
        24 - totalHours
    }

    var maxHoursOfSelected: Double {
        remainingHours + currentHoursPerDay
    }

    // MARK: - Chart Properties

    var innerRadius: MarkDimension = .ratio(0.6)
    var outerRadius: MarkDimension = .ratio(1.05)
    var angularInset: CGFloat = 1

    // MARK: - Activity Chart

    var body: some View {
        Chart {
            ForEach(activities) { activity in
                SectorMark(
                    angle: .value("Activites", activity.hoursPerDay),
                    innerRadius: innerRadius,
                    outerRadius: outerRadius,
                    angularInset: angularInset
                )
            }
        }
        .chartAngleSelection(value: $selectCount)

        List(activities) { activity in
            Text(activity.name)
                .onTapGesture {
                    withAnimation {
                        currentActivity = activity
                    }
                }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)

        if let currentActivity {
            Slider(value: $currentHoursPerDay, in: 0 ... maxHoursOfSelected, step: hoursPerDayStep)
                .onChange(of: currentHoursPerDay) { _, _ in
                    // TODO: Implement changing of hours per day in model
                }
        }

        Button("Add") {
            addActivity()
        }
        .buttonStyle(.borderedProminent)
        .disabled(remainingHours <= 0)
    }

    private func addActivity() {
        // TODO: Implement
    }

    private func deleteActivity(at offsets: IndexSet) {
        // TODO: Implement
    }
}

#Preview {
    ActivityView()
}
