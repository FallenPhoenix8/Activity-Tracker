//
//  ContentView.swift
//  Activity Tracker
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        NavigationStack {
            ActivityView(modelContext: modelContext)
                .padding()
                .navigationTitle("Activity Tracker")
        }
    }
}

#Preview {
    ContentView()
}
