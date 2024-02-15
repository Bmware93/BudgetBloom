//
//  SettingsView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var enablePushNotifications = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Notifications")) {
                        Toggle("Receive Push Notifications", isOn: $enablePushNotifications)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
