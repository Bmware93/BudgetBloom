//
//  YearAmountIntent.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/3/25.
//

import Foundation
import AppIntents
import SwiftData

struct YearAmountIntent: AppIntent {
    static var title: LocalizedStringResource = "YTD Spending"
    static var description: IntentDescription = "Check your year-to-date spending"
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ReturnsValue<Double> {
        let modelContainer = try ModelContainer(for: Expense.self)
        let currentDate: Date = Date()
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "MMMM yyyy"
        let currentMonthAndYear = dateFormatter.string(from: currentDate)
        
        let expenseData = getYTDExpenseSumIntent(modelContext: modelContainer.mainContext, for: currentDate)
        
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
            dialog: "Your year-to-date spending as of \(currentMonthAndYear) is currently \(formattedSum)"
        )

    }
}
