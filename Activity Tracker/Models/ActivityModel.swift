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

    init(id: String, name: String, hoursPerDay: Double = 0) {
        self.id = id
        self.name = name
        self.hoursPerDay = hoursPerDay
    }
}
