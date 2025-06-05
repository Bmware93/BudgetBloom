//
//  SettingsView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var enablePushNotifications = false
    @State var currencyCode: CurrencyCode = .USD
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Share")) {
                        Menu("Export Data", systemImage: "square.and.arrow.up") {
                            Button("All Transactions") {
                                
                            }
                            Button("Current Month only") {
                                
                            }
                            Button("Year to date") {
                                
                            }
                        }
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
