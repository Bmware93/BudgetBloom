//
//  MonthlySpendIntent.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/2/25.
//

import Foundation
import AppIntents
import SwiftData

struct MonthlySpendIntent: AppIntent {
    static var title: LocalizedStringResource = "Check this month's spending"
    static var description: IntentDescription = "Check on much you've spent this month."
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ReturnsValue<Double> {
        let modelContainer = try ModelContainer(for: Expense.self)
        let currentDate: Date = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        
        let expenseData = getMonthlyExpenseSumIntent(modelContext: modelContainer.mainContext, for: currentDate)
        guard let firstEntry = expenseData.elements.first else {
                    return .result(
                      value: 0.00,
                      dialog: "Looks like you haven’t made any purchases today."
                    )
                }

        let totalSum = currencyFormat(value: firstEntry.value.sum)

        return .result(
          value: firstEntry.value.sum,
          dialog: "For the current month of \(currentMonth), you have spent a total of \(totalSum) so far."
        )
        
    }
}
