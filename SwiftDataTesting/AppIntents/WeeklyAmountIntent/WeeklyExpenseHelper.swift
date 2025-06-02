//
//  WeeklyExpenseHelper.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 5/30/25.
//

import Foundation
import SwiftData

@MainActor
func getWeeklyExpenseSumIntent(modelContext: ModelContext, for date: Date) -> TransactionGroup {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
   
        do {
            let fetchDescriptor = FetchDescriptor<Expense>()
            let expenses = try modelContext.fetch(fetchDescriptor)
            
            // Filtering expenses within the same week as the given date
            let weeklyExpenses = expenses.filter { expense in
                guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else { return false }
                return calendar.compare(expense.date, to: startOfWeek, toGranularity: .weekOfYear) == .orderedSame
            }
            
            // Group expenses by day within the week
            var groupedExpenses = TransactionGroup()
            for expense in weeklyExpenses {
                let dayKey = dateFormatter.string(from: expense.date)
                if groupedExpenses[dayKey] == nil {
                    groupedExpenses[dayKey] = (expenses: [], sum: 0.0)
                }
                groupedExpenses[dayKey]?.expenses.append(expense)
                groupedExpenses[dayKey]?.sum += expense.amount
            }
            return groupedExpenses
        } catch {
            print("Failed to fetch expenses: \(error)")
            return [:]
        }
}
        

