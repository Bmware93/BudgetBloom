//
//  YTDHelper.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/3/25.
//

import Foundation
import SwiftData

func getYTDExpenseSum(modelContext: ModelContext, for date: Date) -> TransactionGroup {
    var result: TransactionGroup = [:]
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: date)
    
    do {
        let fetchDescriptor = FetchDescriptor<Expense>()
        let expenses = try modelContext.fetch(fetchDescriptor)
        
        for expense in expenses {
            let expenseYear = calendar.component(.year, from: expense.date)
            
            // Only include expenses from the current year
            if expenseYear == currentYear {
                let monthKey = dateFormatter.string(from: expense.date)
                
                if var monthData = result[monthKey] {
                    monthData.expenses.append(expense)
                    monthData.sum += expense.amount
                    result[monthKey] = monthData
                } else {
                    result[monthKey] = (expenses: [expense], sum: expense.amount)
                }
            }
        }
        
        return result
        
    } catch {
        print("Failed to fetch YTD expenses: \(error)")
        return [:]
    }
}
