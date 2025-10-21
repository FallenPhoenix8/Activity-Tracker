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

    @State private var currentHoursPerDay: Double = 0
    @State var currentActivity: ActivityModel? = nil
    @State var selectCount: Int? = nil
    @State var isPresentedAddView = false

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

            HoursSlider(
                currentActivity: currentActivity,
                maxHoursOfSelected: maxHoursOfSelected,
                onUpdateHours: onUpdateHours,
                currentHoursPerDay: $currentHoursPerDay
            )
        }
        .toolbar {
            ToolbarItem {
                EditButton()
                    .onChange(of: selectCount) { _, newValue in
                        guard let newValue else { return }
                        withAnimation {
                            getSelected(value: newValue)
                        }
                    }
            }

            ToolbarItem {
                Button("Add", systemImage: "plus") {
                    isPresentedAddView = true
                }
                .sheet(isPresented: $isPresentedAddView) {
                    ActivityAddView(
                        maxHoursOfSelected: maxHoursOfSelected, remainingHours: remainingHours, currentActivity: currentActivity, onAddActivity: onAddActivity, onUpdateHours: {
                            onUpdateHours()
                        }, currentHoursPerDay: $currentHoursPerDay,
                    )
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

    private func onUpdateHours() {
        if let index = activityVM.activities.firstIndex(where: { $0.name.lowercased() == currentActivity?.name.lowercased() }) {
            activityVM.activities[index].hoursPerDay = currentHoursPerDay
        }
    }

    private func onAddActivity(name: String) {
        let newActivity = activityVM.add(name: name, hoursPerDay: 0)
        currentHoursPerDay = 0
        guard let newActivity else {
            print("Invalid name")
            currentActivity = newActivity
            return
        }

        currentActivity = newActivity
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var modelContext

    ActivityView(modelContext: modelContext)
        .padding()
        .modelContainer(for: ActivityModel.self)
}
