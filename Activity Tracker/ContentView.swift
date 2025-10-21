//
//  ContentView.swift
//  Activity Tracker
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ActivityView()
            }
            .padding()
            .navigationTitle("Activity Tracker")
        }
    }
}

#Preview {
    ContentView()
}
