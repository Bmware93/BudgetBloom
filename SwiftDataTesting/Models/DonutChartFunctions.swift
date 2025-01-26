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
