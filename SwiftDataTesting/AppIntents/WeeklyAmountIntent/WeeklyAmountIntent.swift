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
    func perform() async throws -> some IntentResult & ProvidesDialog & ReturnsValue<Double> {
        let modelContainer = try ModelContainer(for: Expense.self)
        
        let currentDate:Date = Date()
        let expenseData = getWeeklyExpenseSum(modelContext: modelContainer.mainContext, for: currentDate)
        
        let totalSum = expenseData.values.reduce(0.0) {$0 + $1.sum }
        
        if totalSum == 0 {
            return .result(
                value: 0.00,
                dialog: "No expenses recorded this week"
            )
        }
        let formattedSum = currencyFormat(value: totalSum)
        
        return .result(
            value: totalSum,
            dialog: "You have spent a total of \(formattedSum) this week."
        )
    }
}

