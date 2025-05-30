//
//  WeeklyAmountIntent.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 5/30/25.
//

import Foundation
import AppIntents
import SwiftData


struct WeeklyAmountIntent: AppIntent {
    static var title: LocalizedStringResource = "Check this weeks spending" 
    static var description: IntentDescription = "Check how much you've spent this week"
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let modelContainer = try ModelContainer(for: Expense.self)
        
        let currentDate:Date = Date()
        let expenseData = getWeeklyExpenseSumIntent(modelContext: modelContainer.mainContext, for: currentDate)
        
        guard let firstEntry = expenseData.values.first else {
            return .result(
                value: "",
                dialog: "No expenses recorded this week")
        }
        
        
        
        return .result(
        value: "",
        dialog: "")
    }
}

