//
//  ActivityRow.swift
//  Activity Tracker
//

import SwiftUI

struct ActivityRow: View {
    let activity: ActivityModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(.headline)
                Text("Hours per day: \(activity.hoursPerDay.formatted())")
            }
            Spacer()
            
        }
    }
}

#Preview {
    ActivityRow(activity: .init(name: "Do something", hoursPerDay: 8))
        .padding()
}
