//
//  ExpenseHelper.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 3/4/25.
//

import SwiftData
import SwiftUI

@MainActor
func getDailyExpenseSum(modelContext: ModelContext, for date: Date) -> TransactionGroup {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    if createModelContext() != nil {
        
    }
    do {
        let fetchDescriptor = FetchDescriptor<Expense>()
        let expenses = try modelContext.fetch(fetchDescriptor)

        // Filter expenses for the specific day
        let filteredExpenses = expenses.filter { expense in
            calendar.isDate(expense.date, inSameDayAs: date)
        }
        
        let totalSum = filteredExpenses.reduce(0.0) { $0 + $1.amount }
        if totalSum == 0 {
            return [:]
        }

        let dateKey = dateFormatter.string(from: date)
        return [dateKey: (expenses: filteredExpenses, sum: totalSum)]
    } catch {
        print("Failed to fetch expenses: \(error)")
        return [:]
    }
}

