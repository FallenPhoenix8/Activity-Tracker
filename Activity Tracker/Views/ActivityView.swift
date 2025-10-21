//
//  ActivityView.swift
//  Activity Tracker
//

import Charts
import SwiftData
import SwiftUI

struct ActivityView: View {
    // MARK: - Data Initialization

    @State private var activityVM: ActivityViewModel

    init(modelContext: ModelContext) {
        let activityVM = ActivityViewModel(modelContext: modelContext)
        _activityVM = State(initialValue: activityVM)
    }

    // MARK: - State

    @State private var newName: String = ""
    @State private var currentHoursPerDay: Double = 0
    @State private var currentActivity: ActivityModel? = nil
    @State private var selectCount: Int? = nil

    // MARK: - Computed Properties

    // Should not be more than 24 hours
    var totalHours: Double {
        let hours = activityVM.activities.reduce(0.0) { result, next in
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

    // MARK: - Activity Chart

    var body: some View {
        VStack {
            if activityVM.activities.isEmpty {
                ContentUnavailableView("Enter an Activity", systemImage: "list.dash")
            } else {
                ActivitiesChart(activites: activityVM.activities, currentActivity: currentActivity, selectCount: $selectCount)
            }
            List {
                ForEach(activityVM.activities) { activity in
                    ActivityRow(activity: activity)
                        .contentShape(Rectangle())
                        .listRowBackground(currentActivity?.name == activity.name ? AppTheme.activeRowBackground : AppTheme.clearRowBackground)
                        .onTapGesture {
                            withAnimation {
                                currentActivity = activity
                            }
                        }
                }
                .onDelete { indexSet in
                    activityVM.delete(at: indexSet)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)

            TextField("Enter new activity", text: $newName)
                .padding()
                .background(AppTheme.activeFillStyle)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .gray, radius: 2, x: 0, y: 2)

            if let currentActivity {
                LabeledContent("Hours") {
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
                        if let index = activityVM.activities.firstIndex(where: { $0.name.lowercased() == currentActivity.name.lowercased() }) {
                            activityVM.activities[index].hoursPerDay = currentHoursPerDay
                        }
                    }
                }
            }

            Button("Add") {
                let newActivity = activityVM.add(name: newName, hoursPerDay: 0)
                currentHoursPerDay = 0
                newName = ""
                guard let newActivity else {
                    print("Invalid name")
                    currentActivity = newActivity
                    return
                }

                currentActivity = newActivity
            }
            .buttonStyle(.borderedProminent)
            .disabled(remainingHours <= 0)
        }
        .toolbar {
            EditButton()
                .onChange(of: selectCount) { _, newValue in
                    guard let newValue else { return }
                    withAnimation {
                        getSelected(value: newValue)
                    }
                }
        }
    }

    private func getSelected(value: Int) {
        // Finds activity, accumulating total hours
        var cumulativeTotal = 0.0
        let activity = activityVM.activities.first(where: {
            cumulativeTotal += $0.hoursPerDay
            return Int(cumulativeTotal) >= value
        })
        currentActivity = activity
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var modelContext

    ActivityView(modelContext: modelContext)
        .padding()
        .modelContainer(for: ActivityModel.self)
}
