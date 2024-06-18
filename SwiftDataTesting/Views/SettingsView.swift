//
//  SettingsView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var enablePushNotifications = false
    @State private var currencyCode: CurrencyCode = .USD
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Preferences")) {
                        
                        Toggle("Push Notifications", systemImage: "bell.circle.fill", isOn: $enablePushNotifications)
                            .toggleStyle(SwitchToggleStyle(tint: .DarkBlue))
                            .foregroundStyle(.primary)
                        
                        Picker("Currency", systemImage: "dollarsign.circle.fill", selection: $currencyCode) {
                            ForEach(CurrencyCode.allCases, id: \.self) { code in
                                Text(code.rawValue)
                            }
                        }
                        .foregroundColor(.primary)
                        .pickerStyle(.navigationLink)
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
