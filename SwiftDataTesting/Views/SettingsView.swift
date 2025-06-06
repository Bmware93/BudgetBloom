//
//  SettingsView.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/29/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query var expenses: [Expense]
    @State private var showingShareSheet = false
    @State private var csvFileURL: URL?
    @State private var showingExportError = false
    @State private var exportErrorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Share")) {
                        Menu("Export Data", systemImage: "square.and.arrow.up") {
                            Button("All Transactions") {
                                exportExpenses(expenses)
                            }
                            Button("Current Month only") {
                                let currentMonthExpenses = transactionGroupForCurrentMonth(expenses: expenses, for: Date()).elements.first
                                exportExpenses(currentMonthExpenses?.value.expenses ?? [])
                                
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

private func exportExpenses(_ expensesToExport: [Expense]) {
     guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController else {
         print("Could not find root view controller")
         return
     }
     
     Task {
         await CSVExportManager.exportCSV(expenses: expensesToExport, from: rootViewController)
     }
 }

#Preview {
    SettingsView()
}
