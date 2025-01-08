//
//  ChartFunctions.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 1/7/25.
//

import Foundation

func transactionGroupForCurrentMonth(expenses: [Expense]) -> TransactionGroup {
    var result: TransactionGroup = [:]
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    
    let calendar = Calendar.current
    let currentMonth = calendar.component(.month, from: Date()) // Current month as an integer
    let currentYear = calendar.component(.year, from: Date())

    for expense in expenses {
        let expenseMonth = calendar.component(.month, from: expense.date) 
        let expenseYear = calendar.component(.year, from: expense.date)
        
      
        if expenseMonth == currentMonth && expenseYear == currentYear {
            let month = dateFormatter.string(from: expense.date) // Get the month name
            
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
}

func getMonthlyExpenseSum(expenses: [Expense]) -> TransactionGroup {
    guard !expenses.isEmpty else { return [:] }
    
    var groupedExpenses = TransactionGroup()
    
    for expense in expenses {
        //Getting the month from the expense
        //Short month is the abbreviated version
        let month = expense.shortMonth
        
        // If the month is already a key in the dictionary, append the expense to the existingGrp array
        // and update the sum of values
        if var existingGroup = groupedExpenses[month] {
            existingGroup.expenses.append(expense)
            existingGroup.sum += expense.amount
            
            groupedExpenses[month] = existingGroup
        } else {
            // If the month is not a key in the dictionary, create a new entry with the expense in an array
            // and set the sum of values to the expense value
            groupedExpenses[month] = (expenses: [expense] , sum: expense.amount)
        }
    }
    return groupedExpenses
}

func getDailyExpenseSum(expenses: [Expense], for date: Date) -> TransactionGroup {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    
    // Filter expenses for the specific day
    let filteredExpenses = expenses.filter { expense in
        calendar.isDate(expense.date, inSameDayAs: date)
    }
    
    // Calculate the sum of the filtered expenses
    let totalSum = filteredExpenses.reduce(0.0) { $0 + $1.amount }
    
    // Format the date as a string key
    let dateKey = dateFormatter.string(from: date)
    
    // Return the TransactionGroup
    return [dateKey: (expenses: filteredExpenses, sum: totalSum)]
}

