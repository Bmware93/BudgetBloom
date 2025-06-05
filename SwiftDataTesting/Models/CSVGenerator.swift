//
//  CSVGenerator.swift
//  SwiftDataExpensesTracker
//
//  Created by Benia Morgan-Ware on 6/5/25.
//

import Foundation
import SwiftData

@MainActor
func generateCSVFromExpenses(modelContainer: ModelContainer) throws -> String {
    let modelContainer = try ModelContainer(for: Expense.self)
    let fetchDescriptor = FetchDescriptor<Expense>()
    let expenses = try modelContainer.mainContext.fetch(fetchDescriptor)
    
    let csvHeader = "Date, Name, Amount, Category, Description"

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let csvBody: String = expenses.map {
        "\(dateFormatter.string(from: $0.date)), \($0.name), \($0.amount), \($0.category.rawValue), \(escapeCSVField($0.expenseDescription))"
    }.joined(separator: "\n")
    
    return csvHeader + "\n" + csvBody
}

func escapeCSVField(_ field: String) -> String {
    if field.contains(",") || field.contains("\"") || field.contains("\n") {
        let escapedField = field.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escapedField)\""
    }
    return field
}
