//
//  Activity_TrackerApp.swift
//  Activity Tracker
//

import SwiftData
import SwiftUI

@main
struct Activity_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ActivityModel.self)
    }
}
