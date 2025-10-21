//
//  ActivityModel.swift
//  Activity Tracker
//

import Foundation
import SwiftData

@Model
class ActivityModel {
    @Attribute(.unique) var id: String = UUID().uuidString

    var name: String
    var hoursPerDay: Double

    init(name: String, hoursPerDay: Double = 0) {
        self.name = name
        self.hoursPerDay = hoursPerDay
    }
}
