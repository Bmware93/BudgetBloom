//
//  AppTabView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI

struct AppTabView: View {

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Expenses", systemImage: "creditcard")
                }
            
            ChartsView()
                .tabItem {
                    Label("Summary", systemImage: "chart.bar.xaxis")
                }
            
            SettingsView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
            
        }
    }
}

#Preview {
    let preview = previewContainer([Expense.self])
    return AppTabView().modelContainer(preview.container)
}
