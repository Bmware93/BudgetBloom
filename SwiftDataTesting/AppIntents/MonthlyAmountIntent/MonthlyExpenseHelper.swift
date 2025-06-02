//
//  MonthlyExpenseHelper.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/2/25.
//

import Foundation
import SwiftData

func getMonthlyExpenseSumIntent(modelContext: ModelContext, for date: Date) -> TransactionGroup {
    var result: TransactionGroup = [:]
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    let currentMonth = calendar.component(.month, from: Date()) //Current month as an integer
    let currentYear = calendar.component(.year, from: Date())
    
    do {
        let fecthDescriptor = FetchDescriptor<Expense>()
        let expenses = try modelContext.fetch(fecthDescriptor)

        for expense in expenses {
            let expenseMonth = calendar.component(.month, from: expense.date)
            let expenseYear = calendar.component(.year, from: expense.date)
            
          
            if expenseMonth == currentMonth && expenseYear == currentYear {
                let month = dateFormatter.string(from: expense.date) //Get the month name
                
                if var monthData = result[month] {
         
                    monthData.expenses.append(expense)
                    monthData.sum += expense.amount
                    result[month] = monthData
                } else {
               
                    result[month] = (expenses: [expense], sum: expense.amount)
                }
            }
        }
        return result
        
    } catch {
        print("Failed to fetch montlhy expense sum: \(error)")
        return [:]
    }
    
}
