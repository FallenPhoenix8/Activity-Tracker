//
//  ActivityViewModel.swift
//  Activity Tracker
//

import Foundation
import Observation
import SwiftData

@Observable
class ActivityViewModel {
    var modelContext: ModelContext
    var activities = [ActivityModel]()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchData() {
        do {
            let descriptor = FetchDescriptor<ActivityModel>(sortBy: [SortDescriptor(\.name)])
            activities = try modelContext.fetch(descriptor)
        } catch {
            print("Activity fetch failed.")
        }
    }

    func add(name: String, hoursPerDay: Double) -> ActivityModel? {
        // Check validity
        let isRepeated = activities.contains(where: { $0.name.lowercased() == name.lowercased() })
        if name.count <= 2 || isRepeated {
            return nil
        }

        let activity = ActivityModel(name: name, hoursPerDay: hoursPerDay)
        modelContext.insert(activity)
        return activity
    }

    func delete(at offsets: IndexSet) -> ActivityModel? { nil /* TODO: IMPLEMENT */ }
}
