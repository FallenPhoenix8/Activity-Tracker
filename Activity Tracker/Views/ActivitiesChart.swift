//
//  ActivitiesChart.swift
//  Activity Tracker
//

import Charts
import SwiftUI

struct ActivitiesChart: View {
    let activites: [ActivityModel]
    let currentActivity: ActivityModel?
    @Binding var selectCount: Int?

    // MARK: - Chart Properties

    var innerRadius: MarkDimension = .ratio(0.6)
    var outerRadius: MarkDimension = .ratio(1.05)
    var outerRadiusActive: MarkDimension = .ratio(0.95)
    var angularInset: CGFloat = 1

    var body: some View {
        Chart {
            ForEach(activites) { activity in
                let isSelected: Bool = activity.name == currentActivity?.name
                SectorMark(
                    angle: .value("Activites", activity.hoursPerDay),
                    innerRadius: innerRadius,
                    outerRadius: isSelected ? outerRadius : outerRadiusActive,
                    angularInset: angularInset
                )
                .cornerRadius(10)
                .foregroundStyle(by: .value("activity", activity.name))
                .opacity(isSelected ? 1 : 0.8)
            }
        }
        .chartAngleSelection(value: $selectCount)
        .chartBackground { _ in
            VStack {
                if let currentActivity {
                    Image(systemName: "figure.walk")
                        .imageScale(.large)
                        .foregroundStyle(AppTheme.activeFillStyle)

                    let truncatedName = String(currentActivity.name.prefix(11))
                    Text(truncatedName == currentActivity.name ? truncatedName : "\(truncatedName)...")
                }
            }
        }
    }
}

#Preview {
    let currentActivity = ActivityModel(name: "Do something", hoursPerDay: 5)
        let activities = [
            ActivityModel(name: "Do something else", hoursPerDay: 5),

            ActivityModel(name: "Do something different", hoursPerDay: 5)
        ]
    ActivitiesChart(activites: activities, currentActivity: currentActivity, selectCount: .constant(0))
}
