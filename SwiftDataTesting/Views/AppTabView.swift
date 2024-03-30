//
//  AppTabView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI

struct AppTabView: View {
    
    var body: some View {
        //Repeating onAppear modifier for haptic feedback on each tab item.. Is there a better way?
        
        TabView {
            ContentView()
                .tabItem {
                    Label("Spending", systemImage: "creditcard")
                }
                .onAppear {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            
            ChartsView()
                .tabItem {
                    Label("Summary", systemImage: "chart.bar.xaxis")
                }
                .onAppear {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            
            
            SettingsView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .onAppear {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            }
        
        }
    }

#Preview {
    let preview = previewContainer([Expense.self])
    return AppTabView().modelContainer(preview.container)
}
