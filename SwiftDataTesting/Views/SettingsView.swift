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
                                CSVExportManager.exportFromSwiftUI(expenses: expenses)
                            }
                            
                            Button("Current Month only") {
                                let currentMonthExpenses = getMonthlyExpenseSum(expenses: expenses, for: Date()).elements.first
                                CSVExportManager.exportFromSwiftUI(expenses: currentMonthExpenses?.value.expenses ?? [])
                            }
                            
                            Button("Year to date") {
                                let ytdExpenses = getYTDExpenseSum(expenses: expenses, for: Date()).elements.values
                                CSVExportManager.exportFromSwiftUI(expenses: ytdExpenses.flatMap(\.expenses))
                            }
                        }
                        .disabled(expenses.isEmpty)
                    }
                    
                }
            }
            .navigationTitle("Menu")
            
            
        }
    }
}


#Preview {
    SettingsView()
}
