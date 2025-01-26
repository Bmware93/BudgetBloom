//
//  DonutChartFunctions.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/26/25.
//

import Foundation

func getTodayCategoryTotals(from expenses: [Expense]) -> [CategoryTotal] {
    // Get today's date components
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    // Filter expenses to include only those made today
    let todayExpenses = expenses.filter { expense in
        let expenseDate = calendar.startOfDay(for: expense.date)
        return expenseDate == today
    }
    
    // Group and sum expenses by category
    let categoryTotals = Dictionary(grouping: todayExpenses, by: { $0.category })
        .map { category, expenses in
            CategoryTotal(category: category, total: expenses.reduce(0) { $0 + $1.amount })
        }
    
    return categoryTotals
}

func getWeekCategoryTotals(from expenses: [Expense]) -> [CategoryTotal] {
    let calendar = Calendar.current
    let now = Date()

    // Get the start and end of the current week
    guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
          let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) else {
        return []
    }

    // Filter expenses that fall within the current week
    let weekExpenses = expenses.filter { expense in
        expense.date >= weekStart && expense.date <= weekEnd
    }

    // Group and sum expenses by category
    let categoryTotals = Dictionary(grouping: weekExpenses, by: { $0.category })
        .map { category, expenses in
            CategoryTotal(category: category, total: expenses.reduce(0) { $0 + $1.amount })
        }

    return categoryTotals
}
